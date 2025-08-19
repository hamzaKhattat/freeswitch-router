#!/bin/bash
echo "════════════════════════════════════════════════════════════"
echo "         Module 2 Testing"
echo "════════════════════════════════════════════════════════════"

# Test database functions
echo "Testing ANI/DNIS transformation..."
psql -U router -d router_db -c "SELECT * FROM apply_call_transformation('test_001', 2, '15551234567', '18005551234', 'forward');"

echo -e "\nTesting S1 origin validation..."
psql -U router -d router_db -c "SELECT validate_s1_origin('584148757547', '10.0.0.1');"

echo -e "\nChecking Module 2 flow view..."
psql -U router -d router_db -c "SELECT * FROM module2_call_flow LIMIT 5;"

echo "Test complete!"
