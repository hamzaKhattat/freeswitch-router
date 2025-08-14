#!/bin/bash
# test_freeswitch.sh - Test FreeSWITCH configuration and routing

echo "FreeSWITCH Router Testing Script"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if FreeSWITCH is running
check_freeswitch() {
    echo -e "${YELLOW}1. Checking FreeSWITCH status...${NC}"
    
    if pgrep -x "freeswitch" > /dev/null; then
        echo -e "${GREEN}✓ FreeSWITCH is running${NC}"
        
        # Get PID and memory usage
        PID=$(pgrep -x "freeswitch")
        MEM=$(ps aux | grep "freeswitch" | grep -v grep | awk '{print $6}')
        echo "  PID: $PID"
        echo "  Memory: ${MEM}KB"
    else
        echo -e "${RED}✗ FreeSWITCH is not running${NC}"
        echo "  Start with: systemctl start freeswitch"
        exit 1
    fi
    echo ""
}

# Test FreeSWITCH CLI connection
test_fs_cli() {
    echo -e "${YELLOW}2. Testing FreeSWITCH CLI connection...${NC}"
    
    if fs_cli -x "status" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ CLI connection successful${NC}"
        
        # Show version
        VERSION=$(fs_cli -x "version" 2>/dev/null | head -1)
        echo "  Version: $VERSION"
    else
        echo -e "${RED}✗ Cannot connect to FreeSWITCH CLI${NC}"
        echo "  Check event_socket configuration"
        exit 1
    fi
    echo ""
}

# Check loaded modules
check_modules() {
    echo -e "${YELLOW}3. Checking loaded modules...${NC}"
    
    REQUIRED_MODULES=("mod_sofia" "mod_dialplan_xml" "mod_lua" "mod_db" "mod_dptools")
    
    for module in "${REQUIRED_MODULES[@]}"; do
        if fs_cli -x "module_exists $module" 2>/dev/null | grep -q "true"; then
            echo -e "${GREEN}✓ $module loaded${NC}"
        else
            echo -e "${RED}✗ $module not loaded${NC}"
            echo "  Load with: fs_cli -x 'load $module'"
        fi
    done
    echo ""
}

# Check SIP profiles
check_sip_profiles() {
    echo -e "${YELLOW}4. Checking SIP profiles...${NC}"
    
    # Check external profile
    if fs_cli -x "sofia status profile external" 2>/dev/null | grep -q "RUNNING"; then
        echo -e "${GREEN}✓ External profile running${NC}"
        
        # Get port
        PORT=$(fs_cli -x "sofia status profile external" 2>/dev/null | grep "sip-port" | awk '{print $3}')
        echo "  Port: ${PORT:-5080}"
    else
        echo -e "${RED}✗ External profile not running${NC}"
    fi
    
    # Check internal profile
    if fs_cli -x "sofia status profile internal" 2>/dev/null | grep -q "RUNNING"; then
        echo -e "${GREEN}✓ Internal profile running${NC}"
        
        # Get port
        PORT=$(fs_cli -x "sofia status profile internal" 2>/dev/null | grep "sip-port" | awk '{print $3}')
        echo "  Port: ${PORT:-5060}"
    else
        echo -e "${RED}✗ Internal profile not running${NC}"
    fi
    echo ""
}

# Check gateways from database
check_gateways() {
    echo -e "${YELLOW}5. Checking gateways from database...${NC}"
    
    # Query database for providers
    PROVIDERS=$(sqlite3 /opt/freeswitch-router/router.db "SELECT uuid, name, role, host, port FROM providers WHERE active = 1;" 2>/dev/null)
    
    if [ -z "$PROVIDERS" ]; then
        echo -e "${YELLOW}No providers in database${NC}"
    else
        echo "$PROVIDERS" | while IFS='|' read -r uuid name role host port; do
            echo "Provider: $name (Role: $role)"
            
            # Check if gateway exists in FreeSWITCH
            if fs_cli -x "sofia status gateway $uuid" 2>/dev/null | grep -q "Profile"; then
                STATUS=$(fs_cli -x "sofia status gateway $uuid" 2>/dev/null | grep "Status" | awk '{print $2}')
                if [ "$STATUS" = "UP" ] || [ "$STATUS" = "REGED" ]; then
                    echo -e "  ${GREEN}✓ Gateway UP${NC}"
                else
                    echo -e "  ${YELLOW}⚠ Gateway status: $STATUS${NC}"
                fi
            else
                echo -e "  ${RED}✗ Gateway not found in FreeSWITCH${NC}"
                echo "    Config should be at: /usr/local/freeswitch/conf/sip_profiles/*/$$uuid.xml"
            fi
        done
    fi
    echo ""
}

# Check dialplan contexts
check_dialplan() {
    echo -e "${YELLOW}6. Checking dialplan contexts...${NC}"
    
    CONTEXTS=("default" "public" "from_origin" "from_intermediate")
    
    for context in "${CONTEXTS[@]}"; do
        if fs_cli -x "xml_locate dialplan $context" 2>/dev/null | grep -q "<context"; then
            echo -e "${GREEN}✓ Context '$context' exists${NC}"
        else
            echo -e "${RED}✗ Context '$context' not found${NC}"
        fi
    done
    echo ""
}

# Check Lua scripts
check_lua_scripts() {
    echo -e "${YELLOW}7. Checking Lua routing scripts...${NC}"
    
    SCRIPTS=("route_to_intermediate.lua" "route_to_final.lua")
    SCRIPT_DIR="/usr/local/freeswitch/scripts"
    
    for script in "${SCRIPTS[@]}"; do
        if [ -f "$SCRIPT_DIR/$script" ]; then
            echo -e "${GREEN}✓ $script exists${NC}"
            
            # Check if readable
            if [ -r "$SCRIPT_DIR/$script" ]; then
                echo "    Readable: Yes"
            else
                echo -e "    ${RED}Not readable by FreeSWITCH${NC}"
            fi
        else
            echo -e "${RED}✗ $script not found${NC}"
            echo "    Should be at: $SCRIPT_DIR/$script"
        fi
    done
    echo ""
}

# Check DID pool
check_did_pool() {
    echo -e "${YELLOW}8. Checking DID pool...${NC}"
    
    TOTAL=$(sqlite3 /opt/freeswitch-router/router.db "SELECT COUNT(*) FROM dids WHERE active = 1;" 2>/dev/null)
    AVAILABLE=$(sqlite3 /opt/freeswitch-router/router.db "SELECT COUNT(*) FROM dids WHERE active = 1 AND in_use = 0;" 2>/dev/null)
    
    if [ -n "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
        echo -e "${GREEN}✓ DID pool configured${NC}"
        echo "  Total DIDs: $TOTAL"
        echo "  Available: $AVAILABLE"
        echo "  In use: $((TOTAL - AVAILABLE))"
    else
        echo -e "${RED}✗ No DIDs in pool${NC}"
        echo "  Add DIDs with: ./router did add <number> <country>"
    fi
    echo ""
}

# Test SIP connectivity
test_sip_options() {
    echo -e "${YELLOW}9. Testing SIP OPTIONS...${NC}"
    
    # Send OPTIONS to localhost
    fs_cli -x "sofia global siptrace on" > /dev/null 2>&1
    
    if fs_cli -x "sofia profile internal ping 127.0.0.1" 2>/dev/null | grep -q "200"; then
        echo -e "${GREEN}✓ Local SIP stack responding${NC}"
    else
        echo -e "${YELLOW}⚠ Could not ping local SIP stack${NC}"
    fi
    
    # Test each gateway
    GATEWAYS=$(fs_cli -x "sofia status" 2>/dev/null | grep "gateway" | awk '{print $2}')
    
    for gw in $GATEWAYS; do
        echo "  Testing gateway: $gw"
        if fs_cli -x "sofia profile external ping $gw" 2>/dev/null | grep -q "200"; then
            echo -e "    ${GREEN}✓ Reachable${NC}"
        else
            echo -e "    ${RED}✗ Not reachable${NC}"
        fi
    done
    echo ""
}

# Show recent logs
show_logs() {
    echo -e "${YELLOW}10. Recent FreeSWITCH logs...${NC}"
    
    LOG_FILE="/usr/local/freeswitch/log/freeswitch.log"
    
    if [ -f "$LOG_FILE" ]; then
        echo "Last 10 error/warning lines:"
        tail -100 "$LOG_FILE" | grep -E "(ERROR|WARNING)" | tail -10
    else
        echo -e "${YELLOW}Log file not found at $LOG_FILE${NC}"
        
        # Try alternate location
        if [ -f "/var/log/freeswitch/freeswitch.log" ]; then
            tail -100 "/var/log/freeswitch/freeswitch.log" | grep -E "(ERROR|WARNING)" | tail -10
        fi
    fi
    echo ""
}

# Generate test call
test_call() {
    echo -e "${YELLOW}11. Testing call routing...${NC}"
    
    # Check if we have origin and intermediate providers
    ORIGIN=$(sqlite3 /opt/freeswitch-router/router.db "SELECT uuid FROM providers WHERE role = 'origin' AND active = 1 LIMIT 1;" 2>/dev/null)
    INTERMEDIATE=$(sqlite3 /opt/freeswitch-router/router.db "SELECT uuid FROM providers WHERE role = 'intermediate' AND active = 1 LIMIT 1;" 2>/dev/null)
    
    if [ -n "$ORIGIN" ] && [ -n "$INTERMEDIATE" ]; then
        echo "Origin provider: $ORIGIN"
        echo "Intermediate provider: $INTERMEDIATE"
        
        # Enable SIP trace
        fs_cli -x "sofia global siptrace on" > /dev/null 2>&1
        
        # Originate test call
        echo "Originating test call..."
        fs_cli -x "originate sofia/gateway/$ORIGIN/18005551234 &echo" 2>&1 | head -5
    else
        echo -e "${YELLOW}Cannot test - missing required providers${NC}"
        echo "  Need at least one 'origin' and one 'intermediate' provider"
    fi
    echo ""
}

# Main execution
main() {
    check_freeswitch
    test_fs_cli
    check_modules
    check_sip_profiles
    check_gateways
    check_dialplan
    check_lua_scripts
    check_did_pool
    test_sip_options
    show_logs
    
    echo -e "${YELLOW}Summary:${NC}"
    echo "========="
    
    # Provide recommendations
    if [ -f "/usr/local/freeswitch/conf/freeswitch.xml" ]; then
        echo -e "${GREEN}✓ FreeSWITCH configuration exists${NC}"
    else
        echo -e "${RED}✗ FreeSWITCH configuration missing${NC}"
        echo "  Run: ./router init-fs"
    fi
    
    echo ""
    echo "To monitor SIP traffic in real-time:"
    echo "  fs_cli -x 'sofia global siptrace on'"
    echo "  tcpdump -i any -n port 5060 or port 5080 -s 0 -w sip.pcap"
    echo ""
    echo "To reload configuration:"
    echo "  fs_cli -x 'reloadxml'"
    echo "  fs_cli -x 'reload mod_sofia'"
}

# Run main function
main

================================================================================

# Fix procedure to apply:

1. Update database schema:
   sqlite3 /opt/freeswitch-router/router.db < schema_update.sql

2. Initialize FreeSWITCH configuration:
   ./router init-fs

3. Add providers with roles:
   # Add S1 (origin)
   ./router provider add s1 10.0.0.1:5060 origin 100 ip 10.0.0.1
   
   # Add S3 (intermediate)
   ./router provider add s3 10.0.0.3:5060 intermediate 100 ip 10.0.0.3
   
   # Add S4 (final)
   ./router provider add s4 10.0.0.4:5060 final 100 ip 10.0.0.4

4. Add DIDs to pool:
   ./router did add 18005551234 US
   ./router did add 18005551235 US
   ./router did add 18005551236 US

5. Reload FreeSWITCH:
   fs_cli -x 'reloadxml'
   fs_cli -x 'reload mod_sofia'

6. Enable SIP trace for debugging:
   fs_cli -x 'sofia global siptrace on'
   fs_cli -x 'sofia loglevel all 9'

7. Test with the script:
   chmod +x test_freeswitch.sh
   ./test_freeswitch.sh
