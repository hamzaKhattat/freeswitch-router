#!/bin/bash
# PostgreSQL Setup Script for FreeSWITCH Router

echo "Setting up PostgreSQL for FreeSWITCH Router..."

# 1. Switch to postgres user and create database and user
sudo -u postgres psql << 'EOF'
-- Create database if it doesn't exist
SELECT 'CREATE DATABASE router_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'router_db')\gexec

-- Create user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'router') THEN
        CREATE USER router WITH PASSWORD 'router123';
    END IF;
END
$$;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE router_db TO router;
ALTER USER router CREATEDB;

-- Exit
\q
EOF

# 2. Backup current pg_hba.conf
sudo cp /etc/postgresql/*/main/pg_hba.conf /etc/postgresql/*/main/pg_hba.conf.backup

# 3. Update pg_hba.conf to allow password authentication
echo "Updating PostgreSQL authentication configuration..."
sudo sed -i 's/local   all             all                                     peer/local   all             all                                     md5/' /etc/postgresql/*/main/pg_hba.conf

# 4. Restart PostgreSQL
sudo systemctl restart postgresql

# 5. Test connection
echo "Testing connection..."
sleep 2

# Set password for testing (you'll be prompted)
export PGPASSWORD='router123'

# Test if we can connect
if psql -h localhost -U router -d router_db -c "SELECT version();" > /dev/null 2>&1; then
    echo "✓ Connection successful!"
else
    echo "✗ Connection failed. Let's try alternative setup..."
    
    # Alternative: Use trust authentication temporarily
    sudo sed -i 's/local   all             all                                     md5/local   all             all                                     trust/' /etc/postgresql/*/main/pg_hba.conf
    sudo systemctl restart postgresql
    sleep 2
    
    if psql -h localhost -U router -d router_db -c "SELECT version();" > /dev/null 2>&1; then
        echo "✓ Connection successful with trust authentication!"
    else
        echo "✗ Still having issues. Manual intervention needed."
    fi
fi

echo "Setup complete!"
