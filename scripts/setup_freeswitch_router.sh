#!/bin/bash

# Setup script for FreeSWITCH Router (FS2)

echo "Setting up FreeSWITCH Router (FS2)..."

# Create directories
mkdir -p /usr/local/freeswitch/conf/sip_profiles/gateways
mkdir -p /usr/local/freeswitch/scripts
mkdir -p /usr/local/freeswitch/conf/dialplan
mkdir -p /var/lib/freeswitch/recordings
mkdir -p logs

# Copy configuration files
cp configs/freeswitch/fs2_sip_profile.xml /usr/local/freeswitch/conf/sip_profiles/
cp configs/freeswitch/fs2_dialplan.xml /usr/local/freeswitch/conf/dialplan/
cp scripts/freeswitch/router_handler.lua /usr/local/freeswitch/scripts/
cp scripts/freeswitch/router_return_handler.lua /usr/local/freeswitch/scripts/

# Create database
sqlite3 router_fs2.db < scripts/schema_enhanced.sql

# Build the router
make clean
make

# Start services
echo "Starting FreeSWITCH Router services..."
./freeswitch_router -c configs/freeswitch_s2.json

echo "FreeSWITCH Router setup complete!"
