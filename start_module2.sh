#!/bin/bash
# Module 2 Startup Script

echo "Starting Module 2 Router..."

# Set environment variables
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=router_db
export DB_USER=router
export DB_PASS=router123

# Generate dynamic dialplan
if [ -f "./generate_dynamic_dialplan.sh" ]; then
    ./generate_dynamic_dialplan.sh
fi

# Start provider monitoring in background
if [ -f "./monitor_providers.sh" ]; then
    nohup ./monitor_providers.sh > logs/provider_monitor.log 2>&1 &
    echo $! > /var/run/provider_monitor.pid
    echo "✓ Provider monitoring started (PID: $!)"
fi

# Start the router
exec /usr/local/bin/fs-router
