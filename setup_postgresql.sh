
#!/bin/bash
# setup_postgresql.sh - Complete PostgreSQL setup for FreeSWITCH Router

set -e

echo "FreeSWITCH Router PostgreSQL Setup"
echo "==================================="
echo ""

# Database configuration
DB_NAME="router_db"
DB_USER="router"
DB_PASS="router123"
DB_HOST="localhost"
DB_PORT="5432"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}Running as root, switching to postgres user for database operations${NC}"
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo -e "${YELLOW}PostgreSQL is not installed. Installing...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            sudo apt-get update
            sudo apt-get install -y postgresql postgresql-client postgresql-contrib
        elif [ -f /etc/redhat-release ]; then
            sudo yum install -y postgresql postgresql-server postgresql-contrib
            sudo postgresql-setup initdb
        fi
    fi
fi

# Check if PostgreSQL is running
if ! systemctl is-active --quiet postgresql; then
    echo -e "${YELLOW}Starting PostgreSQL...${NC}"
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sleep 3
fi

echo -e "${GREEN}✓ PostgreSQL is running${NC}"

# Create user and database
echo "Creating database and user..."

sudo -u postgres psql << EOF
-- Create user if not exists
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '$DB_USER') THEN
        CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';
    ELSE
        ALTER USER $DB_USER WITH PASSWORD '$DB_PASS';
    END IF;
END
\$\$;

-- Drop and recreate database for clean install
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME OWNER $DB_USER;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER DATABASE $DB_NAME OWNER TO $DB_USER;
EOF

echo -e "${GREEN}✓ Database and user created${NC}"

# Create extension as superuser
echo "Creating UUID extension..."
sudo -u postgres psql -d $DB_NAME << EOF
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Also create the built-in gen_random_uuid if available (PostgreSQL 13+)
CREATE EXTENSION IF NOT EXISTS pgcrypto;
EOF

echo -e "${GREEN}✓ Extensions created${NC}"

# Apply schema as router user
echo "Applying database schema..."

# Create temporary schema file with fixed UUID generation
cat > /tmp/router_schema.sql << 'SCHEMA_EOF'
-- Providers table with role column
CREATE TABLE IF NOT EXISTS providers (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(64) UNIQUE NOT NULL DEFAULT gen_random_uuid()::text,
    name VARCHAR(256) UNIQUE NOT NULL,
    host VARCHAR(256) NOT NULL,
    port INTEGER DEFAULT 5060,
    auth_type VARCHAR(32) DEFAULT 'ip',
    auth_data TEXT,
    transport VARCHAR(16) DEFAULT 'udp',
    capacity INTEGER DEFAULT 100,
    role VARCHAR(32) NOT NULL CHECK (role IN ('origin', 'intermediate', 'final', 'general')),
    current_calls INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Routes table
CREATE TABLE IF NOT EXISTS routes (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(64) UNIQUE NOT NULL DEFAULT gen_random_uuid()::text,
    name VARCHAR(256),
    pattern VARCHAR(256) NOT NULL,
    origin_provider_id INTEGER REFERENCES providers(id) ON DELETE CASCADE,
    intermediate_provider_id INTEGER REFERENCES providers(id) ON DELETE CASCADE,
    final_provider_id INTEGER REFERENCES providers(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 100,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DIDs table
CREATE TABLE IF NOT EXISTS dids (
    id SERIAL PRIMARY KEY,
    did VARCHAR(64) UNIQUE NOT NULL,
    country VARCHAR(32),
    provider_id INTEGER REFERENCES providers(id) ON DELETE SET NULL,
    in_use BOOLEAN DEFAULT false,
    destination VARCHAR(64),
    call_id VARCHAR(256),
    original_ani VARCHAR(64),
    allocated_at TIMESTAMP,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Calls table
CREATE TABLE IF NOT EXISTS calls (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(256) UNIQUE,
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

-- Call records table
CREATE TABLE IF NOT EXISTS call_records (
    id SERIAL PRIMARY KEY,
    call_id VARCHAR(256) UNIQUE,
    original_ani VARCHAR(64),
    original_dnis VARCHAR(64),
    assigned_did VARCHAR(64),
    origin_provider_id INTEGER REFERENCES providers(id),
    intermediate_provider_id INTEGER REFERENCES providers(id),
    final_provider_id INTEGER REFERENCES providers(id),
    status VARCHAR(32) DEFAULT 'initiated',
    stage INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP
);

-- Active calls table
CREATE TABLE IF NOT EXISTS active_calls (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(256) UNIQUE,
    ani VARCHAR(64),
    dnis VARCHAR(64),
    provider_id INTEGER REFERENCES providers(id),
    provider_name VARCHAR(128),
    status VARCHAR(32),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_providers_role ON providers(role);
CREATE INDEX IF NOT EXISTS idx_providers_active ON providers(active);
CREATE INDEX IF NOT EXISTS idx_providers_uuid ON providers(uuid);
CREATE INDEX IF NOT EXISTS idx_routes_active ON routes(active);
CREATE INDEX IF NOT EXISTS idx_dids_in_use ON dids(in_use);
CREATE INDEX IF NOT EXISTS idx_dids_active ON dids(active);
CREATE INDEX IF NOT EXISTS idx_calls_status ON calls(status);

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO router;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO router;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO router;
SCHEMA_EOF

PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME < /tmp/router_schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema applied successfully${NC}"
else
    echo -e "${RED}✗ Failed to apply schema${NC}"
    exit 1
fi

# Clean up
rm -f /tmp/router_schema.sql

# Test connection
echo ""
echo "Testing database connection..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database connection successful${NC}"
else
    echo -e "${RED}✗ Database connection failed${NC}"
    exit 1
fi

# Show table structure
echo ""
echo "Database tables created:"
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt"

echo ""
echo -e "${GREEN}Database setup complete!${NC}"
echo ""
echo "Connection details:"
echo "  Host:     $DB_HOST"
echo "  Port:     $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User:     $DB_USER"
echo "  Password: $DB_PASS"
echo ""
echo "Connection string:"
echo "  host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER password=$DB_PASS"
echo ""
echo "Environment variable (add to ~/.bashrc):"
echo "  export ROUTER_DB_CONNECTION=\"host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER password=$DB_PASS\""
echo ""
echo "Next steps:"
echo "  1. Export the connection string: export ROUTER_DB_CONNECTION=\"host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER password=$DB_PASS\""
echo "  2. Build the router: make clean all"
echo "  3. Initialize FreeSWITCH: ./router init-fs"
echo "  4. Add providers: ./router provider add s1 10.0.0.1:5060 origin 100 ip 10.0.0.1"
