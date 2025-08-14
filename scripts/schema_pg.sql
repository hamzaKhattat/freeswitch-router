-- FreeSWITCH Dynamic Router PostgreSQL Schema
-- Version 3.0 - Complete Dynamic Configuration
-- 
-- This schema uses proper PostgreSQL BOOLEAN types
-- Compatible with the existing codebase

-- Drop existing tables if needed (be careful in production!)
DROP TABLE IF EXISTS call_records CASCADE;
DROP TABLE IF EXISTS calls CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS dids CASCADE;
DROP TABLE IF EXISTS providers CASCADE;
DROP TABLE IF EXISTS active_calls CASCADE;

-- Providers table (S1, S3, S4 servers)
CREATE TABLE providers (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(64) UNIQUE,
    name VARCHAR(256) UNIQUE NOT NULL,
    host VARCHAR(256) NOT NULL,
    port INTEGER DEFAULT 5060,
    auth_type VARCHAR(32) DEFAULT 'ip',
    auth_data TEXT,
    transport VARCHAR(16) DEFAULT 'udp',
    capacity INTEGER DEFAULT 100,
    role VARCHAR(32) DEFAULT 'general', -- 'origin', 'intermediate', 'final', 'general'
    current_calls INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,  -- Changed from INTEGER to BOOLEAN
    priority INTEGER DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Routes table (defines call flow patterns)
CREATE TABLE routes (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(64) UNIQUE,
    name VARCHAR(256),
    pattern VARCHAR(256) NOT NULL,
    provider_id INTEGER REFERENCES providers(id) ON DELETE CASCADE,
    origin_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    intermediate_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    final_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    inbound_provider VARCHAR(256),
    intermediate_provider VARCHAR(256),
    final_provider VARCHAR(256),
    priority INTEGER DEFAULT 100,
    active BOOLEAN DEFAULT true,  -- Changed from INTEGER to BOOLEAN
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DIDs table (DID pool for number manipulation)
CREATE TABLE dids (
    id SERIAL PRIMARY KEY,
    did VARCHAR(64) UNIQUE NOT NULL,
    country VARCHAR(32) DEFAULT 'US',
    provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    in_use BOOLEAN DEFAULT false,  -- Changed from INTEGER to BOOLEAN
    destination VARCHAR(64),
    original_ani VARCHAR(64),
    call_id VARCHAR(256),
    allocated_at TIMESTAMP,
    active BOOLEAN DEFAULT true,  -- Changed from INTEGER to BOOLEAN
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Calls table (active and historical calls)
CREATE TABLE calls (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(256),
    ani VARCHAR(64),
    dnis VARCHAR(64),
    provider VARCHAR(256),
    route_id INTEGER REFERENCES routes(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    answered_at TIMESTAMP,
    ended_at TIMESTAMP,
    duration INTEGER
);

-- Call records table (detailed call tracking)
CREATE TABLE call_records (
    id SERIAL PRIMARY KEY,
    call_id VARCHAR(256),
    original_ani VARCHAR(64),
    original_dnis VARCHAR(64),
    assigned_did VARCHAR(64),
    origin_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    intermediate_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    final_provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    source_server VARCHAR(64),
    status VARCHAR(32) DEFAULT 'routing',
    stage INTEGER DEFAULT 1,  -- 1=origin->intermediate, 2=intermediate->final
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP
);

-- Active calls tracking (for real-time monitoring)
CREATE TABLE active_calls (
    id SERIAL PRIMARY KEY,
    call_uuid VARCHAR(256) UNIQUE NOT NULL,
    ani VARCHAR(64),
    dnis VARCHAR(64),
    provider_id INTEGER REFERENCES providers(id),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_providers_role ON providers(role);
CREATE INDEX idx_providers_active ON providers(active);
CREATE INDEX idx_providers_uuid ON providers(uuid);
CREATE INDEX idx_routes_pattern ON routes(pattern);
CREATE INDEX idx_routes_priority ON routes(priority);
CREATE INDEX idx_routes_active ON routes(active);
CREATE INDEX idx_dids_in_use ON dids(in_use);
CREATE INDEX idx_dids_active ON dids(active);
CREATE INDEX idx_dids_did ON dids(did);
CREATE INDEX idx_calls_status ON calls(status);
CREATE INDEX idx_calls_created ON calls(created_at);
CREATE INDEX idx_call_records_call_id ON call_records(call_id);
CREATE INDEX idx_call_records_status ON call_records(status);

-- Insert sample providers (S1, S3, S4)
INSERT INTO providers (uuid, name, host, port, auth_type, auth_data, role, capacity, active)
VALUES 
    ('s1-' || gen_random_uuid(), 's1', '10.0.0.1', 5060, 'ip', '10.0.0.1', 'origin', 1000, true),
    ('s3-' || gen_random_uuid(), 's3', '10.0.0.3', 5060, 'ip', '10.0.0.3', 'intermediate', 1000, true),
    ('s4-' || gen_random_uuid(), 's4', '10.0.0.4', 5060, 'ip', '10.0.0.4', 'final', 1000, true);

-- Insert sample DIDs (US numbers for testing)
INSERT INTO dids (did, country, active, in_use)
VALUES 
    ('12125551001', 'US', true, false),
    ('12125551002', 'US', true, false),
    ('12125551003', 'US', true, false),
    ('12125551004', 'US', true, false),
    ('12125551005', 'US', true, false),
    ('13105551001', 'US', true, false),
    ('13105551002', 'US', true, false),
    ('13105551003', 'US', true, false),
    ('14155551001', 'US', true, false),
    ('14155551002', 'US', true, false);

-- Create a sample route
INSERT INTO routes (uuid, name, pattern, origin_provider_id, intermediate_provider_id, final_provider_id, priority, active)
SELECT 
    'route-' || gen_random_uuid(),
    'default_route',
    '1[2-9][0-9]{9}',  -- US number pattern
    p1.id,
    p2.id,
    p3.id,
    100,
    true
FROM 
    providers p1,
    providers p2,
    providers p3
WHERE 
    p1.name = 's1' AND p1.role = 'origin'
    AND p2.name = 's3' AND p2.role = 'intermediate'
    AND p3.name = 's4' AND p3.role = 'final';

-- Create helper functions for DID management
CREATE OR REPLACE FUNCTION allocate_did(
    p_ani VARCHAR,
    p_dnis VARCHAR,
    p_call_id VARCHAR,
    p_country VARCHAR DEFAULT 'US'
)
RETURNS TABLE(did_number VARCHAR, did_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    UPDATE dids 
    SET in_use = true,
        destination = p_dnis,
        original_ani = p_ani,
        call_id = p_call_id,
        allocated_at = CURRENT_TIMESTAMP
    WHERE id = (
        SELECT id FROM dids 
        WHERE in_use = false 
        AND active = true
        AND (p_country IS NULL OR country = p_country)
        ORDER BY id 
        LIMIT 1
        FOR UPDATE SKIP LOCKED
    )
    RETURNING did, id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION release_did(p_did VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE dids 
    SET in_use = false,
        destination = NULL,
        original_ani = NULL,
        call_id = NULL,
        allocated_at = NULL
    WHERE did = p_did;
END;
$$ LANGUAGE plpgsql;

-- Create view for monitoring
CREATE OR REPLACE VIEW system_status AS
SELECT 
    (SELECT COUNT(*) FROM providers WHERE active = true) as active_providers,
    (SELECT COUNT(*) FROM routes WHERE active = true) as active_routes,
    (SELECT COUNT(*) FROM dids WHERE active = true) as total_dids,
    (SELECT COUNT(*) FROM dids WHERE in_use = true) as dids_in_use,
    (SELECT COUNT(*) FROM calls WHERE status = 'active') as active_calls,
    (SELECT COUNT(*) FROM providers WHERE role = 'origin' AND active = true) as origin_providers,
    (SELECT COUNT(*) FROM providers WHERE role = 'intermediate' AND active = true) as intermediate_providers,
    (SELECT COUNT(*) FROM providers WHERE role = 'final' AND active = true) as final_providers;

-- Grant permissions (adjust user as needed)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO router;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO router;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO router;

-- Display summary
SELECT 'Database schema created successfully!' as status;
SELECT * FROM system_status;
