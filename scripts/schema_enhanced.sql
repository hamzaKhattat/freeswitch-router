-- Providers table with UUID support
CREATE TABLE IF NOT EXISTS providers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL UNIQUE,
    host TEXT NOT NULL,
    port INTEGER DEFAULT 5060,
    username TEXT,
    password TEXT,
    transport TEXT DEFAULT 'udp',
    register INTEGER DEFAULT 0,
    proxy TEXT,
    expire_seconds INTEGER DEFAULT 3600,
    retry_seconds INTEGER DEFAULT 30,
    ping INTEGER DEFAULT 30,
    context TEXT DEFAULT 'router',
    profile TEXT DEFAULT 'router',
    capacity INTEGER DEFAULT 100,
    current_calls INTEGER DEFAULT 0,
    active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Routes table
CREATE TABLE IF NOT EXISTS routes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern TEXT NOT NULL,
    provider_id INTEGER NOT NULL,
    priority INTEGER DEFAULT 100,
    description TEXT,
    active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- DIDs table
CREATE TABLE IF NOT EXISTS dids (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    did_number TEXT NOT NULL UNIQUE,
    provider_id INTEGER NOT NULL,
    active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- Calls table for logging
CREATE TABLE IF NOT EXISTS calls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid TEXT NOT NULL,
    ani TEXT,
    dnis TEXT,
    provider TEXT,
    status TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    answered_at TIMESTAMP,
    ended_at TIMESTAMP,
    duration INTEGER DEFAULT 0,
    sip_response_code INTEGER,
    direction TEXT
);

-- Active calls for SIP server
CREATE TABLE IF NOT EXISTS active_calls (
    call_id TEXT PRIMARY KEY,
    src_ip TEXT,
    src_port INTEGER,
    dst_ip TEXT,
    dst_port INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_routes_pattern ON routes(pattern);
CREATE INDEX IF NOT EXISTS idx_routes_priority ON routes(priority);
CREATE INDEX IF NOT EXISTS idx_calls_uuid ON calls(uuid);
CREATE INDEX IF NOT EXISTS idx_calls_created ON calls(created_at);
CREATE INDEX IF NOT EXISTS idx_providers_uuid ON providers(uuid);
