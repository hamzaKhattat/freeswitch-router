#!/bin/bash

echo "=== FreeSWITCH Router Three-Stage Routing Demo ==="
echo "Flow: S1 → S2 → S3 → S2 → S4"
echo ""

# Clean start
./router provider delete s1_inbound 2>/dev/null || true
./router provider delete s3_intermediate 2>/dev/null || true
./router provider delete s4_final 2>/dev/null || true

# Add providers for each stage
echo "1. Adding providers..."
./router provider add s1_inbound "10.0.0.1:5060" 100 ip "10.0.0.1"
./router provider add s3_intermediate "10.0.0.3:5060" 200 ip "10.0.0.3"
./router provider add s4_final "10.0.0.4:5060" 100 ip "10.0.0.4"

# Add a three-stage route
echo ""
echo "2. Adding three-stage route..."
./router route add "us_calls" "s1_inbound" "s3_intermediate" "s4_final" "1[2-9][0-9]{9}" 100

# Show the route
echo ""
echo "3. Route details:"
./router route show us_calls

# List all routes
echo ""
echo "4. All routes:"
./router route list

# Simulate call flow
echo ""
echo "5. Call flow simulation:"
echo "   - Call arrives at S2 from S1 (inbound)"
echo "   - S2 routes to S3 (intermediate)"
echo "   - S3 processes and returns to S2"
echo "   - S2 routes to S4 (final destination)"

echo ""
echo "Demo complete!"
