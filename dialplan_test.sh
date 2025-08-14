#!/bin/bash
# dialplan_test.sh - Test and verify dialplan generation
# This script tests the dialplan generation and validates the configuration

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Check if running as root
check_permissions() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run as root (required for FreeSWITCH config access)"
        exit 1
    fi
}

# Test database connectivity
test_database() {
    print_header "Testing Database Connectivity"
    
    # Test PostgreSQL connection
    if psql -h localhost -U router -d router_db -c "SELECT 1;" >/dev/null 2>&1; then
        print_success "Database connection successful"
    else
        print_error "Database connection failed"
        print_info "Make sure PostgreSQL is running and router database exists"
        return 1
    fi
    
    # Check required tables
    local tables=("providers" "routes" "dids" "calls")
    for table in "${tables[@]}"; do
        if psql -h localhost -U router -d router_db -c "SELECT 1 FROM $table LIMIT 1;" >/dev/null 2>&1; then
            print_success "Table '$table' exists and accessible"
        else
            print_error "Table '$table' missing or inaccessible"
            return 1
        fi
    done
}

# Test router CLI functionality
test_router_cli() {
    print_header "Testing Router CLI"
    
    cd /root/freeswitch-router
    
    # Test provider list
    print_info "Testing provider list..."
    if ./router provider list >/dev/null 2>&1; then
        print_success "Provider list command works"
    else
        print_error "Provider list command failed"
    fi
    
    # Test route list
    print_info "Testing route list..."
    if ./router route list >/dev/null 2>&1; then
        print_success "Route list command works"
    else
        print_error "Route list command failed"
    fi
    
    # Test DID list
    print_info "Testing DID list..."
    if ./router did list >/dev/null 2>&1; then
        print_success "DID list command works"
    else
        print_error "DID list command failed"
    fi
}

# Add test providers if they don't exist
setup_test_data() {
    print_header "Setting Up Test Data"
    
    cd /root/freeswitch-router
    
    # Add test providers
    print_info "Adding test providers..."
    
    # S1 - Origin
    ./router provider add s1 10.0.0.1:5060 origin 1000 ip 10.0.0.1 2>/dev/null || true
    
    # S3 - Intermediate
    ./router provider add s3 10.0.0.3:5060 intermediate 1000 ip 10.0.0.3 2>/dev/null || true
    
    # S4 - Final
    ./router provider add s4 10.0.0.4:5060 final 1000 ip 10.0.0.4 2>/dev/null || true
    
    print_success "Test providers added"
    
    # Add test route
    print_info "Adding test route..."
    ./router route add us_route s1 s3 s4 '1[2-9][0-9]{9}' 100 2>/dev/null || true
    print_success "Test route added"
    
    # Add test DIDs
    print_info "Adding test DIDs..."
    for i in {1000..1009}; do
        ./router did add "1800555${i}" US 2>/dev/null || true
    done
    print_success "Test DIDs added"
}

# Test dialplan generation
test_dialplan_generation() {
    print_header "Testing Dialplan Generation"
    
    cd /root/freeswitch-router
    
    # Trigger dialplan regeneration
    print_info "Regenerating dialplans..."
    if ./router route reload; then
        print_success "Dialplan regeneration successful"
    else
        print_error "Dialplan regeneration failed"
        return 1
    fi
    
    # Check if dialplan files exist
    local dialplan_dir="/etc/freeswitch/conf/dialplan"
    
    if [ -f "$dialplan_dir/public.xml" ]; then
        print_success "Main public dialplan exists"
    else
        print_error "Main public dialplan missing"
        return 1
    fi
    
    # Check for route-specific dialplans
    local route_files=$(find "$dialplan_dir/public" -name "route_*.xml" 2>/dev/null | wc -l)
    if [ "$route_files" -gt 0 ]; then
        print_success "Found $route_files route-specific dialplan files"
    else
        print_error "No route-specific dialplan files found"
        return 1
    fi
    
    # Check Lua script
    if [ -f "/etc/freeswitch/scripts/route_handler.lua" ]; then
        print_success "Route handler Lua script exists"
    else
        print_error "Route handler Lua script missing"
        return 1
    fi
}

# Validate XML syntax
validate_xml_syntax() {
    print_header "Validating XML Syntax"
    
    local config_dir="/etc/freeswitch/conf"
    local errors=0
    
    # Check main config
    if xmllint --noout "$config_dir/freeswitch.xml" 2>/dev/null; then
        print_success "freeswitch.xml syntax valid"
    else
        print_error "freeswitch.xml syntax invalid"
        errors=$((errors + 1))
    fi
    
    # Check SIP profiles
    for profile in external internal; do
        if [ -f "$config_dir/sip_profiles/$profile.xml" ]; then
            if xmllint --noout "$config_dir/sip_profiles/$profile.xml" 2>/dev/null; then
                print_success "$profile.xml syntax valid"
            else
                print_error "$profile.xml syntax invalid"
                errors=$((errors + 1))
            fi
        fi
    done
    
    # Check dialplan files
    if [ -f "$config_dir/dialplan/public.xml" ]; then
        if xmllint --noout "$config_dir/dialplan/public.xml" 2>/dev/null; then
            print_success "public.xml syntax valid"
        else
            print_error "public.xml syntax invalid"
            errors=$((errors + 1))
        fi
    fi
    
    # Check individual route dialplans
    for route_file in "$config_dir/dialplan/public/route_"*.xml; do
        if [ -f "$route_file" ]; then
            if xmllint --noout "$route_file" 2>/dev/null; then
                print_success "$(basename "$route_file") syntax valid"
            else
                print_error "$(basename "$route_file") syntax invalid"
                errors=$((errors + 1))
            fi
        fi
    done
    
    if [ $errors -eq 0 ]; then
        print_success "All XML files have valid syntax"
    else
        print_error "Found $errors XML syntax errors"
        return 1
    fi
}

# Test FreeSWITCH configuration loading
test_freeswitch_config() {
    print_header "Testing FreeSWITCH Configuration"
    
    # Test XML syntax with FreeSWITCH
    print_info "Testing FreeSWITCH XML loading..."
    if fs_cli -x "reloadxml" 2>/dev/null | grep -q "OK"; then
        print_success "FreeSWITCH XML reload successful"
    else
        print_error "FreeSWITCH XML reload failed"
        return 1
    fi
    
    # Check Sofia profiles
    print_info "Checking Sofia profiles..."
    local sofia_status=$(fs_cli -x "sofia status" 2>/dev/null)
    
    if echo "$sofia_status" | grep -q "external"; then
        print_success "External profile loaded"
    else
        print_error "External profile not loaded"
    fi
    
    if echo "$sofia_status" | grep -q "internal"; then
        print_success "Internal profile loaded"
    else
        print_error "Internal profile not loaded"
    fi
    
    # Check gateways
    print_info "Checking gateways..."
    local gateway_status=$(fs_cli -x "sofia status gateway" 2>/dev/null)
    
    if echo "$gateway_status" | grep -q "gateway"; then
        print_success "Gateways configured"
        echo "$gateway_status" | grep -E "(UP|DOWN|TRYING)" | while read line; do
            print_info "Gateway: $line"
        done
    else
        print_info "No gateways found (this is OK if no providers are added yet)"
    fi
}

# Test dialplan matching
test_dialplan_matching() {
    print_header "Testing Dialplan Matching"
    
    # Test pattern matching with specific numbers
    local test_numbers=("12125551234" "18005551234" "15551234567")
    
    for number in "${test_numbers[@]}"; do
        print_info "Testing dialplan lookup for $number..."
        
        # Use FreeSWITCH to test dialplan
        local result=$(fs_cli -x "show dialplan public $number" 2>/dev/null)
        
        if echo "$result" | grep -q "extension"; then
            print_success "Dialplan match found for $number"
            # Show which extension matched
            echo "$result" | grep "extension" | head -1 | sed 's/^/    /'
        else
            print_info "No dialplan match for $number (may be expected)"
        fi
    done
}

# Show configuration summary
show_config_summary() {
    print_header "Configuration Summary"
    
    cd /root/freeswitch-router
    
    # Show providers
    print_info "Providers:"
    ./router provider list | grep -E "(Name|----)" -A 100 || true
    
    echo ""
    
    # Show routes
    print_info "Routes:"
    ./router route list | grep -E "(Name|----)" -A 100 || true
    
    echo ""
    
    # Show DIDs
    print_info "DID Pool (first 10):"
    ./router did list | head -15 || true
    
    echo ""
    
    # Show file structure
    print_info "Generated files:"
    find /etc/freeswitch/conf -name "*.xml" -newer /tmp -type f 2>/dev/null | sort | sed 's/^/  /' || true
    
    if [ -f "/etc/freeswitch/scripts/route_handler.lua" ]; then
        print_info "Lua script: /etc/freeswitch/scripts/route_handler.lua ($(stat -c%s /etc/freeswitch/scripts/route_handler.lua) bytes)"
    fi
}

# Main execution
main() {
    echo -e "${BLUE}FreeSWITCH Router Dialplan Test Suite${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo ""
    
    # Check prerequisites
    check_permissions
    
    # Run tests
    if test_database; then
        print_success "Database tests passed"
    else
        print_error "Database tests failed"
        exit 1
    fi
    
    echo ""
    
    if test_router_cli; then
        print_success "Router CLI tests passed"
    else
        print_error "Router CLI tests failed"
        exit 1
    fi
    
    echo ""
    
    # Setup test data
    setup_test_data
    
    echo ""
    
    if test_dialplan_generation; then
        print_success "Dialplan generation tests passed"
    else
        print_error "Dialplan generation tests failed"
        exit 1
    fi
    
    echo ""
    
    if validate_xml_syntax; then
        print_success "XML syntax validation passed"
    else
        print_error "XML syntax validation failed"
        exit 1
    fi
    
    echo ""
    
    if test_freeswitch_config; then
        print_success "FreeSWITCH configuration tests passed"
    else
        print_error "FreeSWITCH configuration tests failed"
        exit 1
    fi
    
    echo ""
    
    test_dialplan_matching
    
    echo ""
    
    show_config_summary
    
    echo ""
    print_success "All tests completed successfully!"
    print_info "You can now test calls using: ./real_call_test.sh single 15551234567 12125551234 30"
}

# Run main function
main "$@"
