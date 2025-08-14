-- FreeSWITCH Router Database Schema
-- Enhanced for Call Center Operations with UUID tracking

-- Providers table with UUID and full configuration
CREATE TABLE IF NOT EXISTS providers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    name VARCHAR(255) UNIQUE NOT NULL,
    host VARCHAR(255) NOT NULL,
    port INTEGER DEFAULT 5060,
    username VARCHAR(128),
    password VARCHAR(128),
    auth_type VARCHAR(32) NOT NULL, -- 'ip', 'userpass', 'cert'
    auth_data TEXT, -- Stores auth info (IPs, user:pass, or cert path)
    transport VARCHAR(16) DEFAULT 'udp',
    capacity INTEGER DEFAULT 100,
    current_calls INTEGER DEFAULT 0,
    max_cps INTEGER DEFAULT 10, -- Max calls per second
    active BOOLEAN DEFAULT 1,
    priority INTEGER DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Routes for S1→S2→S3→S2→S4 flow
CREATE TABLE IF NOT EXISTS routes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(128) NOT NULL,
    inbound_provider VARCHAR(128),
    intermediate_provider VARCHAR(128),
    final_provider VARCHAR(128),
    pattern VARCHAR(256) NOT NULL,
    priority INTEGER DEFAULT 100,
    description TEXT,
    active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DID Pool Management (matching PDF requirements)
CREATE TABLE IF NOT EXISTS dids (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    did VARCHAR(50) UNIQUE NOT NULL,
    in_use BOOLEAN DEFAULT 0,
    country VARCHAR(50),
    destination VARCHAR(50), -- Current DNIS when in use
    allocated_to_call VARCHAR(256),
    provider_id INTEGER,
    active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- Call Detail Records for billing and analytics
CREATE TABLE IF NOT EXISTS cdr (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    call_uuid VARCHAR(256) UNIQUE NOT NULL,
    start_time TIMESTAMP NOT NULL,
    answer_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INTEGER DEFAULT 0,
    billsec INTEGER DEFAULT 0,
    ani_original VARCHAR(50),
    dnis_original VARCHAR(50),
    ani_modified VARCHAR(50),
    did_used VARCHAR(50),
    origin_server VARCHAR(128),
    intermediate_server VARCHAR(128),
    final_server VARCHAR(128),
    hangup_cause VARCHAR(50),
    sip_response_code INTEGER,
    direction VARCHAR(32), -- inbound, outbound, internal
    cost DECIMAL(10,4) DEFAULT 0,
    price DECIMAL(10,4) DEFAULT 0
);

-- Active calls tracking
CREATE TABLE IF NOT EXISTS active_calls (
    call_uuid VARCHAR(256) PRIMARY KEY,
    ani_original VARCHAR(50),
    dnis_original VARCHAR(50),
    ani_current VARCHAR(50),
    did_assigned VARCHAR(50),
    current_stage VARCHAR(32), -- origin, intermediate, return, final
    origin_server VARCHAR(128),
    intermediate_server VARCHAR(128),
    final_server VARCHAR(128),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Call statistics for monitoring
CREATE TABLE IF NOT EXISTS call_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_id INTEGER,
    date DATE NOT NULL,
    hour INTEGER NOT NULL,
    total_calls INTEGER DEFAULT 0,
    successful_calls INTEGER DEFAULT 0,
    failed_calls INTEGER DEFAULT 0,
    asr REAL DEFAULT 0, -- Answer Seizure Ratio
    acd REAL DEFAULT 0, -- Average Call Duration
    concurrent_calls_peak INTEGER DEFAULT 0,
    FOREIGN KEY (provider_id) REFERENCES providers(id),
    UNIQUE(provider_id, date, hour)
);

-- Configuration tracking
CREATE TABLE IF NOT EXISTS config_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_uuid VARCHAR(36) NOT NULL,
    file_type VARCHAR(50), -- gateway, dialplan, acl, lua
    file_path TEXT NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_uuid) REFERENCES providers(uuid)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_providers_uuid ON providers(uuid);
CREATE INDEX IF NOT EXISTS idx_providers_name ON providers(name);
CREATE INDEX IF NOT EXISTS idx_routes_pattern ON routes(pattern);
CREATE INDEX IF NOT EXISTS idx_dids_in_use ON dids(in_use);
CREATE INDEX IF NOT EXISTS idx_dids_did ON dids(did);
CREATE INDEX IF NOT EXISTS idx_cdr_start_time ON cdr(start_time);
CREATE INDEX IF NOT EXISTS idx_cdr_call_uuid ON cdr(call_uuid);
CREATE INDEX IF NOT EXISTS idx_active_calls_stage ON active_calls(current_stage);
CREATE INDEX IF NOT EXISTS idx_call_stats_date ON call_stats(date, hour);
