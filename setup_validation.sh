#!/bin/bash
# setup_validation.sh - Setup validation system with PostgreSQL

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================="
echo "PostgreSQL Validation Setup"
echo "=================================="
echo ""

# PostgreSQL connection details
DB_NAME="router_db"
DB_USER="router"
DB_PASS="router123"
DB_HOST="localhost"

# Export for psql commands
export PGPASSWORD="$DB_PASS"

echo "Step 1: Testing PostgreSQL connection..."
echo "-----------------------------------------"

if PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 'Connected' as status;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PostgreSQL connection successful${NC}"
else
    echo -e "${RED}✗ PostgreSQL connection failed${NC}"
    echo "Please ensure PostgreSQL is running and credentials are correct"
    exit 1
fi

echo ""
echo "Step 2: Applying validation schema..."
echo "--------------------------------------"

# Apply the schema
PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" < schema_validation_pg.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema applied successfully${NC}"
else
    echo -e "${RED}✗ Schema application failed${NC}"
    exit 1
fi

echo ""
echo "Step 3: Verifying tables..."
echo "----------------------------"

RESULT=$(PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -t -c "
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('call_states', 'security_events', 'validation_checkpoints', 'call_validation_rules', 'call_validation_history');
")

if [ $(echo $RESULT | tr -d ' ') -eq 5 ]; then
    echo -e "${GREEN}✓ All 5 validation tables created${NC}"
else
    echo -e "${YELLOW}⚠ Some tables may be missing${NC}"
fi

echo ""
echo "Step 4: Checking validation rules..."
echo "-------------------------------------"

RULES=$(PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM call_validation_rules;")
echo "Validation rules installed: $RULES"

echo ""
echo "Step 5: Updating provider UUIDs..."
echo "-----------------------------------"

PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
SELECT name, uuid, config_file_path 
FROM providers 
ORDER BY role, name;
"

echo ""
echo "Step 6: Updating route information..."
echo "--------------------------------------"

PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
SELECT id, name, uuid, dialplan_file_path 
FROM routes 
ORDER BY priority DESC, name;
"

echo ""
echo "Step 7: Creating PostgreSQL authentication helper..."
echo "----------------------------------------------------"

# Create a .pgpass file for easier authentication
cat > ~/.pgpass << EOF
$DB_HOST:5432:$DB_NAME:$DB_USER:$DB_PASS
