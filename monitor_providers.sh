#!/bin/bash
# Dynamic provider health monitoring

DB_CMD="PGPASSWORD=router123 psql -h localhost -U router -d router_db -t -A"

monitor_provider() {
    local provider_id=$1
    local host=$2
    local port=$3
    
    # Check provider health via SIP OPTIONS
    start_time=$(date +%s%N)
    
    # Send OPTIONS request (simplified - in production use proper SIP tool)
    timeout 2 nc -zv $host $port >/dev/null 2>&1
    result=$?
    
    end_time=$(date +%s%N)
    response_time=$((($end_time - $start_time) / 1000000)) # Convert to ms
    
    if [ $result -eq 0 ]; then
        status="healthy"
    else
        status="unhealthy"
    fi
    
    # Record health check
    $DB_CMD -c "INSERT INTO provider_health (provider_id, response_time_ms, status) 
                VALUES ($provider_id, $response_time, '$status');"
    
    # Update provider health status
    $DB_CMD -c "UPDATE providers SET 
                last_health_check = CURRENT_TIMESTAMP,
                health_status = '$status'
                WHERE id = $provider_id;"
}

# Main monitoring loop
while true; do
    # Get all active providers
    PROVIDERS=$($DB_CMD -c "SELECT id, host, port FROM providers WHERE active = true;")
    
    echo "$PROVIDERS" | while IFS='|' read -r id host port; do
        monitor_provider $id $host $port &
    done
    
    wait
    sleep 30
done
