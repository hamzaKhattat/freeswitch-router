-- scripts/schema_module2.sql
-- Enhanced schema for Module 2: Dynamic Call Routing with DID Management

-- Ensure DIDs table has all required fields for Module 2
ALTER TABLE dids ADD COLUMN IF NOT EXISTS destination VARCHAR(64);
ALTER TABLE dids ADD COLUMN IF NOT EXISTS call_id VARCHAR(256);
ALTER TABLE dids ADD COLUMN IF NOT EXISTS original_ani VARCHAR(64);
ALTER TABLE dids ADD COLUMN IF NOT EXISTS allocated_at TIMESTAMP;

-- Create index for faster DID allocation
CREATE INDEX IF NOT EXISTS idx_dids_provider_active_inuse 
ON dids(provider_id, active, in_use);

-- Create call records table for Module 2 tracking
CREATE TABLE IF NOT EXISTS call_records (
    id SERIAL PRIMARY KEY,
    call_id VARCHAR(256) UNIQUE NOT NULL,
    origin_provider_id INTEGER REFERENCES providers(id),
    intermediate_provider_id INTEGER REFERENCES providers(id),
    final_provider_id INTEGER REFERENCES providers(id),
    original_ani VARCHAR(64),
    original_dnis VARCHAR(64),
    assigned_did VARCHAR(64),
    current_stage INTEGER DEFAULT 1, -- 1=S1->S2, 2=S2->S3, 3=S3->S2, 4=S2->S4
    status VARCHAR(32) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    failure_reason TEXT
);

-- Create CDR table for Module 2
CREATE TABLE IF NOT EXISTS module2_cdrs (
    id SERIAL PRIMARY KEY,
    call_id VARCHAR(256),
    route_id INTEGER REFERENCES routes(id),
    stage VARCHAR(32), -- 'origin', 'intermediate', 'final'
    source_ip VARCHAR(64),
    destination_ip VARCHAR(64),
    ani VARCHAR(64),
    dnis VARCHAR(64),
    did_used VARCHAR(64),
    start_time TIMESTAMP,
    answer_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INTEGER,
    billsec INTEGER,
    disposition VARCHAR(32),
    sip_cause_code INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for CDR queries
CREATE INDEX IF NOT EXISTS idx_module2_cdrs_call_id ON module2_cdrs(call_id);
CREATE INDEX IF NOT EXISTS idx_module2_cdrs_created_at ON module2_cdrs(created_at);
CREATE INDEX IF NOT EXISTS idx_module2_cdrs_route_id ON module2_cdrs(route_id);

-- Create DID allocation history table
CREATE TABLE IF NOT EXISTS did_allocation_history (
    id SERIAL PRIMARY KEY,
    did_id INTEGER REFERENCES dids(id),
    did VARCHAR(64),
    call_id VARCHAR(256),
    original_ani VARCHAR(64),
    original_dnis VARCHAR(64),
    allocated_at TIMESTAMP,
    released_at TIMESTAMP,
    duration_seconds INTEGER
);

-- Create route cache table
CREATE TABLE IF NOT EXISTS route_dialplan_cache (
    id SERIAL PRIMARY KEY,
    route_id INTEGER REFERENCES routes(id),
    route_name VARCHAR(256),
    xml_content TEXT,
    filename VARCHAR(512),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP
);

-- Function to allocate DID
CREATE OR REPLACE FUNCTION allocate_did(
    p_provider_id INTEGER,
    p_call_id VARCHAR,
    p_ani VARCHAR,
    p_dnis VARCHAR
) RETURNS VARCHAR AS $
DECLARE
    v_did VARCHAR(64);
    v_did_id INTEGER;
BEGIN
    -- Select a random available DID
    SELECT id, did INTO v_did_id, v_did
    FROM dids
    WHERE provider_id = p_provider_id
      AND active = true
      AND in_use = false
    ORDER BY RANDOM()
    LIMIT 1
    FOR UPDATE;
    
    IF v_did IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Mark DID as in use
    UPDATE dids
    SET in_use = true,
        destination = p_dnis,
        original_ani = p_ani,
        call_id = p_call_id,
        allocated_at = NOW()
    WHERE id = v_did_id;
    
    -- Record in history
    INSERT INTO did_allocation_history (did_id, did, call_id, original_ani, original_dnis, allocated_at)
    VALUES (v_did_id, v_did, p_call_id, p_ani, p_dnis, NOW());
    
    RETURN v_did;
END;
$ LANGUAGE plpgsql;

-- Function to release DID
CREATE OR REPLACE FUNCTION release_did(p_did VARCHAR) RETURNS BOOLEAN AS $
DECLARE
    v_did_id INTEGER;
    v_call_id VARCHAR;
    v_allocated_at TIMESTAMP;
BEGIN
    -- Get DID info
    SELECT id, call_id, allocated_at INTO v_did_id, v_call_id, v_allocated_at
    FROM dids
    WHERE did = p_did AND in_use = true;
    
    IF v_did_id IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Release the DID
    UPDATE dids
    SET in_use = false,
        destination = NULL,
        original_ani = NULL,
        call_id = NULL,
        allocated_at = NULL
    WHERE id = v_did_id;
    
    -- Update history
    UPDATE did_allocation_history
    SET released_at = NOW(),
        duration_seconds = EXTRACT(EPOCH FROM (NOW() - allocated_at))
    WHERE did_id = v_did_id AND call_id = v_call_id AND released_at IS NULL;
    
    RETURN TRUE;
END;
$ LANGUAGE plpgsql;

-- View for active DID usage
CREATE OR REPLACE VIEW v_active_did_usage AS
SELECT 
    d.did,
    d.country,
    p.name as provider_name,
    d.destination,
    d.original_ani,
    d.call_id,
    d.allocated_at,
    EXTRACT(EPOCH FROM (NOW() - d.allocated_at)) as seconds_in_use
FROM dids d
LEFT JOIN providers p ON d.provider_id = p.id
WHERE d.in_use = true
ORDER BY d.allocated_at DESC;

-- View for route statistics
CREATE OR REPLACE VIEW v_route_statistics AS
SELECT 
    r.name as route_name,
    r.pattern,
    p1.name as origin_provider,
    p2.name as intermediate_provider,
    p3.name as final_provider,
    COUNT(DISTINCT cr.call_id) as total_calls,
    COUNT(DISTINCT CASE WHEN cr.status = 'completed' THEN cr.call_id END) as completed_calls,
    COUNT(DISTINCT CASE WHEN cr.status = 'failed' THEN cr.call_id END) as failed_calls,
    (SELECT COUNT(*) FROM dids WHERE provider_id = p2.id AND active = true) as total_dids,
    (SELECT COUNT(*) FROM dids WHERE provider_id = p2.id AND active = true AND in_use = false) as available_dids
FROM routes r
LEFT JOIN providers p1 ON r.origin_provider_id = p1.id
LEFT JOIN providers p2 ON r.intermediate_provider_id = p2.id
LEFT JOIN providers p3 ON r.final_provider_id = p3.id
LEFT JOIN call_records cr ON (
    cr.origin_provider_id = r.origin_provider_id AND
    cr.intermediate_provider_id = r.intermediate_provider_id AND
    cr.final_provider_id = r.final_provider_id
)
GROUP BY r.id, r.name, r.pattern, p1.name, p2.name, p3.name, p2.id;

-- Trigger to update call_records timestamp
CREATE OR REPLACE FUNCTION update_call_record_timestamp() RETURNS TRIGGER AS $
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER trg_call_records_update
BEFORE UPDATE ON call_records
FOR EACH ROW
EXECUTE FUNCTION update_call_record_timestamp();

-- Sample data for testing Module 2
-- Insert sample providers with appropriate roles
INSERT INTO providers (uuid, name, host, port, role, auth_type, auth_data, capacity, active)
VALUES 
    ('s1-uuid-' || gen_random_uuid(), 's1', '10.0.0.1', 5060, 'origin', 'ip', 'ip:10.0.0.1', 1000, true),
    ('s3-uuid-' || gen_random_uuid(), 's3', '10.0.0.3', 5060, 'intermediate', 'ip', 'ip:10.0.0.3', 1000, true),
    ('s4-uuid-' || gen_random_uuid(), 's4', '10.0.0.4', 5060, 'final', 'ip', 'ip:10.0.0.4', 1000, true)
ON CONFLICT (name) DO NOTHING;

-- Note: DIDs should be imported via CSV for the intermediate provider (s3)
-- Example: did import dids.csv s3 US
