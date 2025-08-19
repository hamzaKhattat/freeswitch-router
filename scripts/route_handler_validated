-- route_handler_validated.lua - Complete Module 2 Validation Implementation
-- Dynamic Route Handler with Call State Validation for S1->S2->S3->S2->S4 flow

-- Get command line arguments
local stage = argv[1] or "unknown"
local route_id = argv[2] or "0"
local next_provider = argv[3] or ""
local final_provider = argv[4] or ""

-- Database connection
local dbh = freeswitch.Dbh("pgsql://router:router123@localhost/router_db")
if not dbh:connected() then
    freeswitch.consoleLog("ERROR", "Database connection failed\n")
    session:hangup("TEMPORARY_FAILURE")
    return
end

-- Get call variables
local call_uuid = session:getVariable("uuid")
local ani = session:getVariable("caller_id_number")
local dnis = session:getVariable("destination_number")
local network_addr = session:getVariable("network_addr")

freeswitch.consoleLog("INFO", string.format(
    "Route Handler: Stage=%s, Route=%s, ANI=%s, DNIS=%s, From=%s\n",
    stage, route_id, ani or "nil", dnis or "nil", network_addr or "nil"))

-- ============================================================================
-- VALIDATION FUNCTIONS (Module 2 Compliance)
-- ============================================================================

-- Function to create validation checkpoint
function create_checkpoint(checkpoint_name, expected, actual, passed, reason)
    local sql = string.format(
        "INSERT INTO validation_checkpoints (call_uuid, route_id, checkpoint_name, " ..
        "checkpoint_stage, expected_value, actual_value, passed, failure_reason) " ..
        "VALUES ('%s', %s, '%s', '%s', '%s', '%s', %s, %s)",
        call_uuid, route_id, checkpoint_name, stage,
        expected or "NULL", actual or "NULL",
        passed and "true" or "false",
        reason and string.format("'%s'", reason) or "NULL")
    
    dbh:query(sql)
end

-- Function to log security event
function log_security_event(event_type, severity, details)
    local sql = string.format(
        "INSERT INTO security_events (call_uuid, event_type, severity, details, " ..
        "source_ip, action_taken) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')",
        call_uuid, event_type, severity, details, network_addr, "CALL_REJECTED")
    
    dbh:query(sql)
end

-- Function to update call state
function update_call_state(state, validation_status)
    local sql = string.format(
        "INSERT INTO call_states (call_uuid, route_id, current_state, " ..
        "origin_server, ani, dnis, validation_status) " ..
        "VALUES ('%s', %s, '%s', '%s', '%s', '%s', '%s') " ..
        "ON CONFLICT (call_uuid) DO UPDATE SET " ..
        "current_state = EXCLUDED.current_state, " ..
        "validation_status = EXCLUDED.validation_status, " ..
        "updated_at = CURRENT_TIMESTAMP",
        call_uuid, route_id, state, network_addr, ani, dnis, validation_status)
    
    dbh:query(sql)
end

-- Function to validate call state at destination
function validate_destination_state(gateway_uuid, expected_state, timeout_ms)
    local api = freeswitch.API()
    local start_time = os.clock()
    local timeout = (timeout_ms or 5000) / 1000  -- Convert to seconds
    local validated = false
    local retry_count = 0
    local max_retries = 3
    
    while (os.clock() - start_time) < timeout and retry_count < max_retries do
        -- Check gateway status
        local cmd = string.format("sofia status gateway %s", gateway_uuid)
        local status = api:executeString(cmd)
        
        -- Check for call presence
        local channel_cmd = string.format("show channels like %s", dnis)
        local channels = api:executeString(channel_cmd)
        
        if string.find(channels, expected_state) then
            validated = true
            create_checkpoint("destination_state", expected_state, "FOUND", true, nil)
            break
        end
        
        retry_count = retry_count + 1
        session:sleep(500)  -- Wait 500ms before retry
    end
    
    if not validated then
        create_checkpoint("destination_state", expected_state, "NOT_FOUND", false, 
                         "State validation failed after " .. retry_count .. " retries")
        log_security_event("VALIDATION_FAILED", "HIGH", 
                          "Call did not reach expected state: " .. expected_state)
    end
    
    return validated
end

-- Function to validate origin server
function validate_origin_server(expected_origin_ip)
    local sql = string.format(
        "SELECT COUNT(*) as count FROM call_states " ..
        "WHERE call_uuid = '%s' AND origin_server = '%s'",
        call_uuid, expected_origin_ip)
    
    local is_valid = false
    dbh:query(sql, function(row)
        if tonumber(row.count) > 0 then
            is_valid = true
        end
    end)
    
    create_checkpoint("origin_verification", expected_origin_ip, network_addr, 
                     is_valid, is_valid and nil or "Origin mismatch")
    
    return is_valid
end

-- Function to check rate limiting
function check_rate_limit(provider_id, max_calls_per_minute)
    local sql = string.format(
        "SELECT COUNT(*) as call_count FROM calls " ..
        "WHERE created_at > NOW() - INTERVAL '1 minute' " ..
        "AND route_id = %s", route_id)
    
    local current_rate = 0
    dbh:query(sql, function(row)
        current_rate = tonumber(row.call_count)
    end)
    
    local passed = current_rate < max_calls_per_minute
    create_checkpoint("rate_limit", tostring(max_calls_per_minute), 
                     tostring(current_rate), passed,
                     passed and nil or "Rate limit exceeded")
    
    return passed
end

-- ============================================================================
-- MAIN ROUTING LOGIC WITH VALIDATION
-- ============================================================================

-- Validate inputs
if not ani or not dnis then
    freeswitch.consoleLog("ERROR", "Missing ANI or DNIS\n")
    log_security_event("INVALID_CALL", "MEDIUM", "Missing required parameters")
    session:hangup("PROTOCOL_ERROR")
    dbh:release()
    return
end

-- Check rate limiting (Module 2 requirement)
if not check_rate_limit(route_id, 100) then
    freeswitch.consoleLog("ERROR", "Rate limit exceeded\n")
    session:hangup("CALL_REJECTED")
    dbh:release()
    return
end

if stage == "origin" then
    -- ========================================================================
    -- S1->S2: Received from origin, route to intermediate
    -- ========================================================================
    
    freeswitch.consoleLog("INFO", "Processing origin call (S1->S2->S3)\n")
    
    -- Update call state
    update_call_state("ORIGINATED", "validating")
    
    -- Store original call information
    session:setVariable("original_ani", ani)
    session:setVariable("original_dnis", dnis)
    session:setVariable("route_id", route_id)
    session:setVariable("call_stage", "1")
    session:setVariable("origin_network_addr", network_addr)
    
    -- Try to allocate a DID from the pool
    local sql = "SELECT did FROM dids WHERE in_use = false AND active = true " ..
                "AND (locked_until IS NULL OR locked_until < NOW()) " ..
                "ORDER BY RANDOM() LIMIT 1"
    local did = nil
    
    dbh:query(sql, function(row)
        did = row.did
    end)
    
    if not did then
        freeswitch.consoleLog("ERROR", "No available DID for call routing\n")
        log_security_event("DID_EXHAUSTED", "HIGH", "No DIDs available in pool")
        session:hangup("NORMAL_CIRCUIT_CONGESTION")
        dbh:release()
        return
    end
    
    -- Mark DID as in use and store call information
    local update_sql = string.format(
        "UPDATE dids SET in_use = true, destination = '%s', original_ani = '%s', " ..
        "call_id = '%s', allocated_at = CURRENT_TIMESTAMP, " ..
        "last_validation_check = CURRENT_TIMESTAMP " ..
        "WHERE did = '%s'",
        dnis, ani, call_uuid, did)
    
    local update_result = dbh:query(update_sql)
    if not update_result then
        freeswitch.consoleLog("ERROR", "Failed to allocate DID: " .. did .. "\n")
        create_checkpoint("did_allocation", "SUCCESS", "FAILED", false, "Database update failed")
        session:hangup("TEMPORARY_FAILURE")
        dbh:release()
        return
    end
    
    create_checkpoint("did_allocation", did, did, true, nil)
    freeswitch.consoleLog("INFO", "Allocated DID: " .. did .. " for call " .. call_uuid .. "\n")
    
    -- Record call in database with validation tracking
    local call_sql = string.format(
        "INSERT INTO calls (uuid, ani, dnis, provider, route_id, status, created_at) " ..
        "VALUES ('%s', '%s', '%s', 's2-router', %s, 'routing', CURRENT_TIMESTAMP)",
        call_uuid, ani, dnis, route_id)
    
    dbh:query(call_sql)
    
    -- Set SIP headers for intermediate provider
    session:setVariable("sip_h_X-Original-ANI", ani)
    session:setVariable("sip_h_X-Original-DNIS", dnis)
    session:setVariable("sip_h_X-Route-ID", route_id)
    session:setVariable("sip_h_X-DID", did)
    session:setVariable("sip_h_X-Call-Stage", "1")
    session:setVariable("sip_h_X-Validation-Required", "true")
    
    -- Modify caller ID for intermediate: ANI becomes DNIS, DID becomes destination
    session:setVariable("effective_caller_id_number", dnis)
    session:setVariable("effective_caller_id_name", "S2-Router")
    
    -- Update call state before bridging
    update_call_state("ROUTING_TO_INTERMEDIATE", "pending")
    
    -- Bridge to intermediate provider using allocated DID as destination
    local bridge_str = "sofia/gateway/" .. next_provider .. "/" .. did
    freeswitch.consoleLog("INFO", "S1->S3: Bridging to " .. bridge_str .. "\n")
    
    -- Set validation timer (Module 2 requirement)
    session:execute("set", "execute_on_answer=sched_hangup +300 allotted_timeout")
    
    -- Execute the bridge
    session:execute("bridge", bridge_str)
    
    -- VALIDATION CHECKPOINT (Module 2): Verify call reached intermediate
    local bridge_result = session:getVariable("bridge_hangup_cause")
    if bridge_result ~= "NORMAL_CLEARING" and bridge_result ~= "SUCCESS" then
        create_checkpoint("bridge_to_intermediate", "SUCCESS", bridge_result, false, 
                         "Bridge failed with cause: " .. (bridge_result or "UNKNOWN"))
        log_security_event("BRIDGE_FAILED", "HIGH", 
                          "Failed to reach intermediate: " .. (bridge_result or "UNKNOWN"))
    else
        -- Validate call state at destination
        session:sleep(1000)  -- Give time for call setup
        if not validate_destination_state(next_provider, "ANSWERED", 5000) then
            freeswitch.consoleLog("ERROR", "Validation failed - call may be diverted\n")
            log_security_event("POSSIBLE_DIVERSION", "CRITICAL", 
                             "Call did not reach intended intermediate provider")
            -- Hang up to avoid charges (Module 2 requirement)
            session:hangup("CALL_REJECTED")
        else
            update_call_state("CALL_AT_INTERMEDIATE", "validated")
        end
    end
    
elseif stage == "intermediate" then
    -- ========================================================================
    -- S3->S2: Return from intermediate, route to final destination
    -- ========================================================================
    
    freeswitch.consoleLog("INFO", "Processing intermediate return call (S3->S2->S4)\n")
    
    -- VALIDATION: Verify this is a legitimate return call (Module 2 requirement)
    local origin_network = session:getVariable("sip_h_X-Origin-Network") or ""
    local expected_origin = "10.0.0.1"  -- S1's IP
    
    -- Check if call originated from S1
    local origin_check_sql = string.format(
        "SELECT origin_server FROM call_states WHERE call_uuid = '%s'",
        call_uuid)
    
    local valid_origin = false
    dbh:query(origin_check_sql, function(row)
        if row.origin_server == expected_origin then
            valid_origin = true
        end
    end)
    
    if not valid_origin then
        create_checkpoint("return_validation", expected_origin, network_addr, false, 
                         "Invalid return - not from original S1")
        log_security_event("INVALID_RETURN", "CRITICAL", 
                          "Return call not from original source - possible fraud")
        freeswitch.consoleLog("ERROR", "Invalid return call - rejecting with 503\n")
        session:respond("503", "Service Unavailable")
        dbh:release()
        return
    end
    
    create_checkpoint("return_validation", expected_origin, expected_origin, true, nil)
    update_call_state("RETURN_FROM_INTERMEDIATE", "validating")
    
    -- The DNIS should be the DID we allocated
    local did = dnis
    
    -- Retrieve original call information from DID allocation
    local lookup_sql = string.format(
        "SELECT destination, original_ani, call_id FROM dids " ..
        "WHERE did = '%s' AND in_use = true", did)
    
    local orig_ani = nil
    local orig_dnis = nil
    local orig_call_id = nil
    
    dbh:query(lookup_sql, function(row)
        orig_dnis = row.destination
        orig_ani = row.original_ani
        orig_call_id = row.call_id
    end)
    
    -- Validate DID lookup
    if not orig_dnis or not orig_ani then
        -- Fallback to SIP headers if database lookup fails
        freeswitch.consoleLog("WARN", "Using SIP headers as fallback for call info\n")
        orig_ani = session:getVariable("sip_h_X-Original-ANI") or ani
        orig_dnis = session:getVariable("sip_h_X-Original-DNIS") or dnis
        create_checkpoint("did_lookup", "DATABASE", "SIP_HEADERS", false, 
                         "Database lookup failed, using headers")
    else
        create_checkpoint("did_lookup", did, did, true, nil)
    end
    
    if not orig_dnis then
        freeswitch.consoleLog("ERROR", "Cannot determine original DNIS for DID: " .. did .. "\n")
        log_security_event("DID_LOOKUP_FAILED", "HIGH", "Unable to restore original call info")
        session:hangup("UNSPECIFIED")
        dbh:release()
        return
    end
    
    freeswitch.consoleLog("INFO", string.format(
        "DID lookup: DID=%s, Original ANI=%s, Original DNIS=%s\n",
        did, orig_ani or "unknown", orig_dnis))
    
    -- Update call record status
    local call_update_sql = string.format(
        "UPDATE calls SET status = 'forwarding', updated_at = CURRENT_TIMESTAMP " ..
        "WHERE uuid = '%s' OR route_id = %s",
        call_uuid, route_id)
    
    dbh:query(call_update_sql)
    update_call_state("ROUTING_TO_FINAL", "pending")
    
    -- Release the DID back to the pool
    local release_sql = string.format(
        "UPDATE dids SET in_use = false, destination = NULL, " ..
        "original_ani = NULL, call_id = NULL, allocated_at = NULL, " ..
        "validation_failures = CASE " ..
        "  WHEN last_validation_check < NOW() - INTERVAL '5 seconds' " ..
        "  THEN validation_failures + 1 ELSE validation_failures END " ..
        "WHERE did = '%s'", did)
    
    dbh:query(release_sql)
    freeswitch.consoleLog("INFO", "Released DID: " .. did .. "\n")
    create_checkpoint("did_release", did, "RELEASED", true, nil)
    
    -- Restore original caller ID for final destination
    session:setVariable("effective_caller_id_number", orig_ani)
    session:setVariable("effective_caller_id_name", "S2-Router")
    
    -- Set SIP headers for final provider
    session:setVariable("sip_h_X-Original-ANI", orig_ani)
    session:setVariable("sip_h_X-Original-DNIS", orig_dnis)
    session:setVariable("sip_h_X-Route-ID", route_id)
    session:setVariable("sip_h_X-Call-Stage", "2")
    session:setVariable("sip_h_X-Validation-Status", "passed")
    
    -- Bridge to final provider with original DNIS
    local bridge_str = "sofia/gateway/" .. final_provider .. "/" .. orig_dnis
    freeswitch.consoleLog("INFO", "S3->S4: Bridging to " .. bridge_str .. "\n")
    freeswitch.consoleLog("INFO", string.format(
        "Call restoration: ANI=%s, DNIS=%s\n", orig_ani, orig_dnis))
    
    -- Execute the bridge
    session:execute("bridge", bridge_str)
    
    -- Final validation
    local final_result = session:getVariable("bridge_hangup_cause")
    if final_result == "NORMAL_CLEARING" or final_result == "SUCCESS" then
        update_call_state("COMPLETED", "success")
        create_checkpoint("final_delivery", "SUCCESS", "SUCCESS", true, nil)
    else
        update_call_state("FAILED", "failed")
        create_checkpoint("final_delivery", "SUCCESS", final_result, false, 
                         "Final delivery failed: " .. (final_result or "UNKNOWN"))
        log_security_event("FINAL_DELIVERY_FAILED", "HIGH", 
                          "Failed to deliver to final destination")
    end
    
else
    freeswitch.consoleLog("ERROR", "Unknown stage: " .. stage .. "\n")
    log_security_event("INVALID_STAGE", "MEDIUM", "Unknown routing stage: " .. stage)
    session:hangup("UNSPECIFIED")
end

-- Update validation history for analytics
local validation_sql = string.format(
    "INSERT INTO call_validation_history (call_uuid, route_id, validation_type, result) " ..
    "VALUES ('%s', %s, '%s', '%s')",
    call_uuid, route_id, stage, session:getVariable("bridge_hangup_cause") or "UNKNOWN")

dbh:query(validation_sql)

-- Cleanup database connection
dbh:release()

freeswitch.consoleLog("INFO", "Route handler with validation completed for stage: " .. stage .. "\n")
