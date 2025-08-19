// src/freeswitch/fs_generate_module2_dialplan.c
// Complete implementation with all fixes

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include "freeswitch/fs_xml_generator.h"
#include "db/database.h"
#include "core/logging.h"

#define CACHE_DIR "/opt/freeswitch-router/cache/dialplans"
#define DIALPLAN_DIR "/etc/freeswitch/dialplan/public"
#define DIALPLAN_BASE_DIR "/etc/freeswitch/dialplan"
#define SCRIPTS_DIR "/usr/local/freeswitch/share/freeswitch/scripts"

// Structure to cache generated dialplan configuration
typedef struct dialplan_cache {
    char route_id[64];
    char route_name[256];
    char xml_content[8192];
    char filename[256];
    time_t generated_at;
    struct dialplan_cache *next;
} dialplan_cache_t;

static dialplan_cache_t *cache_head = NULL;

// Initialize cache directory
static int init_cache_directory(void) {
    struct stat st = {0};
    
    // Create main cache directory
    if (stat("/opt/freeswitch-router/cache", &st) == -1) {
        if (mkdir("/opt/freeswitch-router/cache", 0755) != 0) {
            LOG_ERROR("Failed to create cache directory");
            return -1;
        }
    }
    
    // Create dialplans subdirectory
    if (stat(CACHE_DIR, &st) == -1) {
        if (mkdir(CACHE_DIR, 0755) != 0) {
            LOG_ERROR("Failed to create dialplan cache directory: %s", CACHE_DIR);
            return -1;
        }
    }
    
    // Ensure scripts directory exists
    if (stat(SCRIPTS_DIR, &st) == -1) {
        if (mkdir(SCRIPTS_DIR, 0755) != 0) {
            LOG_ERROR("Failed to create scripts directory: %s", SCRIPTS_DIR);
            return -1;
        }
    }
    
    // Ensure dialplan directories exist
    if (stat(DIALPLAN_BASE_DIR, &st) == -1) {
        if (mkdir(DIALPLAN_BASE_DIR, 0755) != 0) {
            LOG_ERROR("Failed to create dialplan base directory");
            return -1;
        }
    }
    
    if (stat(DIALPLAN_DIR, &st) == -1) {
        if (mkdir(DIALPLAN_DIR, 0755) != 0) {
            LOG_ERROR("Failed to create dialplan public directory");
            return -1;
        }
    }
    
    return 0;
}

// Save dialplan to cache
static int cache_dialplan(const char *route_id, const char *route_name, 
                         const char *xml_content, const char *filename) {
    dialplan_cache_t *cache = calloc(1, sizeof(dialplan_cache_t));
    if (!cache) return -1;
    
    strncpy(cache->route_id, route_id, sizeof(cache->route_id) - 1);
    strncpy(cache->route_name, route_name, sizeof(cache->route_name) - 1);
    strncpy(cache->xml_content, xml_content, sizeof(cache->xml_content) - 1);
    strncpy(cache->filename, filename, sizeof(cache->filename) - 1);
    cache->generated_at = time(NULL);
    
    // Add to cache list
    cache->next = cache_head;
    cache_head = cache;
    
    // Save to cache file
    char cache_file[512];
    snprintf(cache_file, sizeof(cache_file), "%s/route_%s.xml", CACHE_DIR, route_id);
    FILE *fp = fopen(cache_file, "w");
    if (fp) {
        fprintf(fp, "%s", xml_content);
        fclose(fp);
    }
    
    LOG_INFO("Cached dialplan for route %s", route_name);
    return 0;
}

// Generate the complete corrected Lua handler script with FIXED connection string
int fs_generate_corrected_lua_handler(void) {
    char filepath[512];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), "%s/route_handler_corrected.lua", SCRIPTS_DIR);
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create route_handler_corrected.lua");
        return -1;
    }
    
    // Write the complete corrected Lua script with FIXED database connection
    fprintf(fp, "-- route_handler_corrected.lua\n");
    fprintf(fp, "-- Implements Module 2 requirements: S1 -> S2 -> S3 -> S2 -> S4\n");
    fprintf(fp, "-- with proper ANI/DNIS/DID transformations\n\n");
    
    fprintf(fp, "-- Database connection parameters\n");
    fprintf(fp, "local db_dsn = \"pgsql://host=localhost dbname=router_db user=router password=router123\"\n\n");
    fprintf(fp, "local connection_string = \"host=localhost dbname=router_db user=router password=router123\"\n\n");

fprintf(fp, "-- Function to connect to database\n");
fprintf(fp, "function db_connect()\n");
fprintf(fp, "    local dbh = freeswitch.Dbh(\"pgsql://\" .. connection_string)\n");

    fprintf(fp, "    if not dbh:connected() then\n");
    fprintf(fp, "        freeswitch.consoleLog(\"ERROR\", \"Failed to connect to database\\n\")\n");
    fprintf(fp, "        return nil\n");
    fprintf(fp, "    end\n");
    fprintf(fp, "    return dbh\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "-- Function to allocate a DID from the pool\n");
    fprintf(fp, "function allocate_did(dbh, ani, dnis, call_id, provider_id)\n");
    fprintf(fp, "    -- Find an available DID associated with the provider\n");
    fprintf(fp, "    local query = string.format(\n");
    fprintf(fp, "        \"SELECT id, did FROM dids WHERE in_use = false AND active = true \" ..\n");
    fprintf(fp, "        \"AND provider_id = %%d ORDER BY RANDOM() LIMIT 1\",\n");
    fprintf(fp, "        provider_id\n");
    fprintf(fp, "    )\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Allocating DID for provider_id: \" .. provider_id .. \"\\n\")\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    local allocated_did = nil\n");
    fprintf(fp, "    local did_id = nil\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    dbh:query(query, function(row)\n");
    fprintf(fp, "        did_id = row.id\n");
    fprintf(fp, "        allocated_did = row.did\n");
    fprintf(fp, "    end)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    if allocated_did then\n");
    fprintf(fp, "        -- Mark DID as in use and store original DNIS\n");
    fprintf(fp, "        local update_query = string.format(\n");
    fprintf(fp, "            \"UPDATE dids SET in_use = true, destination = '%%s', \" ..\n");
    fprintf(fp, "            \"original_ani = '%%s', call_id = '%%s', allocated_at = NOW() \" ..\n");
    fprintf(fp, "            \"WHERE id = %%d\",\n");
    fprintf(fp, "            dnis, ani, call_id, did_id\n");
    fprintf(fp, "        )\n");
    fprintf(fp, "        dbh:query(update_query)\n");
    fprintf(fp, "        \n");
    fprintf(fp, "        freeswitch.consoleLog(\"INFO\", \n");
    fprintf(fp, "            string.format(\"Allocated DID %%s for call %%s (ANI: %%s, DNIS: %%s)\\n\",\n");
    fprintf(fp, "                         allocated_did, call_id, ani, dnis))\n");
    fprintf(fp, "    else\n");
    fprintf(fp, "        freeswitch.consoleLog(\"ERROR\", \"No available DID for provider_id: \" .. provider_id .. \"\\n\")\n");
    fprintf(fp, "    end\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    return allocated_did\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "-- Function to release a DID back to the pool\n");
    fprintf(fp, "function release_did(dbh, did)\n");
    fprintf(fp, "    local query = string.format(\n");
    fprintf(fp, "        \"UPDATE dids SET in_use = false, destination = NULL, \" ..\n");
    fprintf(fp, "        \"original_ani = NULL, call_id = NULL, allocated_at = NULL \" ..\n");
    fprintf(fp, "        \"WHERE did = '%%s'\",\n");
    fprintf(fp, "        did\n");
    fprintf(fp, "    )\n");
    fprintf(fp, "    dbh:query(query)\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Released DID: \" .. did .. \"\\n\")\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "-- Function to find original DNIS from DID\n");
    fprintf(fp, "function find_original_dnis(dbh, did)\n");
    fprintf(fp, "    local original_dnis = nil\n");
    fprintf(fp, "    local original_ani = nil\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    local query = string.format(\n");
    fprintf(fp, "        \"SELECT destination, original_ani FROM dids WHERE did = '%%s' AND in_use = true\",\n");
    fprintf(fp, "        did\n");
    fprintf(fp, "    )\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    dbh:query(query, function(row)\n");
    fprintf(fp, "        original_dnis = row.destination\n");
    fprintf(fp, "        original_ani = row.original_ani\n");
    fprintf(fp, "    end)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    return original_dnis, original_ani\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "-- Main execution\n");
    fprintf(fp, "local stage = argv[1] or \"unknown\"\n");
    fprintf(fp, "local route_id = argv[2] or \"0\"\n");
    fprintf(fp, "local next_provider = argv[3] or \"\"\n");
    fprintf(fp, "local final_provider = argv[4] or \"\"\n\n");
    
    fprintf(fp, "-- Get call variables\n");
    fprintf(fp, "local call_uuid = session:getVariable(\"uuid\")\n");
    fprintf(fp, "local ani = session:getVariable(\"caller_id_number\")\n");
    fprintf(fp, "local dnis = session:getVariable(\"destination_number\")\n");
    fprintf(fp, "local network_addr = session:getVariable(\"network_addr\")\n\n");
    
    fprintf(fp, "freeswitch.consoleLog(\"INFO\", \n");
    fprintf(fp, "    string.format(\"Module 2 Route Handler - Stage: %%s, ANI: %%s, DNIS: %%s, Source: %%s\\n\",\n");
    fprintf(fp, "                  stage, ani or \"nil\", dnis or \"nil\", network_addr or \"nil\"))\n\n");
    
    fprintf(fp, "-- Connect to database\n");
    fprintf(fp, "local dbh = db_connect()\n");
    fprintf(fp, "if not dbh then\n");
    fprintf(fp, "    session:hangup(\"TEMPORARY_FAILURE\")\n");
    fprintf(fp, "    return\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "if stage == \"origin\" then\n");
    fprintf(fp, "    -- S1 -> S2: Incoming call from origin server\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Processing origin stage for route \" .. route_id .. \"\\n\")\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Store original ANI (ANI-1) and DNIS (DNIS-1)\n");
    fprintf(fp, "    session:setVariable(\"original_ani\", ani)\n");
    fprintf(fp, "    session:setVariable(\"original_dnis\", dnis)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Original-ANI\", ani)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Original-DNIS\", dnis)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Call-ID\", call_uuid)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Get intermediate provider ID from UUID\n");
    fprintf(fp, "    local inter_provider_id = 0\n");
    fprintf(fp, "    if next_provider and next_provider ~= \"\" then\n");
    fprintf(fp, "        local query = string.format(\n");
    fprintf(fp, "            \"SELECT id FROM providers WHERE uuid = '%%s'\", next_provider\n");
    fprintf(fp, "        )\n");
    fprintf(fp, "        dbh:query(query, function(row)\n");
    fprintf(fp, "            inter_provider_id = tonumber(row.id)\n");
    fprintf(fp, "        end)\n");
    fprintf(fp, "        freeswitch.consoleLog(\"INFO\", \"Intermediate provider UUID: \" .. next_provider .. \" ID: \" .. inter_provider_id .. \"\\n\")\n");
    fprintf(fp, "    end\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Allocate a DID from the pool\n");
    fprintf(fp, "    local allocated_did = allocate_did(dbh, ani, dnis, call_uuid, inter_provider_id)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    if not allocated_did then\n");
    fprintf(fp, "        freeswitch.consoleLog(\"ERROR\", \"No available DID for routing\\n\")\n");
    fprintf(fp, "        session:hangup(\"CONGESTION\")\n");
    fprintf(fp, "        dbh:release()\n");
    fprintf(fp, "        return\n");
    fprintf(fp, "    end\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- S2 -> S3: Forward to intermediate with transformations\n");
    fprintf(fp, "    -- Replace ANI-1 with DNIS-1 (now becomes ANI-2)\n");
    fprintf(fp, "    -- Replace DNIS-1 with allocated DID\n");
    fprintf(fp, "    session:setVariable(\"effective_caller_id_number\", dnis)  -- DNIS-1 becomes ANI-2\n");
    fprintf(fp, "    session:setVariable(\"effective_caller_id_name\", dnis)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Allocated-DID\", allocated_did)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Bridge to intermediate server with transformed values\n");
    fprintf(fp, "    local bridge_str = string.format(\"sofia/gateway/%%s/%%s\", next_provider, allocated_did)\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \n");
    fprintf(fp, "        string.format(\"S1->S2->S3: ANI-1=%%s, DNIS-1=%%s => ANI-2=%%s, DID=%%s via %%s\\n\",\n");
    fprintf(fp, "                      ani, dnis, dnis, allocated_did, bridge_str))\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    session:execute(\"bridge\", bridge_str)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "elseif stage == \"intermediate_return\" then\n");
    fprintf(fp, "    -- S3 -> S2: Return call from intermediate server\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Processing intermediate_return stage\\n\")\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- The call comes back with ANI-2 (which was DNIS-1) and DID\n");
    fprintf(fp, "    -- Find the original DNIS-1 and ANI-1 from the DID\n");
    fprintf(fp, "    local original_dnis, original_ani = find_original_dnis(dbh, dnis)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    if not original_dnis then\n");
    fprintf(fp, "        freeswitch.consoleLog(\"ERROR\", \n");
    fprintf(fp, "            string.format(\"No mapping found for DID %%s - rejecting call\\n\", dnis))\n");
    fprintf(fp, "        session:hangup(\"CALL_REJECTED\")\n");
    fprintf(fp, "        dbh:release()\n");
    fprintf(fp, "        return\n");
    fprintf(fp, "    end\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Release the DID back to the pool\n");
    fprintf(fp, "    release_did(dbh, dnis)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- S2 -> S4: Restore original values and forward to final destination\n");
    fprintf(fp, "    -- Restore ANI-1 and DNIS-1\n");
    fprintf(fp, "    session:setVariable(\"effective_caller_id_number\", original_ani)\n");
    fprintf(fp, "    session:setVariable(\"effective_caller_id_name\", original_ani)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    local bridge_str = string.format(\"sofia/gateway/%%s/%%s\", final_provider, original_dnis)\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \n");
    fprintf(fp, "        string.format(\"S3->S2->S4: Restored ANI-1=%%s, DNIS-1=%%s, bridging to %%s\\n\",\n");
    fprintf(fp, "                      original_ani, original_dnis, bridge_str))\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    session:execute(\"bridge\", bridge_str)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "else\n");
    fprintf(fp, "    freeswitch.consoleLog(\"ERROR\", \"Unknown routing stage: \" .. stage .. \"\\n\")\n");
    fprintf(fp, "    session:hangup(\"UNSPECIFIED\")\n");
    fprintf(fp, "end\n\n");
    
    fprintf(fp, "-- Clean up database connection\n");
    fprintf(fp, "if dbh then\n");
    fprintf(fp, "    dbh:release()\n");
    fprintf(fp, "end\n");
    
    fclose(fp);
    chmod(filepath, 0755);
    
    LOG_INFO("Generated complete corrected route handler Lua script at %s", filepath);
    return 0;
}

// Remove dialplan from cache and filesystem
int fs_remove_route_dialplan(const char *route_id) {
    // Remove from filesystem
    char filepath[512];
    snprintf(filepath, sizeof(filepath), "%s/route_%s.xml", DIALPLAN_DIR, route_id);
    if (unlink(filepath) == 0) {
        LOG_INFO("Removed dialplan file: %s", filepath);
    }
    
    // Remove from cache
    char cache_file[512];
    snprintf(cache_file, sizeof(cache_file), "%s/route_%s.xml", CACHE_DIR, route_id);
    unlink(cache_file);
    
    // Remove from cache list
    dialplan_cache_t **pp = &cache_head;
    while (*pp) {
        if (strcmp((*pp)->route_id, route_id) == 0) {
            dialplan_cache_t *to_remove = *pp;
            *pp = (*pp)->next;
            free(to_remove);
            break;
        }
        pp = &(*pp)->next;
    }
    
    return 0;
}

// Clear all cached dialplans
int fs_clear_dialplan_cache(void) {
    char cmd[256];
    snprintf(cmd, sizeof(cmd), "rm -f %s/*.xml", CACHE_DIR);
    system(cmd);
    
    // Clear cache list
    while (cache_head) {
        dialplan_cache_t *next = cache_head->next;
        free(cache_head);
        cache_head = next;
    }
    
    LOG_INFO("Cleared dialplan cache");
    return 0;
}

// Restore dialplans from cache
int fs_restore_dialplans_from_cache(void) {
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "cp %s/*.xml %s/ 2>/dev/null", CACHE_DIR, DIALPLAN_DIR);
    system(cmd);
    
    LOG_INFO("Restored dialplans from cache");
    return 0;
}

// Main function to generate Module 2 route dialplan - COMPLETE FIXED IMPLEMENTATION
int fs_generate_module2_route_dialplan(void) {
    database_t *db = get_database();
    if (!db) {
        LOG_ERROR("Database not available");
        return -1;
    }
    
    init_cache_directory();
    
    // Generate the Lua handler first
    fs_generate_corrected_lua_handler();
    
    // Generate main public.xml in the CORRECT location (/etc/freeswitch/dialplan/public.xml)
    char filepath[512];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), "%s/public.xml", DIALPLAN_BASE_DIR);  // FIXED: Use base dir
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create public.xml at %s", filepath);
        return -1;
    }
    
    fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <context name=\"public\">\n");
    fprintf(fp, "    <!-- Module 2 Dynamic Router Generated: %ld -->\n", time(NULL));
    fprintf(fp, "    <!-- Include all route-specific dialplans from public directory -->\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"public/*.xml\"/>\n");
    fprintf(fp, "  </context>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    LOG_INFO("Generated main public dialplan at %s", filepath);
    
    // Query all active routes from database with provider details
    const char *query = 
        "SELECT r.id, r.uuid, r.name, r.pattern, "
        "p1.uuid as origin_uuid, p1.name as origin_name, p1.host as origin_host, "
        "p2.uuid as inter_uuid, p2.name as inter_name, p2.host as inter_host, "
        "p3.uuid as final_uuid, p3.name as final_name, p3.host as final_host, "
        "r.priority "
        "FROM routes r "
        "LEFT JOIN providers p1 ON r.origin_provider_id = p1.id "
        "LEFT JOIN providers p2 ON r.intermediate_provider_id = p2.id "
        "LEFT JOIN providers p3 ON r.final_provider_id = p3.id "
        "WHERE r.active = true "
        "ORDER BY r.priority DESC";
    
    db_result_t *result = db_query(db, query);
    if (!result) {
        LOG_ERROR("Failed to query routes");
        return -1;
    }
    
    LOG_INFO("Found %d active routes to generate dialplans for", result->num_rows);
    
    // Generate individual route dialplans
    for (int i = 0; i < result->num_rows; i++) {
        const char *route_id = db_get_value(result, i, 0);
        const char *route_uuid = db_get_value(result, i, 1);
        const char *route_name = db_get_value(result, i, 2);
        const char *pattern = db_get_value(result, i, 3);
        const char *origin_uuid = db_get_value(result, i, 4);
        const char *origin_name = db_get_value(result, i, 5);
        const char *origin_host = db_get_value(result, i, 6);
        const char *inter_uuid = db_get_value(result, i, 7);
        const char *inter_name = db_get_value(result, i, 8);
        const char *inter_host = db_get_value(result, i, 9);
        const char *final_uuid = db_get_value(result, i, 10);
        const char *final_name = db_get_value(result, i, 11);
        const char *priority = db_get_value(result, i, 13);
        
        // Validate required fields
        if (!route_id || !route_name || !pattern) {
            LOG_WARN("Skipping incomplete route %s", route_name ? route_name : "unknown");
            continue;
        }
        
        // Generate route-specific dialplan XML in public directory
        snprintf(filepath, sizeof(filepath), "%s/route_%s.xml", DIALPLAN_DIR, route_id);
        
        fp = fopen(filepath, "w");
        if (!fp) {
            LOG_ERROR("Failed to create dialplan file for route %s", route_id);
            continue;
        }
        
        // Remove quotes from pattern if they exist
        char clean_pattern[256];
        const char *p_src = pattern;
        char *p_dst = clean_pattern;
        while (*p_src) {
            if (*p_src != '\'' && *p_src != '"') {
                *p_dst++ = *p_src;
            }
            p_src++;
        }
        *p_dst = '\0';
        
        // Write XML with PROPER context wrapper
        fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
        fprintf(fp, "<!-- Route: %s (UUID: %s) -->\n", route_name, route_uuid ? route_uuid : "none");
        fprintf(fp, "<!-- Pattern: %s, Priority: %s -->\n", clean_pattern, priority ? priority : "100");
        fprintf(fp, "<!-- Flow: %s -> S2 -> %s -> S2 -> %s -->\n", 
                origin_name ? origin_name : "unknown",
                inter_name ? inter_name : "unknown",
                final_name ? final_name : "unknown");
        fprintf(fp, "<!-- Generated: %ld -->\n", time(NULL));
        fprintf(fp, "<include>\n");
        fprintf(fp, "  <context name=\"public\">\n");  // CONTEXT WRAPPER
        fprintf(fp, "\n");
        
        // Extension for calls from origin (S1 -> S2)
        fprintf(fp, "    <!-- Extension for calls from origin: %s -->\n", origin_name ? origin_name : "unknown");
        fprintf(fp, "    <extension name=\"route_%s_from_origin\">\n", route_id);
        
        // Match on source IP if available
        if (origin_host && strlen(origin_host) > 0) {
            // Escape dots in IP address for regex
            char escaped_host[256];
            const char *src = origin_host;
            char *dst = escaped_host;
            while (*src) {
                if (*src == '.') {
                    *dst++ = '\\';
                    *dst++ = '.';
                } else {
                    *dst++ = *src;
                }
                src++;
            }
            *dst = '\0';
            
            fprintf(fp, "      <condition field=\"network_addr\" expression=\"^%s$\" break=\"never\">\n", escaped_host);
            fprintf(fp, "        <action application=\"set\" data=\"route_id=%s\"/>\n", route_id);
            fprintf(fp, "        <action application=\"set\" data=\"route_name=%s\"/>\n", route_name);
            fprintf(fp, "        <action application=\"set\" data=\"call_source=origin\"/>\n");
            fprintf(fp, "      </condition>\n");
        }
        
        // Match on destination number pattern - USE CLEAN PATTERN
        fprintf(fp, "      <condition field=\"destination_number\" expression=\"^%s$\">\n", clean_pattern);
        fprintf(fp, "        <action application=\"log\" data=\"INFO S1->S2: Route %s from %s, ANI=${caller_id_number}, DNIS=${destination_number}\"/>\n", 
                route_name, origin_name ? origin_name : "unknown");
        fprintf(fp, "        <action application=\"lua\" data=\"route_handler_corrected.lua origin %s %s %s\"/>\n", 
                route_id, inter_uuid ? inter_uuid : "", final_uuid ? final_uuid : "");
        fprintf(fp, "      </condition>\n");
        fprintf(fp, "    </extension>\n");
        fprintf(fp, "\n");
        
        // Extension for return calls from intermediate (S3 -> S2)
        fprintf(fp, "    <!-- Extension for return calls from intermediate: %s -->\n", inter_name ? inter_name : "unknown");
        fprintf(fp, "    <extension name=\"route_%s_from_intermediate\">\n", route_id);
        
        // Match on source IP if available
        if (inter_host && strlen(inter_host) > 0) {
            // Escape dots in IP address for regex
            char escaped_host[256];
            const char *src = inter_host;
            char *dst = escaped_host;
            while (*src) {
                if (*src == '.') {
                    *dst++ = '\\';
                    *dst++ = '.';
                } else {
                    *dst++ = *src;
               }
               src++;
           }
           *dst = '\0';
           
           fprintf(fp, "      <condition field=\"network_addr\" expression=\"^%s$\" break=\"never\">\n", escaped_host);
           fprintf(fp, "        <action application=\"set\" data=\"route_id=%s\"/>\n", route_id);
           fprintf(fp, "        <action application=\"set\" data=\"route_name=%s\"/>\n", route_name);
           fprintf(fp, "        <action application=\"set\" data=\"call_source=intermediate\"/>\n");
           fprintf(fp, "      </condition>\n");
       }
       
       // Match any DID as destination
       fprintf(fp, "      <condition field=\"destination_number\" expression=\"^(.+)$\">\n");
       fprintf(fp, "        <action application=\"log\" data=\"INFO S3->S2: Route %s from %s, ANI=${caller_id_number}, DID=${destination_number}\"/>\n", 
               route_name, inter_name ? inter_name : "unknown");
       fprintf(fp, "        <action application=\"lua\" data=\"route_handler_corrected.lua intermediate_return %s %s %s\"/>\n",
               route_id, origin_uuid ? origin_uuid : "", final_uuid ? final_uuid : "");
       fprintf(fp, "      </condition>\n");
       fprintf(fp, "    </extension>\n");
       fprintf(fp, "\n");
       
       fprintf(fp, "  </context>\n");  // CLOSE CONTEXT
       fprintf(fp, "</include>\n");
       
       fclose(fp);
       
       // Cache the dialplan
       char xml_content[8192];
       FILE *read_fp = fopen(filepath, "r");
       if (read_fp) {
           size_t len = fread(xml_content, 1, sizeof(xml_content) - 1, read_fp);
           xml_content[len] = '\0';
           fclose(read_fp);
           cache_dialplan(route_id, route_name, xml_content, filepath);
       }
       
       LOG_INFO("Generated dialplan for route %s: %s -> %s -> %s (file: %s)", 
               route_name, 
               origin_name ? origin_name : "unknown", 
               inter_name ? inter_name : "unknown", 
               final_name ? final_name : "unknown",
               filepath);
   }
   
   db_free_result(result);
   
   // Generate a default catch-all extension if no routes match
   /*snprintf(filepath, sizeof(filepath), "%s/default_catch_all.xml", DIALPLAN_DIR);
   fp = fopen(filepath, "w");
   if (fp) {
       fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
       fprintf(fp, "<!-- Default catch-all for unmatched calls -->\n");
       fprintf(fp, "<include>\n");
       fprintf(fp, "  <context name=\"public\">\n");
       fprintf(fp, "    <extension name=\"default_catch_all\" continue=\"false\">\n");
       fprintf(fp, "      <condition field=\"destination_number\" expression=\"^(.*)$\">\n");
       fprintf(fp, "        <action application=\"log\" data=\"WARNING No route found for ${destination_number} from ${network_addr}\"/>\n");
       fprintf(fp, "        <action application=\"respond\" data=\"404 Not Found\"/>\n");
       fprintf(fp, "      </condition>\n");
       fprintf(fp, "    </extension>\n");
       fprintf(fp, "  </context>\n");
       fprintf(fp, "</include>\n");
       fclose(fp);
       LOG_INFO("Generated default catch-all extension");
   }*/
   
   // Reload FreeSWITCH configuration
   fs_reload_config();
   
   LOG_INFO("Module 2 dialplan generation complete - generated %d route dialplans", result->num_rows);
   return 0;
}
                    
