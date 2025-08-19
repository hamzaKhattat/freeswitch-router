#!/bin/bash
# Generate FreeSWITCH dialplan dynamically from database

DB_CMD="PGPASSWORD=router123 psql -h localhost -U router -d router_db -t -A"

echo "Generating dynamic dialplan from database..."

# Get all active providers and their IPs
PROVIDERS=$($DB_CMD -c "SELECT id, name, host, role FROM providers WHERE active = true;")

# Generate dialplan XML
cat > /etc/freeswitch/dialplan/public/module2_dynamic.xml << XML
<?xml version="1.0" encoding="utf-8"?>
<include>
  <context name="public">
XML

# Process each provider
echo "$PROVIDERS" | while IFS='|' read -r id name host role; do
    if [ "$role" = "origin" ]; then
        cat >> /etc/freeswitch/dialplan/public/module2_dynamic.xml << XML
    <!-- Origin Provider: $name -->
    <extension name="module2_origin_${id}">
      <condition field="network_addr" expression="^${host}$" break="never">
        <action application="set" data="module2_stage=origin"/>
        <action application="set" data="source_provider_id=${id}"/>
        <action application="log" data="INFO Module 2: Origin call from ${name} (${host})"/>
      </condition>
      <condition field="destination_number" expression="^(\d+)$">
        <action application="lua" data="route_handler_module2_dynamic.lua origin ${id}"/>
      </condition>
    </extension>
    
XML
    elif [ "$role" = "intermediate" ]; then
        cat >> /etc/freeswitch/dialplan/public/module2_dynamic.xml << XML
    <!-- Intermediate Provider: $name -->
    <extension name="module2_return_${id}">
      <condition field="network_addr" expression="^${host}$" break="never">
        <action application="set" data="module2_stage=intermediate_return"/>
        <action application="set" data="source_provider_id=${id}"/>
        <action application="log" data="INFO Module 2: Return call from ${name} (${host})"/>
      </condition>
      <condition field="destination_number" expression="^(584\d+)$">
        <action application="lua" data="route_handler_module2_dynamic.lua intermediate_return ${id}"/>
      </condition>
    </extension>
    
XML
    fi
done

cat >> /etc/freeswitch/dialplan/public/module2_dynamic.xml << XML
  </context>
</include>
XML

echo "Dynamic dialplan generated successfully"
fs_cli -x "reloadxml"
