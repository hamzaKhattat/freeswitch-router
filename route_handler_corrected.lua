-- route_handler_corrected.lua
-- Implements Module 2 requirements: S1 -> S2 -> S3 -> S2 -> S4
-- with proper ANI/DNIS/DID transformations

-- Database connection parameters
local db_host = "localhost"
local db_name = "router_db"
local db_user = "router"
local db_pass = "router123"

-- Function to connect to database
function db_connect()
    local dbh = freeswitch.Dbh("pgsql://" .. db_user .. ":" .. db_pass .. "@" .. db_host .. "/" .. db_name)
    if not dbh:connected() then
        freeswitch.consoleLog("ERROR", "Failed to connect to database\n")
        return nil
    end
    return dbh
end

-- Function to allocate a DID from the pool
function allocate_did(dbh, ani, dnis, call_id, provider_id)
    -- Find an available DID associated with the provider
    local query = string.format(
        "SELECT id, did FROM dids WHERE in_use = false AND active = true " ..
        "AND provider_id = %d ORDER BY RANDOM() LIMIT 1",
        provider_id
    )
    
    local allocated_did = nil
    local did_id = nil
    
    dbh:query(query, function(row)
        did_id = row.id
        allocated_did = row.did
    end)
    
    if allocated_did then
        -- Mark DID as in use and store original DNIS
        local update_query = string.format(
            "UPDATE dids SET in_use = true, destination = '%s', " ..
            "original_ani = '%s', call_id = '%s', allocated_at = NOW() " ..
            "WHERE id = %d",
            dnis, ani, call_id, did_id
        )
        dbh:query(update_query)
        
        freeswitch.consoleLog("INFO", 
            string.format("Allocated DID %s for call %s (ANI: %s, DNIS: %s)\n",
                         allocated_did, call_id, ani, dnis))
    end
    
    return allocated_did
end

-- Function to release a DID back to the pool
function release_did(dbh, did)
    local query = string.format(
        "UPDATE dids SET in_use = false, destination = NULL, " ..
        "original_ani = NULL, call_id = NULL, allocated_at = NULL " ..
        "WHERE did = '%s'",
        did
    )
    dbh:query(query)
    freeswitch.consoleLog("INFO", "Released DID: " .. did .. "\n")
end

-- Function to find original DNIS from DID
function find_original_dnis(dbh, did)
    local original_dnis = nil
    local original_ani = nil
    
    local query = string.format(
        "SELECT destination, original_ani FROM dids WHERE did = '%s' AND in_use = true",
        did
    )
    
    dbh:query(query, function(row)
        original_dnis = row.destination
        original_ani = row.original_ani
    end)
    
    return original_dnis, original_ani
end

-- Function to record call in database
function record_call(dbh, call_id, stage, ani, dnis, did, provider_ids)
    local query = nil
    
    if stage == "origin" then
        query = string.format(
            "INSERT INTO call_records (call_id, origin_provider_id, " ..
            "intermediate_provider_id, final_provider_id, original_ani, " ..
            "original_dnis, assigned_did, current_stage, status) " ..
            "VALUES ('%s', %s, %s, %s, '%s', '%s', '%s', 1, 'active') " ..
            "ON CONFLICT (call_id) DO UPDATE SET current_stage = 1, updated_at = NOW()",
            call_id, provider_ids.origin or 'NULL', 
            provider_ids.intermediate or 'NULL',
            provider_ids.final or 'NULL',
            ani, dnis, did or ''
        )
    elseif stage == "intermediate_return" then
        query = string.format(
            "UPDATE call_records SET current_stage = 3, updated_at = NOW() " ..
            "WHERE call_id = '%s'",
            call_id
        )
    end
    
    if query then
        dbh:query(query)
    end
end

-- Main execution
local stage = argv[1] or "unknown"
local route_id = argv[2] or "0"
local next_provider = argv[3] or ""
local final_provider = argv[4] or ""

-- Get call variables
local call_uuid = session:getVariable("uuid")
local ani = session:getVariable("caller_id_number")
local dnis = session:getVariable("destination_number")
local network_addr = session:getVariable("network_addr")

freeswitch.consoleLog("INFO", 
    string.format("Module 2 Route Handler - Stage: %s, ANI: %s, DNIS: %s, Source: %s\n",
                  stage, ani or "nil", dnis or "nil", network_addr or "nil"))

-- Connect to database
local dbh = db_connect()
if not dbh then
    session:hangup("TEMPORARY_FAILURE")
    return
end

if stage == "origin" then
    -- S1 -> S2: Incoming call from origin server
    -- Store original ANI (ANI-1) and DNIS (DNIS-1)
    session:setVariable("original_ani", ani)
    session:setVariable("original_dnis", dnis)
    session:setVariable("sip_h_X-Original-ANI", ani)
    session:setVariable("sip_h_X-Original-DNIS", dnis)
    session:setVariable("sip_h_X-Call-ID", call_uuid)
    
    -- Get intermediate provider ID
    local inter_provider_id = 0
    local query = string.format(
        "SELECT id FROM providers WHERE uuid = '%s'", next_provider
    )
    dbh:query(query, function(row)
        inter_provider_id = tonumber(row.id)
    end)
    
    -- Allocate a DID from the pool
    local allocated_did = allocate_did(dbh, ani, dnis, call_uuid, inter_provider_id)
    
    if not allocated_did then
        freeswitch.consoleLog("ERROR", "No available DID for routing\n")
        session:hangup("CONGESTION")
        dbh:release()
        return
    end
    
    -- Record call in database
    local provider_ids = {
        origin = session:getVariable("origin_provider_id"),
        intermediate = tostring(inter_provider_id),
        final = session:getVariable("final_provider_id")
    }
    record_call(dbh, call_uuid, "origin", ani, dnis, allocated_did, provider_ids)
    
    -- S2 -> S3: Forward to intermediate with transformations
    -- Replace ANI-1 with DNIS-1 (now becomes ANI-2)
    -- Replace DNIS-1 with allocated DID
    session:setVariable("effective_caller_id_number", dnis)  -- DNIS-1 becomes ANI-2
    session:setVariable("effective_caller_id_name", dnis)
    session:setVariable("sip_h_X-Allocated-DID", allocated_did)
    
    -- Bridge to intermediate server with transformed values
    local bridge_str = string.format("sofia/gateway/%s/%s", next_provider, allocated_did)
    freeswitch.consoleLog("INFO", 
        string.format("S1->S2->S3: ANI-1=%s, DNIS-1=%s => ANI-2=%s, DID=%s via %s\n",
                      ani, dnis, dnis, allocated_did, bridge_str))
    
    session:execute("bridge", bridge_str)
    
elseif stage == "intermediate_return" then
    -- S3 -> S2: Return call from intermediate server
    -- The call comes back with ANI-2 (which was DNIS-1) and DID
    
    -- Find the original DNIS-1 and ANI-1 from the DID
    local original_dnis, original_ani = find_original_dnis(dbh, dnis)
    
    if not original_dnis then
        freeswitch.consoleLog("ERROR", 
            string.format("No mapping found for DID %s - rejecting call\n", dnis))
        session:hangup("CALL_REJECTED")
        dbh:release()
        return
    end
    
    -- Verify this call originated from S1
    local call_id = session:getVariable("sip_h_X-Call-ID") or call_uuid
    local verify_query = string.format(
        "SELECT COUNT(*) as count FROM call_records " ..
        "WHERE call_id = '%s' AND origin_provider_id IS NOT NULL",
        call_id
    )
    
    local is_valid = false
    dbh:query(verify_query, function(row)
        is_valid = (tonumber(row.count) > 0)
    end)
    
    if not is_valid then
        freeswitch.consoleLog("ERROR", "Call not originated from S1 - rejecting with 503\n")
        session:hangup("SERVICE_UNAVAILABLE")
        dbh:release()
        return
    end
    
    -- Update call record
    record_call(dbh, call_id, "intermediate_return", ani, dnis, nil, {})
    
    -- Release the DID back to the pool
    release_did(dbh, dnis)
    
    -- S2 -> S4: Restore original values and forward to final destination
    -- Restore ANI-1 and DNIS-1
    session:setVariable("effective_caller_id_number", original_ani)
    session:setVariable("effective_caller_id_name", original_ani)
    
    local bridge_str = string.format("sofia/gateway/%s/%s", final_provider, original_dnis)
    freeswitch.consoleLog("INFO", 
        string.format("S3->S2->S4: Restored ANI-1=%s, DNIS-1=%s, bridging to %s\n",
                      original_ani, original_dnis, bridge_str))
    
    session:execute("bridge", bridge_str)
    
else
    freeswitch.consoleLog("ERROR", "Unknown routing stage: " .. stage .. "\n")
    session:hangup("UNSPECIFIED")
end

-- Clean up database connection
if dbh then
    dbh:release()
end

