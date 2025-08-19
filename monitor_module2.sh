#!/bin/bash
# Module 2 Real-time Monitoring Dashboard

DB_CMD="PGPASSWORD=router123 psql -h localhost -U router -d router_db -t -A"

while true; do
    clear
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║            Module 2 Real-time Monitoring Dashboard            ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    
    # DID Pool Status
    echo "📊 DID Pool Status:"
    TOTAL=$($DB_CMD -c "SELECT COUNT(*) FROM dids WHERE active = true;")
    AVAILABLE=$($DB_CMD -c "SELECT COUNT(*) FROM dids WHERE active = true AND in_use = false;")
    IN_USE=$($DB_CMD -c "SELECT COUNT(*) FROM dids WHERE active = true AND in_use = true;")
    
    echo "   Total: $TOTAL | Available: $AVAILABLE | In Use: $IN_USE"
    echo ""
    
    # Active Calls
    echo "📞 Active Calls (S1 Origin):"
    $DB_CMD -c "SELECT call_id, s1_ip, did_assigned, status FROM s1_origin_calls WHERE status = 'active' ORDER BY initiated_at DESC LIMIT 5;" | column -t -s '|'
    echo ""
    
    # Recent Transformations
    echo "🔄 Recent Transformations:"
    $DB_CMD -c "SELECT call_id, stage, transformation_type, created_at FROM call_transformations ORDER BY created_at DESC LIMIT 5;" | column -t -s '|'
    echo ""
    
    # Security Events
    echo "🔒 Recent Security Events:"
    EVENTS=$($DB_CMD -c "SELECT COUNT(*) FROM security_events WHERE event_type = 'UNAUTHORIZED_RETURN' AND created_at > NOW() - INTERVAL '1 hour';")
    echo "   Unauthorized returns (last hour): $EVENTS"
    echo ""
    
    # Call Flow Statistics
    echo "📈 Call Flow Statistics:"
    $DB_CMD -c "SELECT stage_description, COUNT(*) as count FROM module2_call_flow GROUP BY stage_description ORDER BY stage_description;" | column -t -s '|'
    echo ""
    
    echo "Press Ctrl+C to exit | Refreshing in 5 seconds..."
    sleep 5
done
