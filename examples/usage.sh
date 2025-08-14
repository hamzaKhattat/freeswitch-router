#!/bin/bash

# FreeSWITCH Router Usage Examples

echo "=== FreeSWITCH Router Usage Examples ==="

# Add providers with different authentication types

# 1. IP-based authentication
echo "Adding provider with IP authentication..."
./router provider add provider1 "192.168.1.100:5060" 100 ip "192.168.1.100,192.168.1.101"

# 2. Username/password authentication  
echo "Adding provider with username/password..."
./router provider add provider2 "sip.provider2.com:5060" 200 userpass myusername mypassword

# 3. Certificate-based authentication
echo "Adding provider with certificate..."
./router provider add provider3 "secure.provider3.com:5061" 50 cert "/etc/freeswitch/certs/provider3"

# List all providers
echo -e "\nListing all providers:"
./router provider list

# Add routes
echo -e "\nAdding routes..."
./router route add "1[2-9][0-9]{9}" provider1 100 "US calls via provider1"
./router route add "44[0-9]+" provider2 90 "UK calls via provider2"
./router route add "default" provider3 200 "Default route"

# List routes
echo -e "\nListing routes:"
./router route list

# Add DIDs
echo -e "\nAdding DIDs..."
./router did add "12125551234" provider1
./router did add "442012345678" provider2

# List DIDs
echo -e "\nListing DIDs:"
./router did list

# Show statistics
echo -e "\nShowing statistics:"
./router stats

# Monitor status
echo -e "\nShowing monitor status:"
./router monitor show

# SIP server status
echo -e "\nSIP server status:"
./router sip status

# Start daemon mode
echo -e "\nTo start in daemon mode:"
echo "./router daemon"
