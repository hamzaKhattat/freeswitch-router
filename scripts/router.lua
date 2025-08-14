-- FreeSWITCH Router Lua Script
-- This script queries the router API to determine call routing

local destination = argv[1]
local caller_id = argv[2]
local provider_uuid = argv[3]

-- Configuration
local router_api_url = "http://localhost:8083/api/route"

-- Create JSON request
local json_request = string.format('{"ani":"%s","dnis":"%s","provider":"%s"}', 
                                  caller_id or "unknown", 
                                  destination, 
                                  provider_uuid or "")

-- Query router API
api = freeswitch.API()
local response = api:execute("curl", router_api_url .. " post " .. json_request)

-- Parse response
if response then
    -- Simple JSON parsing (in production, use proper JSON parser)
    local gateway = response:match('"gateway":"([^"]+)"')
    
    if gateway then
        -- Route the call through the gateway
        session:setVariable("gateway", gateway)
        session:execute("bridge", "sofia/external/" .. gateway .. "/" .. destination)
    else
        -- No route found
        session:execute("respond", "404 Not Found")
    end
else
    -- API error
    session:execute("respond", "503 Service Unavailable")
end
