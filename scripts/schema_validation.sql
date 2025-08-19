-- scripts/schema_validation.sql
-- Call Validation System Database Schema

-- Call validation records table
CREATE TABLE IF NOT EXISTS call_validations (
    id SERIAL PRIMARY KEY,
    call_id VARCHAR(256) UNIQUE NOT NULL,
    call_uuid VARCHAR(64),
    origin_ani VARCHAR(64),
    origin_dnis VARCHAR(64),
    assigned_did VARCHAR(64),
    
    -- Server tracking
    origin_server_id INTEGER REFERENCES providers(id),
    intermediate_server_id INTEGER REFERENCES providers(id),
    final_server_id INTEGER REFERENCES providers(id),
    origin_server_ip VARCHAR(64),
    destination_server_ip VARCHAR(64),
    
    -- State tracking
    current_state INTEGER NOT NULL DEFAULT 1,
    -- 1=ORIGINATED, 2=RINGING, 3=ANSWERED, 4=HUNG_UP, 5=FAILED, 6=DIVERTED
    expected_state INTEGER,
    validation_status VARCHAR(32) DEFAULT 'active',
    -- active, completed, failed, expired
    
    -- Validation flags
    origin_validated BOOLEAN DEFAULT false,
    destination_validated BOOLEAN DEFAULT false,
    route_validated BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    validated_at TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_call_validations_call_id (call_id),
    INDEX idx_call_validations_status (validation_status),
    INDEX idx_call_validations_created (created_at)
);

-- Validation checkpoints table
CREATE TABLE IF NOT EXISTS validation_checkpoints (
    id SERIAL PRIMARY KEY,
    checkpoint_name VARCHAR(128) NOT NULL,
    route_id INTEGER,
    call_id VARCHAR(256),
    passed BOOLEAN NOT NULL,
    failure_reason VARCHAR(256),
    metadata JSON,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_checkpoints_call_id (call_id),
    INDEX idx_checkpoints_route_id (route_id),
    INDEX idx_checkpoints_checked_at (checked_at),
    INDEX idx_checkpoints_passed (passed)
);

-- Security events table
CREATE TABLE IF NOT EXISTS security_events (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(64) NOT NULL,
    severity VARCHAR(32) NOT NULL,
    -- CRITICAL, HIGH, MEDIUM, LOW
    call_id VARCHAR(256),
    source_ip VARCHAR(64),
    target_ip VARCHAR(64),
    provider_id INTEGER REFERENCES providers(id),
    details TEXT,
    resolution VARCHAR(256),
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_security_events_type (event_type),
    INDEX idx_security_events_severity (severity),
    INDEX idx_security_events_call_id (call_id),
    INDEX idx_security_events_created (created_at)
);

-- Call validation rules table
CREATE TABLE IF NOT EXISTS call_validation_rules (
    id SERIAL PRIMARY KEY,
    rule_name VARCHAR(128) UNIQUE NOT NULL,
    rule_type VARCHAR(64) NOT NULL,
    -- origin_validation, did_validation, rate_limit, blacklist, etc.
    rule_condition TEXT,
    action VARCHAR(64) NOT NULL,
    -- allow, deny, flag, alert
    priority INTEGER DEFAULT 100,
    enabled BOOLEAN DEFAULT true,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_validation_rules_type (rule_type),
    INDEX idx_validation_rules_priority (priority),
    INDEX idx_validation_rules_enabled (enabled)
);

-- Blocked numbers table for blacklist
CREATE TABLE IF NOT EXISTS blocked_numbers (
    id SERIAL PRIMARY KEY,
    number VARCHAR(64) UNIQUE NOT NULL,
    reason VARCHAR(256),
    blocked_by VARCHAR(128),
    blocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    active BOOLEAN DEFAULT true,
    
    -- Indexes
    INDEX idx_blocked_numbers_number (number),
    INDEX idx_blocked_numbers_active (active)
);

-- Rate limiting table
CREATE TABLE IF NOT EXISTS rate_limits (
    id SERIAL PRIMARY KEY,
    provider_id INTEGER REFERENCES providers(id),
    limit_type VARCHAR(64) NOT NULL,
    -- calls_per_minute, concurrent_calls, etc.
    limit_value INTEGER NOT NULL,
    current_value INTEGER DEFAULT 0,
    window_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    window_duration_seconds INTEGER DEFAULT 60,
    
    -- Indexes
    INDEX idx_rate_limits_provider (provider_id),
    INDEX idx_rate_limits_type (limit_type)
);

-- Validation statistics table
CREATE TABLE IF NOT EXISTS validation_statistics (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    hour INTEGER NOT NULL,
    provider_id INTEGER REFERENCES providers(id),
    total_calls INTEGER DEFAULT 0,
    validated_calls INTEGER DEFAULT 0,
    failed_validations INTEGER DEFAULT 0,
    diverted_calls INTEGER DEFAULT 0,
    security_events INTEGER DEFAULT 0,
    avg_validation_time_ms INTEGER,
    
    -- Constraints
    UNIQUE(date, hour, provider_id),
    
    -- Indexes
    INDEX idx_validation_stats_date (date),
    INDEX idx_validation_stats_provider (provider_id)
);

-- Insert default validation rules
INSERT INTO call_validation_rules (rule_name, rule_type, rule_condition, action, priority)
VALUES 
    ('Check Origin Server', 'origin_validation', 
     'source_ip IN (SELECT host FROM providers WHERE role = ''origin'' AND active = true)', 
     'allow', 100),
    
    ('Verify DID Ownership', 'did_validation', 
     'did IN (SELECT did FROM dids WHERE active = true AND in_use = false)', 
     'allow', 90),
    
    ('Rate Limit - Calls per Minute', 'rate_limit', 
     'calls_per_minute < 100', 
     'allow', 80),
    
    ('Rate Limit - Concurrent Calls', 'concurrent_limit', 
     'concurrent_calls < 500', 
     'allow', 70),
    
    ('Blacklist Check', 'blacklist', 
     'ani NOT IN (SELECT number FROM blocked_numbers WHERE active = true)', 
     'allow', 60),
    
    ('International Call Validation', 'international_validation',
     'dnis NOT LIKE ''011%'' OR provider_role = ''international''',
     'allow', 50),
    
    ('Call Duration Limit', 'duration_limit',
     'call_duration < 3600',
     'allow', 40),
    
    ('Suspicious Pattern Detection', 'pattern_detection',
     'NOT (ani = dnis OR ani LIKE ''%0000000'' OR dnis LIKE ''%0000000'')',
     'flag', 30)
ON CONFLICT (rule_name) DO NOTHING;

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_call_validations_updated_at 
    BEFORE UPDATE ON call_validations 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_validation_rules_updated_at 
    BEFORE UPDATE ON call_validation_rules 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Create function to log validation statistics
CREATE OR REPLACE FUNCTION log_validation_stats()
RETURNS void AS $$
DECLARE
    current_hour INTEGER;
    current_date DATE;
BEGIN
    current_hour := EXTRACT(HOUR FROM CURRENT_TIMESTAMP);
    current_date := CURRENT_DATE;
    
    INSERT INTO validation_statistics (date, hour, provider_id, total_calls, 
                                      validated_calls, failed_validations, 
                                      diverted_calls, security_events)
    SELECT 
        current_date,
        current_hour,
        p.id,
        COUNT(DISTINCT cv.call_id) as total_calls,
        COUNT(DISTINCT CASE WHEN cv.validation_status = 'completed' THEN cv.call_id END) as validated_calls,
        COUNT(DISTINCT CASE WHEN cv.validation_status = 'failed' THEN cv.call_id END) as failed_validations,
        COUNT(DISTINCT CASE WHEN cv.current_state = 6 THEN cv.call_id END) as diverted_calls,
        COUNT(DISTINCT se.call_id) as security_events
    FROM providers p
    LEFT JOIN call_validations cv ON (cv.origin_server_id = p.id 
                                    OR cv.intermediate_server_id = p.id 
                                    OR cv.final_server_id = p.id)
                                   AND cv.created_at >= current_date + current_hour * INTERVAL '1 hour'
                                   AND cv.created_at < current_date + (current_hour + 1) * INTERVAL '1 hour'
    LEFT JOIN security_events se ON se.provider_id = p.id
                                  AND se.created_at >= current_date + current_hour * INTERVAL '1 hour'
                                  AND se.created_at < current_date + (current_hour + 1) * INTERVAL '1 hour'
    GROUP BY p.id
    ON CONFLICT (date, hour, provider_id) DO UPDATE
    SET total_calls = EXCLUDED.total_calls,
        validated_calls = EXCLUDED.validated_calls,
        failed_validations = EXCLUDED.failed_validations,
        diverted_calls = EXCLUDED.diverted_calls,
        security_events = EXCLUDED.security_events;
END;
$$ LANGUAGE plpgsql;

-- Create view for active validation monitoring
CREATE OR REPLACE VIEW active_validation_monitor AS
SELECT 
    cv.call_id,
    cv.origin_ani,
    cv.origin_dnis,
    cv.assigned_did,
    cv.current_state,
    CASE cv.current_state
        WHEN 1 THEN 'ORIGINATED'
        WHEN 2 THEN 'RINGING'
        WHEN 3 THEN 'ANSWERED'
        WHEN 4 THEN 'HUNG_UP'
        WHEN 5 THEN 'FAILED'
        WHEN 6 THEN 'DIVERTED'
    END as state_name,
    cv.validation_status,
    po.name as origin_provider,
    pi.name as intermediate_provider,
    pf.name as final_provider,
    cv.origin_validated,
    cv.destination_validated,
    cv.route_validated,
    cv.created_at,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - cv.created_at)) as duration_seconds
FROM call_validations cv
LEFT JOIN providers po ON cv.origin_server_id = po.id
LEFT JOIN providers pi ON cv.intermediate_server_id = pi.id
LEFT JOIN providers pf ON cv.final_server_id = pf.id
WHERE cv.validation_status = 'active'
ORDER BY cv.created_at DESC;

-- Create view for security event summary
CREATE OR REPLACE VIEW security_event_summary AS
SELECT 
    DATE_TRUNC('hour', created_at) as hour,
    event_type,
    severity,
    COUNT(*) as event_count,
    COUNT(DISTINCT call_id) as affected_calls,
    COUNT(DISTINCT source_ip) as unique_sources
FROM security_events
WHERE created_at > CURRENT_TIMESTAMP - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', created_at), event_type, severity
ORDER BY hour DESC, event_count DESC;

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO router;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO router;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO router;

-- Create scheduled job to clean up old records (requires pg_cron extension)
-- Uncomment if pg_cron is installed:
-- SELECT cron.schedule('cleanup-validations', '0 2 * * *', 
--     'DELETE FROM call_validations WHERE created_at < CURRENT_TIMESTAMP - INTERVAL ''7 days'';');
-- SELECT cron.schedule('cleanup-security-events', '0 3 * * *',
--     'DELETE FROM security_events WHERE created_at < CURRENT_TIMESTAMP - INTERVAL ''30 days'';');
-- SELECT cron.schedule('log-stats', '0 * * * *',
--     'SELECT log_validation_stats();');

COMMIT;
