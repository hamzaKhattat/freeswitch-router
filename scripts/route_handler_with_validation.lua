-- route_handler_with_validation.lua
-- Dynamic Route Handler with Call Validation for S1->S2->S3->S2->S4 flow
-- This script integrates with the C validation system

-- Database connection settings
local db_host = "localhost"
local db_name = "router_db"
local db_user = "router"
local db_pass = "router123"

-- Load required modules
require "luasql.postgres"

-- Create database environment
local env = luasql.postgres()
local conn = env:connect(db_name, db_user, db_pass, db_host)

-- Helper function to log messages
function log_message(level, message)
    freeswitch.consoleLog(level, "[VALIDATION] " .. message .. "\n")
end

-- Helper function to execute database queries
function db_query(sql)
    local cursor, error_msg = conn:execute(sql)
    if not cursor then
        log_message("ERROR", "Database query failed: " .. (error_msg or "unknown error"))
        return nil
    end
    return cursor
end

-- Function to validate call initiation
function validate_call_initiation(call_id, ani, dnis, source_ip)
    log_message("INFO", string.format("Validating call initiation: %s, ANI=%s, DNIS=%s, Source=%s",
                                      call_id, ani, dnis, source_ip))
    
    -- Check if source IP is authorized
    local sql = string.format("SELECT id FROM providers WHERE host = '%s' AND active = true", source_ip)
    local cursor = db_query(sql)
    
    if not cursor then
        return false, "Database error"
    end
    
    local row = cursor:fetch({}, "a")
    cursor:close()
    
    if not row then
        log_message("ERROR", "Unauthorized source IP: " .. source_ip)
        
        -- Log security event
        sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, source_ip, details) " ..
            "VALUES ('UNAUTHORIZED_SOURCE', 'CRITICAL', '%s', '%s', 'Unauthorized source IP attempted call')",
            call_id, source_ip
        )
        db_query(sql)
    
    session:hangup("UNSPECIFIED")
end

-- Cleanup database connection
if conn then
    conn:close()
end

if env then
    env:close()
end

log_message("INFO", "Route handler with validation completed"))
        
        return false, "Unauthorized source"
    end
    
    -- Create validation record
    sql = string.format(
        "INSERT INTO call_validations (call_id, origin_ani, origin_dnis, current_state, validation_status) " ..
        "VALUES ('%s', '%s', '%s', 1, 'active')",
        call_id, ani, dnis
    )
    
    if not db_query(sql) then
        return false, "Failed to create validation record"
    end
    
    -- Record checkpoint
    sql = string.format(
        "INSERT INTO validation_checkpoints (checkpoint_name, call_id, passed) " ..
        "VALUES ('call_initiated', '%s', true)",
        call_id
    )
    db_query(sql)
    
    return true, "Validation successful"
end

-- Function to update call state
function update_call_state(call_id, new_state, checkpoint_name)
    local state_names = {
        [1] = "ORIGINATED",
        [2] = "RINGING",
        [3] = "ANSWERED",
        [4] = "HUNG_UP",
        [5] = "FAILED",
        [6] = "DIVERTED"
    }
    
    log_message("INFO", string.format("Updating call %s to state %s", 
                                      call_id, state_names[new_state] or "UNKNOWN"))
    
    -- Update validation record
    local sql = string.format(
        "UPDATE call_validations SET current_state = %d, updated_at = CURRENT_TIMESTAMP " ..
        "WHERE call_id = '%s'",
        new_state, call_id
    )
    
    if not db_query(sql) then
        return false
    end
    
    -- Record checkpoint
    sql = string.format(
        "INSERT INTO validation_checkpoints (checkpoint_name, call_id, passed) " ..
        "VALUES ('%s', '%s', true)",
        checkpoint_name, call_id
    )
    db_query(sql)
    
    return true
end

-- Function to validate routing
function validate_routing(call_id, expected_dest, actual_dest)
    if expected_dest ~= actual_dest then
        log_message("ERROR", string.format("Route mismatch for %s: Expected %s, Got %s",
                                          call_id, expected_dest, actual_dest))
        
        -- Log security event
        local sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, details) " ..
            "VALUES ('ROUTE_DIVERSION', 'CRITICAL', '%s', 'Call diverted to unexpected destination')",
            call_id
        )
        db_query(sql)
        
        -- Record failed checkpoint
        sql = string.format(
            "INSERT INTO validation_checkpoints (checkpoint_name, call_id, passed, failure_reason) " ..
            "VALUES ('route_validation', '%s', false, 'Destination mismatch')",
            call_id
        )
        db_query(sql)
        
        return false
    end
    
    -- Record successful checkpoint
    local sql = string.format(
        "INSERT INTO validation_checkpoints (checkpoint_name, call_id, passed) " ..
        "VALUES ('route_validation', '%s', true)",
        call_id
    )
    db_query(sql)
    
    return true
end

-- Function to validate DID assignment
function validate_did_assignment(call_id, did)
    -- Check if DID is valid and available
    local sql = string.format(
        "SELECT id, in_use, call_id FROM dids WHERE did = '%s' AND active = true",
        did
    )
    local cursor = db_query(sql)
    
    if not cursor then
        return false, "Database error"
    end
    
    local row = cursor:fetch({}, "a")
    cursor:close()
    
    if not row then
        log_message("ERROR", "DID not found or inactive: " .. did)
        
        -- Log security event
        sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, details) " ..
            "VALUES ('INVALID_DID', 'HIGH', '%s', 'Attempted to use invalid or inactive DID')",
            call_id
        )
        db_query(sql)
        
        return false, "Invalid DID"
    end
    
    -- Check if DID is already in use by another call
    if row.in_use == "t" and row.call_id ~= call_id then
        log_message("ERROR", string.format("DID %s already in use by call %s", did, row.call_id))
        
        -- Log security event
        sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, details) " ..
            "VALUES ('DID_COLLISION', 'HIGH', '%s', 'DID already assigned to another call')",
            call_id
        )
        db_query(sql)
        
        return false, "DID already in use"
    end
    
    -- Record checkpoint
    sql = string.format(
        "INSERT INTO validation_checkpoints (checkpoint_name, call_id, passed) " ..
        "VALUES ('did_assignment', '%s', true)",
        call_id
    )
    db_query(sql)
    
    return true, "DID assignment valid"
end

-- Main script execution
local stage = argv[1] or "unknown"
local route_id = argv[2] or "0"
local next_provider = argv[3] or ""
local final_provider = argv[4] or ""

-- Get call variables
local call_uuid = session:getVariable("uuid")
local call_id = session:getVariable("sip_call_id") or call_uuid
local ani = session:getVariable("caller_id_number")
local dnis = session:getVariable("destination_number")
local source_ip = session:getVariable("network_addr")

log_message("INFO", string.format("Route Handler: Stage=%s, Call=%s, ANI=%s, DNIS=%s",
                                  stage, call_id, ani or "nil", dnis or "nil"))

-- Perform validation based on stage
if stage == "origin" then
    -- S1->S2: Validate and route to intermediate
    
    -- Validate call initiation
    local valid, reason = validate_call_initiation(call_id, ani, dnis, source_ip)
    if not valid then
        log_message("ERROR", "Call validation failed: " .. reason)
        session:execute("respond", "403 Forbidden")
        session:hangup("CALL_REJECTED")
        return
    end
    
    -- Update state to ORIGINATED
    update_call_state(call_id, 1, "stage_origin")
    
    -- Store original values
    session:setVariable("original_ani", ani)
    session:setVariable("original_dnis", dnis)
    session:setVariable("sip_h_X-Original-ANI", ani)
    session:setVariable("sip_h_X-Original-DNIS", dnis)
    session:setVariable("sip_h_X-Validation-ID", call_id)
    
    -- Allocate DID
    local sql = string.format(
        "SELECT did FROM dids WHERE in_use = false AND active = true LIMIT 1"
    )
    local cursor = db_query(sql)
    
    if not cursor then
        log_message("ERROR", "Failed to allocate DID")
        session:hangup("TEMPORARILY_UNAVAILABLE")
        return
    end
    
    local row = cursor:fetch({}, "a")
    cursor:close()
    
    if not row then
        log_message("ERROR", "No available DIDs")
        
        -- Log security event
        sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, details) " ..
            "VALUES ('DID_EXHAUSTION', 'HIGH', '%s', 'No DIDs available for allocation')",
            call_id
        )
        db_query(sql)
        
        session:hangup("TEMPORARILY_UNAVAILABLE")
        return
    end
    
    local did = row.did
    
    -- Validate DID assignment
    valid, reason = validate_did_assignment(call_id, did)
    if not valid then
        log_message("ERROR", "DID assignment validation failed: " .. reason)
        session:hangup("TEMPORARILY_UNAVAILABLE")
        return
    end
    
    -- Mark DID as in use
    sql = string.format(
        "UPDATE dids SET in_use = true, call_id = '%s', destination = '%s', " ..
        "original_ani = '%s', allocated_at = CURRENT_TIMESTAMP " ..
        "WHERE did = '%s'",
        call_id, dnis, ani, did
    )
    db_query(sql)
    
    -- Update state to RINGING
    update_call_state(call_id, 2, "stage_ringing")
    
    -- Validate routing before bridging
    if not validate_routing(call_id, next_provider, next_provider) then
        log_message("ERROR", "Route validation failed")
        
        -- Release DID
        sql = string.format(
            "UPDATE dids SET in_use = false, call_id = NULL WHERE did = '%s'",
            did
        )
        db_query(sql)
        
        session:hangup("CALL_REJECTED")
        return
    end
    
    -- Bridge to intermediate provider
    local bridge_str = "sofia/gateway/" .. next_provider .. "/" .. did
    log_message("INFO", "Bridging to intermediate: " .. bridge_str)
    
    session:execute("bridge", bridge_str)
    
    -- Update state after bridge
    local hangup_cause = session:getVariable("last_bridge_hangup_cause")
    if hangup_cause == "SUCCESS" or hangup_cause == "NORMAL_CLEARING" then
        update_call_state(call_id, 3, "stage_answered")
    else
        update_call_state(call_id, 5, "stage_failed")
        
        -- Release DID on failure
        sql = string.format(
            "UPDATE dids SET in_use = false, call_id = NULL WHERE did = '%s'",
            did
        )
        db_query(sql)
    end
    
elseif stage == "intermediate" then
    -- S3->S2: Validate and route to final destination
    
    local validation_id = session:getVariable("sip_h_X-Validation-ID") or call_id
    
    -- Verify this is a valid return call
    local sql = string.format(
        "SELECT current_state FROM call_validations WHERE call_id = '%s'",
        validation_id
    )
    local cursor = db_query(sql)
    
    if not cursor then
        log_message("ERROR", "Cannot verify call validation")
        session:respond("503 Service Unavailable")
        session:hangup("CALL_REJECTED")
        return
    end
    
    local row = cursor:fetch({}, "a")
    cursor:close()
    
    if not row then
        log_message("ERROR", "No validation record found for call")
        
        -- Log security event
        sql = string.format(
            "INSERT INTO security_events (event_type, severity, call_id, source_ip, details) " ..
            "VALUES ('UNVALIDATED_RETURN', 'CRITICAL', '%s', '%s', 'Return call without validation record')",
            call_id, source_ip
        )
        db_query(sql)
        
        session:respond("403 Forbidden")
        session:hangup("CALL_REJECTED")
        return
    end
    
    -- Get original call details
    local orig_ani = session:getVariable("sip_h_X-Original-ANI") or ani
    local orig_dnis = session:getVariable("sip_h_X-Original-DNIS") or dnis
    
    -- Restore original caller ID
    session:setVariable("effective_caller_id_number", orig_ani)
    
    -- Find and release the DID
    sql = string.format(
        "SELECT did FROM dids WHERE call_id = '%s'",
        validation_id
    )
    cursor = db_query(sql)
    
    if cursor then
        row = cursor:fetch({}, "a")
        cursor:close()
        
        if row then
            -- Release DID
            sql = string.format(
                "UPDATE dids SET in_use = false, call_id = NULL, " ..
                "destination = NULL, original_ani = NULL WHERE did = '%s'",
                row.did
            )
            db_query(sql)
            
            log_message("INFO", "Released DID: " .. row.did)
        end
    end
    
    -- Update state
    update_call_state(validation_id, 3, "stage_return")
    
    -- Bridge to final provider
    local bridge_str = "sofia/gateway/" .. final_provider .. "/" .. orig_dnis
    log_message("INFO", "Bridging to final: " .. bridge_str)
    
    session:execute("bridge", bridge_str)
    
    -- Final state update
    update_call_state(validation_id, 4, "stage_completed")
    
else
    log_message("ERROR", "Unknown stage: " .. stage)
    
    -- Log security event
    local sql = string.format(
        "INSERT INTO security_events (event_type, severity, call_id, details) " ..
        "VALUES ('INVALID_STAGE', 'HIGH', '%s', 'Unknown routing stage')",
        call_id
    )
    db_query(sql
