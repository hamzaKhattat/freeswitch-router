-- schema_validation.sql - Complete Schema with Module 2 Validation Support
-- PostgreSQL Schema for FreeSWITCH Router with Call Validation

-- Drop existing tables if needed (careful in production!)
DROP TABLE IF EXISTS validation_checkpoints CASCADE;
DROP TABLE IF EXISTS security_events CASCADE;
DROP TABLE IF EXISTS call_states CASCADE;
DROP TABLE IF EXISTS call_validation_rules CASCADE;

-- Enhanced providers table with UUID and config paths
ALTER TABLE providers ADD COLUMN IF NOT EXISTS uuid VARCHAR(64) UNIQUE;
ALTER TABLE providers ADD COLUMN IF NOT EXISTS config_file_path VARCHAR(512);
ALTER TABLE providers ADD COLUMN IF NOT EXISTS profile_name VARCHAR(50) DEFAULT 'external';
ALTER TABLE providers ADD COLUMN IF NOT EXISTS last_validated_at TIMESTAMP;
ALTER TABLE providers ADD COLUMN IF NOT EXISTS validation_status VARCHAR(50) DEFAULT 'pending';

-- Enhanced routes table with dialplan paths
ALTER TABLE routes ADD COLUMN IF NOT EXISTS uuid VARCHAR(64) UNIQUE;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS dialplan_file_path VARCHAR(512);
ALTER TABLE routes ADD COLUMN IF NOT EXISTS validation_enabled BOOLEAN DEFAULT true;
ALTER TABLE routes ADD COLUMN IF NOT EXISTS validation_threshold INTEGER DEFAULT 3;

-- Call state tracking table for Module 2 validation
CREATE TABLE IF NOT EXISTS call_states (
    id SERIAL PRIMARY KEY,
    call_uuid VARCHAR(255) UNIQUE NOT NULL,
    route_id INTEGER REFERENCES routes(id),
    current_state VARCHAR(50) NOT NULL,
    origin_server VARCHAR(255),
    origin_provider_id INTEGER REFERENCES providers(id),
    intermediate_server VARCHAR(255),
    intermediate_provider_id INTEGER REFERENCES providers(id),
    final_server VARCHAR(255),
    final_provider_id INTEGER REFERENCES providers(id),
    validation_status VARCHAR(50) DEFAULT 'pending',
    last_validated_at TIMESTAMP,
    ani VARCHAR(50),
    dnis VARCHAR(50),
    assigned_did VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_call_uuid (call_uuid),
    INDEX idx_validation_status (validation_status),
    INDEX idx_current_state (current_state)
);

-- Security events table for validation failures
CREATE TABLE IF NOT EXISTS security_events (
    id SERIAL PRIMARY KEY,
    call_uuid VARCHAR(255),
    event_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) DEFAULT 'WARNING',
    details TEXT,
    source_ip VARCHAR(45),
    destination_ip VARCHAR(45),
    provider_id INTEGER REFERENCES providers(id),
    action_taken VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_event_type (event_type),
    INDEX idx_severity (severity),
    INDEX idx_created_at (created_at)
);

-- Call validation checkpoints for audit trail
CREATE TABLE IF NOT EXISTS validation_checkpoints (
    id SERIAL PRIMARY KEY,
    call_uuid VARCHAR(255) NOT NULL,
    route_id INTEGER REFERENCES routes(id),
    checkpoint_name VARCHAR(100) NOT NULL,
    checkpoint_stage VARCHAR(50),
    expected_value VARCHAR(255),
    actual_value VARCHAR(255),
    passed BOOLEAN DEFAULT false,
    failure_reason TEXT,
    retry_count INTEGER DEFAULT 0,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_checkpoint_call (call_uuid),
    INDEX idx_checkpoint_passed (passed),
    INDEX idx_checkpoint_stage (checkpoint_stage)
);

-- Validation rules configuration
CREATE TABLE IF NOT EXISTS call_validation_rules (
    id SERIAL PRIMARY KEY,
    rule_name VARCHAR(100) UNIQUE NOT NULL,
    rule_type VARCHAR(50) NOT NULL, -- 'state_check', 'origin_verify', 'timeout', 'rate_limit'
    provider_id INTEGER REFERENCES providers(id),
    route_id INTEGER REFERENCES routes(id),
    parameters JSONB,
    enabled BOOLEAN DEFAULT true,
    priority INTEGER DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enhanced DIDs table with validation tracking
ALTER TABLE dids ADD COLUMN IF NOT EXISTS last_validation_check TIMESTAMP;
ALTER TABLE dids ADD COLUMN IF NOT EXISTS validation_failures INTEGER DEFAULT 0;
ALTER TABLE dids ADD COLUMN IF NOT EXISTS locked_until TIMESTAMP;

-- Call validation history for analytics
CREATE TABLE IF NOT EXISTS call_validation_history (
    id SERIAL PRIMARY KEY,
    call_uuid VARCHAR(255),
    route_id INTEGER REFERENCES routes(id),
    provider_id INTEGER REFERENCES providers(id),
    validation_type VARCHAR(50),
    result VARCHAR(20),
    response_time_ms INTEGER,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_history_date (created_at),
    INDEX idx_history_result (result)
);

-- Insert default validation rules
INSERT INTO call_validation_rules (rule_name, rule_type, parameters, enabled, priority) VALUES
('verify_origin', 'origin_verify', '{"check_ip": true, "check_header": true}'::jsonb, true, 100),
('state_transition', 'state_check', '{"timeout_ms": 5000, "retry": 3}'::jsonb, true, 90),
('call_timeout', 'timeout', '{"max_duration_seconds": 3600}'::jsonb, true, 80),
('rate_limit_check', 'rate_limit', '{"max_calls_per_minute": 100}'::jsonb, true, 70)
ON CONFLICT (rule_name) DO NOTHING;

-- Function to update provider config paths
CREATE OR REPLACE FUNCTION update_provider_config_paths() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.uuid IS NOT NULL THEN
        NEW.config_file_path = '/etc/freeswitch/sip_profiles/' || 
                              CASE 
                                  WHEN NEW.role = 'intermediate' THEN 'internal'
                                  ELSE 'external'
                              END || '/' || NEW.uuid || '.xml';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update route dialplan paths
CREATE OR REPLACE FUNCTION update_route_dialplan_paths() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id IS NOT NULL THEN
        NEW.dialplan_file_path = '/etc/freeswitch/dialplan/public/route_' || NEW.id || '.xml';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
DROP TRIGGER IF EXISTS update_provider_config ON providers;
CREATE TRIGGER update_provider_config 
    BEFORE INSERT OR UPDATE ON providers
    FOR EACH ROW 
    EXECUTE FUNCTION update_provider_config_paths();

DROP TRIGGER IF EXISTS update_route_dialplan ON routes;
CREATE TRIGGER update_route_dialplan 
    BEFORE INSERT OR UPDATE ON routes
    FOR EACH ROW 
    EXECUTE FUNCTION update_route_dialplan_paths();

-- Validation statistics view
CREATE OR REPLACE VIEW validation_statistics AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_validations,
    SUM(CASE WHEN passed THEN 1 ELSE 0 END) as passed,
    SUM(CASE WHEN NOT passed THEN 1 ELSE 0 END) as failed,
    AVG(CASE WHEN passed THEN 1 ELSE 0 END) * 100 as success_rate
FROM validation_checkpoints
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Security events summary view
CREATE OR REPLACE VIEW security_summary AS
SELECT 
    DATE(created_at) as date,
    event_type,
    severity,
    COUNT(*) as event_count,
    COUNT(DISTINCT source_ip) as unique_sources
FROM security_events
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY DATE(created_at), event_type, severity
ORDER BY date DESC, event_count DESC;

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_providers_uuid ON providers(uuid);
CREATE INDEX IF NOT EXISTS idx_routes_uuid ON routes(uuid);
CREATE INDEX IF NOT EXISTS idx_providers_role ON providers(role);
CREATE INDEX IF NOT EXISTS idx_routes_priority ON routes(priority);

-- Grant permissions (adjust as needed)
-- GRANT ALL ON ALL TABLES IN SCHEMA public TO router;
-- GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO router;
