#!/bin/bash

# FreeSWITCH Router Database Setup Script
# This script sets up the PostgreSQL database with the correct schema

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-router_db}"
DB_USER="${DB_USER:-router}"
DB_PASS="${DB_PASS:-router123}"

echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  FreeSWITCH Router Database Setup Script  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo

# Function to check if PostgreSQL is installed
check_postgresql() {
    if ! command -v psql &> /dev/null; then
        echo -e "${RED}PostgreSQL client not found. Please install PostgreSQL.${NC}"
        echo "Ubuntu/Debian: sudo apt-get install postgresql postgresql-client"
        echo "CentOS/RHEL: sudo yum install postgresql postgresql-server"
        exit 1
    fi
}

# Function to check if we can connect to PostgreSQL
check_connection() {
    echo -e "${YELLOW}Checking PostgreSQL connection...${NC}"
    if PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c '\q' 2>/dev/null; then
        echo -e "${GREEN}✓ Connected to PostgreSQL${NC}"
        return 0
    else
        echo -e "${RED}Cannot connect to PostgreSQL${NC}"
        return 1
    fi
}

# Function to create database if it doesn't exist
create_database() {
    echo -e "${YELLOW}Creating database '$DB_NAME' if it doesn't exist...${NC}"
    
    PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres <<EOF
SELECT 'CREATE DATABASE $DB_NAME'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME');
\gexec
EOF
    
    echo -e "${GREEN}✓ Database ready${NC}"
}

# Function to apply schema
apply_schema() {
    echo -e "${YELLOW}Applying database schema...${NC}"
    
    if [ ! -f "scripts/schema_pg.sql" ]; then
        echo -e "${RED}Schema file not found: scripts/schema_pg.sql${NC}"
        echo "Make sure you're running this script from the project root directory"
        exit 1
    fi
    
    PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME < scripts/schema_pg.sql
    
    echo -e "${GREEN}✓ Schema applied successfully${NC}"
}

# Function to verify installation
verify_installation() {
    echo -e "${YELLOW}Verifying installation...${NC}"
    
    RESULT=$(PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT * FROM system_status;")
    
    echo -e "${GREEN}System Status:${NC}"
    echo "$RESULT"
    
    echo
    echo -e "${GREEN}✓ Database setup complete!${NC}"
}

# Function to show connection string
show_connection_info() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Database Connection Information:${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo "Host: $DB_HOST"
    echo "Port: $DB_PORT"
    echo "Database: $DB_NAME"
    echo "Username: $DB_USER"
    echo "Password: $DB_PASS"
    echo
    echo "Connection string for router:"
    echo "postgresql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME"
    echo
    echo "Export for environment:"
    echo "export ROUTER_DB_CONNECTION=\"host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER password=$DB_PASS\""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
}

# Main execution
main() {
    # Check for custom parameters
    while [[ $# -gt 0 ]]; do
        case $1 in
            --host)
                DB_HOST="$2"
                shift 2
                ;;
            --port)
                DB_PORT="$2"
                shift 2
                ;;
            --database)
                DB_NAME="$2"
                shift 2
                ;;
            --user)
                DB_USER="$2"
                shift 2
                ;;
            --password)
                DB_PASS="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --host HOST       Database host (default: localhost)"
                echo "  --port PORT       Database port (default: 5432)"
                echo "  --database NAME   Database name (default: router_db)"
                echo "  --user USER       Database user (default: router)"
                echo "  --password PASS   Database password (default: router123)"
                echo "  --help           Show this help message"
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Run setup steps
    check_postgresql
    
    if ! check_connection; then
        echo
        echo -e "${YELLOW}Cannot connect to PostgreSQL. Trying with postgres user...${NC}"
        echo "You may need to create the user and grant permissions first."
        echo
        echo "Run these commands as postgres user:"
        echo "  sudo -u postgres psql"
        echo "  CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
        echo "  CREATE DATABASE $DB_NAME OWNER $DB_USER;"
        echo "  GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
        echo "  \q"
        echo
        read -p "Have you created the user and database? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        
        if ! check_connection; then
            echo -e "${RED}Still cannot connect. Please check your PostgreSQL setup.${NC}"
            exit 1
        fi
    fi
    
    create_database
    apply_schema
    verify_installation
    show_connection_info
    
    echo
    echo -e "${GREEN}You can now run the router with:${NC}"
    echo "  export ROUTER_DB_CONNECTION=\"host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER password=$DB_PASS\""
    echo "  ./router"
}

# Run main function
main "$@"
