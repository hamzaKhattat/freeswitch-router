// src/validation/call_validator.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include "validation/call_validator.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

// Helper function to find validation record
static call_validation_record_t* find_validation_record(call_validator_t *validator, 
                                                        const char *call_id) {
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t *record = validator->active_validations;
    while (record) {
        if (strcmp(record->call_id, call_id) == 0) {
            pthread_mutex_unlock(&validator->validation_mutex);
            return record;
        }
        record = record->next;
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    return NULL;
}

// Helper function to create validation record
static call_validation_record_t* create_validation_record(const char *call_id,
                                                          const char *ani,
                                                          const char *dnis) {
    call_validation_record_t *record = calloc(1, sizeof(call_validation_record_t));
    if (!record) return NULL;
    
    strncpy(record->call_id, call_id, sizeof(record->call_id) - 1);
    strncpy(record->origin_ani, ani, sizeof(record->origin_ani) - 1);
    strncpy(record->origin_dnis, dnis, sizeof(record->origin_dnis) - 1);
    
    record->current_state = CALL_STATE_ORIGINATED;
    record->expected_state = CALL_STATE_RINGING;
    record->originated_at = time(NULL);
    record->state_timestamp = record->originated_at;
    record->validation_attempts = 0;
    
    // Generate UUID for tracking
    snprintf(record->call_uuid, sizeof(record->call_uuid), 
            "%ld-%s", time(NULL), call_id);
    
    return record;
}

// Validation thread function
static void* validation_thread_func(void *arg) {
    call_validator_t *validator = (call_validator_t*)arg;
    
    LOG_INFO("Call validation thread started");
    
    while (validator->running) {
        time_t now = time(NULL);
        
        pthread_mutex_lock(&validator->validation_mutex);
        
        call_validation_record_t **pp = &validator->active_validations;
        while (*pp) {
            call_validation_record_t *record = *pp;
            bool should_remove = false;
            
            // Check validation timeout (30 seconds without state change)
            if ((now - record->state_timestamp) > 30) {
                if (record->current_state == CALL_STATE_ORIGINATED) {
                    LOG_WARN("Call %s: No ringing confirmation after 30s - forcing hangup",
                            record->call_id);
                    
                    // Log security event
                    log_security_event(validator, "VALIDATION_TIMEOUT", "HIGH",
                                     record->call_id, 
                                     "Call did not progress to ringing state");
                    
                    // Force hangup to avoid charges
                    force_hangup_invalid_call(validator, record->call_id);
                    
                    record->current_state = CALL_STATE_FAILED;
                    validator->stats.failed_validations++;
                    should_remove = true;
                }
            }
            
            // Check for state mismatches
            if (record->current_state != record->expected_state && 
                record->validation_attempts > 3) {
                LOG_ERROR("Call %s: State mismatch detected - Expected: %d, Current: %d",
                         record->call_id, record->expected_state, record->current_state);
                
                log_security_event(validator, "STATE_MISMATCH", "CRITICAL",
                                 record->call_id,
                                 "Call state does not match expected progression");
                
                force_hangup_invalid_call(validator, record->call_id);
                validator->stats.diverted_calls++;
                should_remove = true;
            }
            
            // Perform periodic validation checks
            if ((now - record->last_validation) >= validator->validation_interval_ms / 1000) {
                record->validation_attempts++;
                record->last_validation = now;
                
                // Query destination server for call state
                char query[512];
                snprintf(query, sizeof(query),
                        "SELECT status FROM active_calls "
                        "WHERE call_id = '%s' AND destination_ip = '%s'",
                        record->call_id, record->destination_server_ip);
                
                db_result_t *result = db_query(validator->db, query);
                if (result && result->num_rows > 0) {
                    const char *remote_status = db_get_value(result, 0, 0);
                    
                    // Validate state consistency
                    if (strcmp(remote_status, "ringing") == 0 && 
                        record->current_state == CALL_STATE_ORIGINATED) {
                        record->current_state = CALL_STATE_RINGING;
                        record->expected_state = CALL_STATE_ANSWERED;
                        record->destination_validated = true;
                        LOG_INFO("Call %s: Validated ringing at destination", record->call_id);
                    } else if (strcmp(remote_status, "answered") == 0 &&
                             record->current_state == CALL_STATE_RINGING) {
                        record->current_state = CALL_STATE_ANSWERED;
                        record->expected_state = CALL_STATE_HUNG_UP;
                        record->answered_at = now;
                        LOG_INFO("Call %s: Validated answered at destination", record->call_id);
                    }
                    
                    db_free_result(result);
                } else {
                    LOG_WARN("Call %s: Cannot verify state with destination server",
                            record->call_id);
                }
            }
            
            // Remove completed or failed calls after 60 seconds
            if ((record->current_state == CALL_STATE_HUNG_UP ||
                 record->current_state == CALL_STATE_FAILED) &&
                (now - record->state_timestamp) > 60) {
                should_remove = true;
            }
            
            if (should_remove) {
                *pp = record->next;
                free(record);
            } else {
                pp = &record->next;
            }
        }
        
        pthread_mutex_unlock(&validator->validation_mutex);
        
        // Sleep for validation interval
        usleep(validator->validation_interval_ms * 1000);
    }
    
    LOG_INFO("Call validation thread stopped");
    return NULL;
}

// Public API implementation
call_validator_t* call_validator_create(database_t *db, router_t *router) {
    call_validator_t *validator = calloc(1, sizeof(call_validator_t));
    if (!validator) return NULL;
    
    validator->db = db;
    validator->router = router;
    validator->running = false;
    
    // Default configuration
    validator->validation_interval_ms = 5000;  // Check every 5 seconds
    validator->validation_timeout_ms = 30000;  // 30 second timeout
    validator->max_validation_attempts = 5;
    validator->strict_mode = true;
    
    pthread_mutex_init(&validator->validation_mutex, NULL);
    
    // Create validation tables if they don't exist
    const char *create_tables = 
        "CREATE TABLE IF NOT EXISTS call_validations ("
        "  id SERIAL PRIMARY KEY,"
        "  call_id VARCHAR(256) UNIQUE NOT NULL,"
        "  call_uuid VARCHAR(64),"
        "  origin_ani VARCHAR(64),"
        "  origin_dnis VARCHAR(64),"
        "  assigned_did VARCHAR(64),"
        "  current_state INTEGER,"
        "  validation_status VARCHAR(32),"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
        "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS validation_checkpoints ("
        "  id SERIAL PRIMARY KEY,"
        "  checkpoint_name VARCHAR(128),"
        "  route_id INTEGER,"
        "  call_id VARCHAR(256),"
        "  passed BOOLEAN,"
        "  failure_reason VARCHAR(256),"
        "  checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS security_events ("
        "  id SERIAL PRIMARY KEY,"
        "  event_type VARCHAR(64),"
        "  severity VARCHAR(32),"
        "  call_id VARCHAR(256),"
        "  source_ip VARCHAR(64),"
        "  details TEXT,"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS call_validation_rules ("
        "  id SERIAL PRIMARY KEY,"
        "  rule_name VARCHAR(128),"
        "  rule_type VARCHAR(64),"
        "  rule_condition TEXT,"
        "  action VARCHAR(64),"
        "  priority INTEGER DEFAULT 100,"
        "  enabled BOOLEAN DEFAULT true,"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");";
    
    db_query(db, create_tables);
    
    // Insert default validation rules
    const char *default_rules = 
        "INSERT INTO call_validation_rules (rule_name, rule_type, rule_condition, action, priority) "
        "VALUES "
        "('Check Origin Server', 'origin_validation', 'source_ip IN (SELECT host FROM providers WHERE role = ''origin'')', 'allow', 100),"
        "('Verify DID Ownership', 'did_validation', 'did IN (SELECT did FROM dids WHERE active = true)', 'allow', 90),"
        "('Rate Limit Check', 'rate_limit', 'calls_per_minute < 100', 'allow', 80),"
        "('Concurrent Call Limit', 'concurrent_limit', 'concurrent_calls < 500', 'allow', 70),"
        "('Blocked Number Check', 'blacklist', 'ani NOT IN (SELECT number FROM blocked_numbers)', 'allow', 60)"
        "ON CONFLICT DO NOTHING;";
    
    db_query(db, default_rules);
    
    LOG_INFO("Call validator created with interval=%dms, timeout=%dms",
            validator->validation_interval_ms, validator->validation_timeout_ms);
    
    return validator;
}

void call_validator_destroy(call_validator_t *validator) {
    if (!validator) return;
    
    call_validator_stop(validator);
    
    // Clean up active validations
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t *record = validator->active_validations;
    while (record) {
        call_validation_record_t *next = record->next;
        free(record);
        record = next;
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    pthread_mutex_destroy(&validator->validation_mutex);
    
    free(validator);
}

int call_validator_start(call_validator_t *validator) {
    if (!validator || validator->running) return -1;
    
    validator->running = true;
    
    if (pthread_create(&validator->validation_thread, NULL, 
                      validation_thread_func, validator) != 0) {
        LOG_ERROR("Failed to create validation thread");
        validator->running = false;
        return -1;
    }
    
    LOG_INFO("Call validator started");
    return 0;
}

void call_validator_stop(call_validator_t *validator) {
    if (!validator || !validator->running) return;
    
    validator->running = false;
    pthread_join(validator->validation_thread, NULL);
    
    LOG_INFO("Call validator stopped");
}

// Validate call initiation
validation_result_t validate_call_initiation(call_validator_t *validator,
                                            const char *call_id,
                                            const char *ani,
                                            const char *dnis,
                                            const char *source_ip) {
    if (!validator || !call_id || !ani || !dnis || !source_ip) {
        return VALIDATION_FAILED;
    }
    
    LOG_INFO("Validating call initiation: ID=%s, ANI=%s, DNIS=%s, Source=%s",
            call_id, ani, dnis, source_ip);
    
    // Check if source IP is authorized
    if (!verify_server_authorization(validator, source_ip, call_id)) {
        LOG_ERROR("Call %s: Unauthorized source IP %s", call_id, source_ip);
        log_security_event(validator, "UNAUTHORIZED_SOURCE", "CRITICAL",
                         call_id, "Unauthorized source IP attempted call");
        return VALIDATION_UNAUTHORIZED;
    }
    
    // Create validation record
    call_validation_record_t *record = create_validation_record(call_id, ani, dnis);
    if (!record) {
        LOG_ERROR("Failed to create validation record for call %s", call_id);
        return VALIDATION_FAILED;
    }
    
    strncpy(record->origin_server_ip, source_ip, sizeof(record->origin_server_ip) - 1);
    record->origin_validated = true;
    
    // Add to active validations
    pthread_mutex_lock(&validator->validation_mutex);
    record->next = validator->active_validations;
    validator->active_validations = record;
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Record in database
    char query[1024];
    snprintf(query, sizeof(query),
            "INSERT INTO call_validations (call_id, call_uuid, origin_ani, origin_dnis, "
            "current_state, validation_status) "
            "VALUES ('%s', '%s', '%s', '%s', %d, 'active')",
            call_id, record->call_uuid, ani, dnis, CALL_STATE_ORIGINATED);
    
    db_query(validator->db, query);
    
    // Record checkpoint
    record_validation_checkpoint(validator, "call_initiated", 0, call_id, true, NULL);
    
    validator->stats.total_validations++;
    
    return VALIDATION_SUCCESS;
}

// Validate call progress
validation_result_t validate_call_progress(call_validator_t *validator,
                                          const char *call_id,
                                          call_state_t new_state,
                                          const char *server_ip) {
    if (!validator || !call_id || !server_ip) {
        return VALIDATION_FAILED;
    }
    
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (!record) {
        LOG_ERROR("Call %s: No validation record found", call_id);
        return VALIDATION_FAILED;
    }
    
    // Verify state progression is valid
    bool valid_transition = false;
    
    switch (record->current_state) {
        case CALL_STATE_ORIGINATED:
            valid_transition = (new_state == CALL_STATE_RINGING);
            break;
        case CALL_STATE_RINGING:
            valid_transition = (new_state == CALL_STATE_ANSWERED || 
                              new_state == CALL_STATE_HUNG_UP);
            break;
        case CALL_STATE_ANSWERED:
            valid_transition = (new_state == CALL_STATE_HUNG_UP);
            break;
        default:
            valid_transition = false;
    }
    
    if (!valid_transition) {
        LOG_ERROR("Call %s: Invalid state transition from %d to %d",
                 call_id, record->current_state, new_state);
        
        log_security_event(validator, "INVALID_STATE_TRANSITION", "HIGH",
                         call_id, "Invalid call state progression detected");
        
        record_validation_checkpoint(validator, "state_transition", 0, call_id, 
                                   false, "Invalid state transition");
        
        return VALIDATION_MISMATCH;
    }
    
    // Update state
    pthread_mutex_lock(&validator->validation_mutex);
    record->current_state = new_state;
    record->state_timestamp = time(NULL);
    
    if (new_state == CALL_STATE_ANSWERED) {
        record->answered_at = record->state_timestamp;
    } else if (new_state == CALL_STATE_HUNG_UP) {
        record->ended_at = record->state_timestamp;
        if (record->answered_at > 0) {
            record->duration_ms = (record->ended_at - record->answered_at) * 1000;
        }
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Update database
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_validations SET current_state = %d, updated_at = CURRENT_TIMESTAMP "
            "WHERE call_id = '%s'",
            new_state, call_id);
    
    db_query(validator->db, query);
    
    // Record checkpoint
    char checkpoint_name[128];
    snprintf(checkpoint_name, sizeof(checkpoint_name), "state_%d", new_state);
    record_validation_checkpoint(validator, checkpoint_name, 0, call_id, true, NULL);
    
    LOG_INFO("Call %s: State updated to %d", call_id, new_state);
    
    return VALIDATION_SUCCESS;
}

// Validate call routing
validation_result_t validate_call_routing(call_validator_t *validator,
                                         const char *call_id,
                                         const char *expected_destination,
                                         const char *actual_destination) {
    if (!validator || !call_id || !expected_destination || !actual_destination) {
        return VALIDATION_FAILED;
    }
    
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (!record) {
        LOG_ERROR("Call %s: No validation record found", call_id);
        return VALIDATION_FAILED;
    }
    
    // Check if actual destination matches expected
    if (strcmp(expected_destination, actual_destination) != 0) {
        LOG_ERROR("Call %s: Route mismatch - Expected: %s, Actual: %s",
                 call_id, expected_destination, actual_destination);
        
        log_security_event(validator, "ROUTE_DIVERSION", "CRITICAL",
                         call_id, "Call diverted to unexpected destination");
        
        record_validation_checkpoint(validator, "route_validation", 0, call_id,
                                   false, "Destination mismatch");
        
        // Mark as diverted and force hangup
        pthread_mutex_lock(&validator->validation_mutex);
        record->current_state = CALL_STATE_DIVERTED;
        pthread_mutex_unlock(&validator->validation_mutex);
        
        force_hangup_invalid_call(validator, call_id);
        
        validator->stats.diverted_calls++;
        
        return VALIDATION_DIVERTED;
    }
    
    // Update validation record
    pthread_mutex_lock(&validator->validation_mutex);
    strncpy(record->destination_server_ip, actual_destination, 
           sizeof(record->destination_server_ip) - 1);
    record->route_validated = true;
    pthread_mutex_unlock(&validator->validation_mutex);
    
    record_validation_checkpoint(validator, "route_validation", 0, call_id,
                               true, NULL);
    
    LOG_INFO("Call %s: Route validated to %s", call_id, actual_destination);
    
    return VALIDATION_SUCCESS;
}

// Validate DID assignment
validation_result_t validate_did_assignment(call_validator_t *validator,
                                           const char *call_id,
                                           const char *did,
                                           const char *server_ip) {
    if (!validator || !call_id || !did || !server_ip) {
        return VALIDATION_FAILED;
    }
    
    // Check DID ownership and availability
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id, in_use, call_id FROM dids WHERE did = '%s' AND active = true",
            did);
    
    db_result_t *result = db_query(validator->db, query);
    if (!result || result->num_rows == 0) {
        LOG_ERROR("Call %s: DID %s not found or inactive", call_id, did);
        
        log_security_event(validator, "INVALID_DID", "HIGH",
                         call_id, "Attempted to use invalid or inactive DID");
        
        db_free_result(result);
        return VALIDATION_FAILED;
    }
    
    // Check if DID is already in use
    int in_use = atoi(db_get_value(result, 0, 1));
    const char *existing_call_id = db_get_value(result, 0, 2);
    
    if (in_use && existing_call_id && strcmp(existing_call_id, call_id) != 0) {
        LOG_ERROR("Call %s: DID %s already in use by call %s",
                 call_id, did, existing_call_id);
        
        log_security_event(validator, "DID_COLLISION", "HIGH",
                         call_id, "DID already assigned to another call");
        
        db_free_result(result);
        return VALIDATION_FAILED;
    }
    
    db_free_result(result);
    
    // Update validation record
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record) {
        pthread_mutex_lock(&validator->validation_mutex);
        strncpy(record->assigned_did, did, sizeof(record->assigned_did) - 1);
        record->did_ownership_verified = true;
        pthread_mutex_unlock(&validator->validation_mutex);
    }
    
    record_validation_checkpoint(validator, "did_assignment", 0, call_id,
                               true, NULL);
    
    LOG_INFO("Call %s: DID %s assignment validated", call_id, did);
    
    return VALIDATION_SUCCESS;
}

// Update call state
int update_call_state(call_validator_t *validator,
                     const char *call_id,
                     call_state_t new_state) {
    return validate_call_progress(validator, call_id, new_state, "127.0.0.1");
}

// Get call state
call_state_t get_call_state(call_validator_t *validator,
                           const char *call_id) {
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record) {
        return record->current_state;
    }
    return CALL_STATE_HUNG_UP;
}

// Verify server authorization
bool verify_server_authorization(call_validator_t *validator,
                                const char *server_ip,
                                const char *call_id) {
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id FROM providers WHERE host = '%s' AND active = true",
            server_ip);
    
    db_result_t *result = db_query(validator->db, query);
    bool authorized = (result && result->num_rows > 0);
    
    if (!authorized) {
        LOG_WARN("Server %s not authorized for call %s", server_ip, call_id);
    }
    
    if (result) db_free_result(result);
    return authorized;
}

// Verify route integrity
bool verify_route_integrity(call_validator_t *validator,
                           const char *call_id,
                           int origin_id,
                           int intermediate_id,
                           int final_id) {
    // Verify that the route exists and is active
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id FROM routes WHERE "
            "origin_provider_id = %d AND "
            "intermediate_provider_id = %d AND "
            "final_provider_id = %d AND "
            "active = true",
            origin_id, intermediate_id, final_id);
    
    db_result_t *result = db_query(validator->db, query);
    bool valid = (result && result->num_rows > 0);
    
    if (!valid) {
        LOG_ERROR("Call %s: Route integrity check failed for %d->%d->%d",
                 call_id, origin_id, intermediate_id, final_id);
    }
    
    if (result) db_free_result(result);
    return valid;
}

// Log security event
void log_security_event(call_validator_t *validator,
                       const char *event_type,
                       const char *severity,
                       const char *call_id,
                       const char *details) {
    char query[1024];
    char escaped_details[1024];
    
    // Escape single quotes in details
    const char *src = details;
    char *dst = escaped_details;
    while (*src && (dst - escaped_details) < 1022) {
        if (*src == '\'') {
            *dst++ = '\'';
            *dst++ = '\'';
        } else {
            *dst++ = *src;
        }
        src++;
    }
    *dst = '\0';
    
    snprintf(query, sizeof(query),
            "INSERT INTO security_events (event_type, severity, call_id, details) "
            "VALUES ('%s', '%s', '%s', '%s')",
            event_type, severity, call_id, escaped_details);
    
    db_query(validator->db, query);
    
    validator->stats.security_events++;
    
    LOG_WARN("SECURITY EVENT: Type=%s, Severity=%s, Call=%s, Details=%s",
            event_type, severity, call_id, details);
}

// Record validation checkpoint
void record_validation_checkpoint(call_validator_t *validator,
                                 const char *checkpoint_name,
                                 int route_id,
                                 const char *call_id,
                                 bool passed,
                                 const char *failure_reason) {
    char query[1024];
    
    if (failure_reason) {
        char escaped_reason[512];
        const char *src = failure_reason;
        char *dst = escaped_reason;
        while (*src && (dst - escaped_reason) < 510) {
            if (*src == '\'') {
                *dst++ = '\'';
                *dst++ = '\'';
            } else {
                *dst++ = *src;
            }
            src++;
        }
        *dst = '\0';
        
        snprintf(query, sizeof(query),
                "INSERT INTO validation_checkpoints "
                "(checkpoint_name, route_id, call_id, passed, failure_reason) "
                "VALUES ('%s', %d, '%s', %s, '%s')",
                checkpoint_name, route_id, call_id, 
                passed ? "true" : "false", escaped_reason);
    } else {
        snprintf(query, sizeof(query),
                "INSERT INTO validation_checkpoints "
                "(checkpoint_name, route_id, call_id, passed) "
                "VALUES ('%s', %d, '%s', %s)",
                checkpoint_name, route_id, call_id, 
                passed ? "true" : "false");
    }
    
    db_query(validator->db, query);
    
    LOG_DEBUG("Checkpoint %s for call %s: %s",
             checkpoint_name, call_id, passed ? "PASSED" : "FAILED");
}

// Get validation statistics
void get_validation_stats(call_validator_t *validator,
                         uint64_t *total,
                         uint64_t *successful,
                         uint64_t *failed,
                         uint64_t *diverted) {
    if (total) *total = validator->stats.total_validations;
    if (successful) *successful = validator->stats.successful_validations;
    if (failed) *failed = validator->stats.failed_validations;
    if (diverted) *diverted = validator->stats.diverted_calls;
}

// Clean up expired validations
void cleanup_expired_validations(call_validator_t *validator) {
    time_t now = time(NULL);
    time_t expiry_time = now - 3600; // 1 hour expiry
    
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t **pp = &validator->active_validations;
    while (*pp) {
        call_validation_record_t *record = *pp;
        
        if (record->ended_at > 0 && record->ended_at < expiry_time) {
            *pp = record->next;
            
            // Update database
            char query[512];
            snprintf(query, sizeof(query),
                    "UPDATE call_validations SET validation_status = 'expired' "
                    "WHERE call_id = '%s'",
                    record->call_id);
            db_query(validator->db, query);
            
            free(record);
        } else {
            pp = &record->next;
        }
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Clean up old database records
    char query[256];
    snprintf(query, sizeof(query),
            "DELETE FROM call_validations WHERE created_at < NOW() - INTERVAL '24 hours'");
    db_query(validator->db, query);
    
    snprintf(query, sizeof(query),
            "DELETE FROM validation_checkpoints WHERE checked_at < NOW() - INTERVAL '7 days'");
    db_query(validator->db, query);
    
    snprintf(query, sizeof(query),
            "DELETE FROM security_events WHERE created_at < NOW() - INTERVAL '30 days'");
    db_query(validator->db, query);
}

// Force hangup of invalid call
void force_hangup_invalid_call(call_validator_t *validator, const char *call_id) {
    LOG_WARN("Forcing hangup of invalid call: %s", call_id);
    
    // Send hangup command to FreeSWITCH
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'uuid_kill %s VALIDATION_FAILED'", call_id);
    system(cmd);
    
    // Update call record
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_records SET status = 'failed', ended_at = CURRENT_TIMESTAMP, "
            "failure_reason = 'Validation failed' WHERE call_id = '%s'",
            call_id);
    db_query(validator->db, query);
    
    // Update validation record
    snprintf(query, sizeof(query),
            "UPDATE call_validations SET validation_status = 'failed', "
            "current_state = %d WHERE call_id = '%s'",
            CALL_STATE_FAILED, call_id);
    db_query(validator->db, query);
    
    // Release any assigned DID
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record && strlen(record->assigned_did) > 0) {
        snprintf(query, sizeof(query),
                "UPDATE dids SET in_use = false, call_id = NULL, "
                "destination = NULL WHERE did = '%s'",
                record->assigned_did);
        db_query(validator->db, query);
    }
}
