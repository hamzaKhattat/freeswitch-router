// fs_xml_generator.c - Complete Dynamic FreeSWITCH Configuration Generator
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <uuid/uuid.h>
#include "freeswitch/fs_xml_generator.h"
#include "db/database.h"
#include "core/logging.h"

#define FS_BASE_DIR "/etc/freeswitch"
#define FS_CONF_DIR FS_BASE_DIR "/conf"
#define FS_SCRIPTS_DIR FS_BASE_DIR "/scripts"
#define ROUTER_CONFIG_DIR "/opt/freeswitch-router/configs"

// Ensure directory exists with proper permissions
static int ensure_directory(const char *path) {
    struct stat st = {0};
    
    if (stat(path, &st) == -1) {
        char tmp[512];
        char *p = NULL;
        size_t len;
        
        snprintf(tmp, sizeof(tmp), "%s", path);
        len = strlen(tmp);
        
        if (tmp[len - 1] == '/') {
            tmp[len - 1] = 0;
        }
        
        for (p = tmp + 1; *p; p++) {
            if (*p == '/') {
                *p = 0;
                if (mkdir(tmp, 0755) != 0 && errno != EEXIST) {
                    LOG_ERROR("Failed to create directory %s: %s", tmp, strerror(errno));
                    return -1;
                }
                *p = '/';
            }
        }
        
        if (mkdir(tmp, 0755) != 0 && errno != EEXIST) {
            LOG_ERROR("Failed to create directory %s: %s", tmp, strerror(errno));
            return -1;
        }
    }
    
    chmod(path, 0755);
    return 0;
}

// Initialize all required directories
int fs_init_all_directories(void) {
    LOG_INFO("Initializing FreeSWITCH directories...");
    
    const char *dirs[] = {
        FS_CONF_DIR,
        FS_CONF_DIR "/sip_profiles",
        FS_CONF_DIR "/sip_profiles/external",
        FS_CONF_DIR "/sip_profiles/internal",
        FS_CONF_DIR "/dialplan",
        FS_CONF_DIR "/dialplan/default",
        FS_CONF_DIR "/dialplan/public",
        FS_CONF_DIR "/autoload_configs",
        FS_CONF_DIR "/directory",
        FS_CONF_DIR "/directory/default",
        FS_SCRIPTS_DIR,
        FS_BASE_DIR "/log",
        FS_BASE_DIR "/db",
        FS_BASE_DIR "/recordings",
        ROUTER_CONFIG_DIR,
        ROUTER_CONFIG_DIR "/providers",
        ROUTER_CONFIG_DIR "/routes",
        ROUTER_CONFIG_DIR "/dialplans",
        ROUTER_CONFIG_DIR "/gateways",
        NULL
    };
    
    for (int i = 0; dirs[i] != NULL; i++) {
        if (ensure_directory(dirs[i]) != 0) {
            LOG_ERROR("Failed to create directory: %s", dirs[i]);
            return -1;
        }
    }
    
    LOG_INFO("Directory structure initialized");
    return 0;
}

// Generate main FreeSWITCH configuration
int fs_generate_main_config(void) {
    char filepath[512];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), "%s/freeswitch.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create main config: %s", filepath);
        return -1;
    }
    
    fprintf(fp, "<?xml version=\"1.0\"?>\n");
    fprintf(fp, "<document type=\"freeswitch/xml\">\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"include\" data=\"vars.xml\"/>\n");
    fprintf(fp, "  <section name=\"configuration\" description=\"Various Configuration\">\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"autoload_configs/*.xml\"/>\n");
    fprintf(fp, "  </section>\n");
    fprintf(fp, "  <section name=\"dialplan\" description=\"Regex/XML Dialplan\">\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"dialplan/*.xml\"/>\n");
    fprintf(fp, "  </section>\n");
    fprintf(fp, "  <section name=\"directory\" description=\"User Directory\">\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"directory/*.xml\"/>\n");
    fprintf(fp, "  </section>\n");
    fprintf(fp, "  <section name=\"profiles\" description=\"SIP Profiles\">\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"sip_profiles/*.xml\"/>\n");
    fprintf(fp, "  </section>\n");
    fprintf(fp, "</document>\n");
    
    fclose(fp);
    LOG_INFO("Generated main config: %s", filepath);
    
    // Generate vars.xml
    snprintf(filepath, sizeof(filepath), "%s/vars.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"local_ip_v4=10.0.0.2\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"domain=10.0.0.2\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"domain_name=10.0.0.2\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"external_rtp_ip=10.0.0.2\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"external_sip_ip=10.0.0.2\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"console_loglevel=debug\"/>\n");
    fprintf(fp, "  <X-PRE-PROCESS cmd=\"set\" data=\"router_db_dsn=pgsql://router:router123@localhost/router_db\"/>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    
    return 0;
}

// Generate SIP profiles with proper gateway includes
int fs_generate_sip_profiles(void) {
    char filepath[512];
    FILE *fp;
    
    // Generate external profile (for origin and final providers)
    snprintf(filepath, sizeof(filepath), "%s/sip_profiles/external.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<profile name=\"external\">\n");
    fprintf(fp, "  <settings>\n");
    fprintf(fp, "    <param name=\"debug\" value=\"3\"/>\n");
    fprintf(fp, "    <param name=\"sip-trace\" value=\"yes\"/>\n");
    fprintf(fp, "    <param name=\"sip-port\" value=\"5080\"/>\n");
    fprintf(fp, "    <param name=\"dialplan\" value=\"XML\"/>\n");
    fprintf(fp, "    <param name=\"context\" value=\"public\"/>\n");
    fprintf(fp, "    <param name=\"rtp-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"sip-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"ext-rtp-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"ext-sip-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"auth-calls\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"manage-presence\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"inbound-codec-negotiation\" value=\"generous\"/>\n");
    fprintf(fp, "    <param name=\"inbound-late-negotiation\" value=\"true\"/>\n");
    fprintf(fp, "    <param name=\"accept-blind-reg\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"accept-blind-auth\" value=\"false\"/>\n");
    fprintf(fp, "  </settings>\n");
    fprintf(fp, "  <gateways>\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"external/*.xml\"/>\n");
    fprintf(fp, "  </gateways>\n");
    fprintf(fp, "</profile>\n");
    
    fclose(fp);
    
    // Generate internal profile (for intermediate providers)
    snprintf(filepath, sizeof(filepath), "%s/sip_profiles/internal.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<profile name=\"internal\">\n");
    fprintf(fp, "  <settings>\n");
    fprintf(fp, "    <param name=\"debug\" value=\"3\"/>\n");
    fprintf(fp, "    <param name=\"sip-trace\" value=\"yes\"/>\n");
    fprintf(fp, "    <param name=\"sip-port\" value=\"5060\"/>\n");
    fprintf(fp, "    <param name=\"dialplan\" value=\"XML\"/>\n");
    fprintf(fp, "    <param name=\"context\" value=\"public\"/>\n");
    fprintf(fp, "    <param name=\"rtp-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"sip-ip\" value=\"10.0.0.2\"/>\n");
    fprintf(fp, "    <param name=\"auth-calls\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"manage-presence\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"inbound-codec-negotiation\" value=\"generous\"/>\n");
    fprintf(fp, "    <param name=\"inbound-late-negotiation\" value=\"true\"/>\n");
    fprintf(fp, "    <param name=\"accept-blind-reg\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"accept-blind-auth\" value=\"false\"/>\n");
    fprintf(fp, "  </settings>\n");
    fprintf(fp, "  <gateways>\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"internal/*.xml\"/>\n");
    fprintf(fp, "  </gateways>\n");
    fprintf(fp, "</profile>\n");
    
    fclose(fp);
    
    LOG_INFO("Generated SIP profiles");
    return 0;
}

// Generate provider configuration with proper ping/keep-alive
int fs_generate_provider_config(const char *uuid, const char *name, 
                               const char *host, int port, const char *role,
                               int auth_type, const char *auth_data) {
    char filepath[512];
    char backup_file[512];
    FILE *fp;
    
    // Determine which profile to use based on role
    const char *profile_dir = "external";
    if (strcmp(role, "intermediate") == 0) {
        profile_dir = "internal";
    }
    
    // Ensure directory exists
    char dir_path[512];
    snprintf(dir_path, sizeof(dir_path), "/etc/freeswitch/sip_profiles/%s", profile_dir);
    mkdir(dir_path, 0755);
    
    // Create gateway XML file
    snprintf(filepath, sizeof(filepath), "/etc/freeswitch/sip_profiles/%s/%s.xml", 
            profile_dir, uuid);
    
    // Backup existing if it exists
    snprintf(backup_file, sizeof(backup_file), "%s.bak", filepath);
    rename(filepath, backup_file);
    
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create gateway XML: %s", filepath);
        return -1;
    }
    
    // Write gateway configuration with proper ping/keep-alive
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <gateway name=\"%s\">\n", uuid);
    fprintf(fp, "    <!-- Provider: %s -->\n", name);
    fprintf(fp, "    <!-- Role: %s -->\n", role);
    fprintf(fp, "    <!-- Generated: %ld -->\n", time(NULL));
    fprintf(fp, "    <param name=\"realm\" value=\"%s\"/>\n", host);
    fprintf(fp, "    <param name=\"proxy\" value=\"%s:%d\"/>\n", host, port);
    fprintf(fp, "    <param name=\"register\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"register-transport\" value=\"udp\"/>\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    <!-- Keep-alive and monitoring -->\n");
    fprintf(fp, "    <param name=\"ping\" value=\"30\"/>\n");
    fprintf(fp, "    <param name=\"ping-max\" value=\"3\"/>\n");
    fprintf(fp, "    <param name=\"ping-min\" value=\"3\"/>\n");
    fprintf(fp, "    <param name=\"retry-seconds\" value=\"30\"/>\n");
    fprintf(fp, "    <param name=\"expire-seconds\" value=\"600\"/>\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    <!-- Codec and media settings -->\n");
    fprintf(fp, "    <param name=\"codec-prefs\" value=\"PCMU,PCMA,G729\"/>\n");
    fprintf(fp, "    <param name=\"inbound-codec-negotiation\" value=\"generous\"/>\n");
    fprintf(fp, "    <param name=\"rtp-timeout-sec\" value=\"300\"/>\n");
    fprintf(fp, "    <param name=\"rtp-hold-timeout-sec\" value=\"1800\"/>\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    <!-- Call routing -->\n");
    fprintf(fp, "    <param name=\"context\" value=\"public\"/>\n");
    fprintf(fp, "    <param name=\"caller-id-in-from\" value=\"true\"/>\n");
    fprintf(fp, "    <param name=\"supress-cng\" value=\"true\"/>\n");
    fprintf(fp, "    \n");
    
    // Authentication
    if (auth_type == 0) { // IP auth
        fprintf(fp, "    <!-- IP Authentication: %s -->\n", auth_data);
        fprintf(fp, "    <param name=\"register\" value=\"false\"/>\n");
    } else if (auth_type == 1) { // Username/Password
        char username[128], password[128];
        if (sscanf(auth_data, "%127[^:]:%127s", username, password) == 2) {
            fprintf(fp, "    <!-- Username/Password Authentication -->\n");
            fprintf(fp, "    <param name=\"username\" value=\"%s\"/>\n", username);
            fprintf(fp, "    <param name=\"password\" value=\"%s\"/>\n", password);
            fprintf(fp, "    <param name=\"register\" value=\"true\"/>\n");
            fprintf(fp, "    <param name=\"realm\" value=\"%s\"/>\n", host);
        }
    }
    
    fprintf(fp, "  </gateway>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    
    // Store provider mapping
    snprintf(filepath, sizeof(filepath), "/opt/freeswitch-router/configs/providers/%s.json", uuid);
    mkdir("/opt/freeswitch-router/configs/providers", 0755);
    
    fp = fopen(filepath, "w");
    if (fp) {
        fprintf(fp, "{\n");
        fprintf(fp, "  \"uuid\": \"%s\",\n", uuid);
        fprintf(fp, "  \"name\": \"%s\",\n", name);
        fprintf(fp, "  \"host\": \"%s\",\n", host);
        fprintf(fp, "  \"port\": %d,\n", port);
        fprintf(fp, "  \"role\": \"%s\",\n", role);
        fprintf(fp, "  \"auth_type\": %d,\n", auth_type);
        fprintf(fp, "  \"profile\": \"%s\",\n", profile_dir);
        fprintf(fp, "  \"created_at\": %ld\n", time(NULL));
        fprintf(fp, "}\n");
        fclose(fp);
    }
    
    LOG_INFO("Generated gateway config for %s (UUID: %s, Role: %s)", name, uuid, role);
    
    // Reload the specific profile
    char cmd[256];
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'sofia profile %s rescan' 2>/dev/null", profile_dir);
    system(cmd);
    
    return 0;
}

// Generate dynamic dialplan based on routes
int fs_generate_route_dialplan(void) {
    char filepath[512];
    FILE *fp;
    database_t *db = get_database();
    
    if (!db) {
        LOG_ERROR("Database not available");
        return -1;
    }
    
    // Generate main public dialplan that includes all route dialplans
    snprintf(filepath, sizeof(filepath), "%s/dialplan/public.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <context name=\"public\">\n");
    fprintf(fp, "    <!-- Dynamic Router Dialplan Generated: %ld -->\n", time(NULL));
    fprintf(fp, "\n");
    fprintf(fp, "    <!-- Default catch-all for testing -->\n");
    fprintf(fp, "    <extension name=\"test_route_12125551234\">\n");
    fprintf(fp, "      <condition field=\"destination_number\" expression=\"^(12125551234)$\">\n");
    fprintf(fp, "        <action application=\"log\" data=\"INFO Test call received: ${caller_id_number} -> ${destination_number}\"/>\n");
    fprintf(fp, "        <action application=\"answer\"/>\n");
    fprintf(fp, "        <action application=\"sleep\" data=\"1000\"/>\n");
    fprintf(fp, "        <action application=\"playback\" data=\"tone_stream://%%(1000,0,440)\"/>\n");
    fprintf(fp, "        <action application=\"sleep\" data=\"10000\"/>\n");
    fprintf(fp, "        <action application=\"hangup\" data=\"NORMAL_CLEARING\"/>\n");
    fprintf(fp, "      </condition>\n");
    fprintf(fp, "    </extension>\n");
    fprintf(fp, "\n");
    fprintf(fp, "    <!-- Include all route-specific dialplans -->\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"public/*.xml\"/>\n");
    fprintf(fp, "\n");
    fprintf(fp, "    <!-- Catch-all for unmatched numbers -->\n");
    fprintf(fp, "    <extension name=\"no_route\">\n");
    fprintf(fp, "      <condition field=\"destination_number\" expression=\"^(.*)$\">\n");
    fprintf(fp, "        <action application=\"log\" data=\"WARNING No route found for ${destination_number} from ${caller_id_number}\"/>\n");
    fprintf(fp, "        <action application=\"respond\" data=\"404 Not Found\"/>\n");
    fprintf(fp, "      </condition>\n");
    fprintf(fp, "    </extension>\n");
    fprintf(fp, "\n");
    fprintf(fp, "  </context>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    
    LOG_INFO("Generated main public dialplan");
    
    // Query all active routes from database
    const char *query = 
        "SELECT r.id, r.name, r.pattern, "
        "p1.uuid as origin_uuid, p1.name as origin_name, p1.host as origin_host, p1.port as origin_port, "
        "p2.uuid as inter_uuid, p2.name as inter_name, p2.host as inter_host, p2.port as inter_port, "
        "p3.uuid as final_uuid, p3.name as final_name, p3.host as final_host, p3.port as final_port, "
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
        const char *route_name = db_get_value(result, i, 1);
        const char *pattern = db_get_value(result, i, 2);
        const char *origin_uuid = db_get_value(result, i, 3);
        const char *origin_name = db_get_value(result, i, 4);
        const char *origin_host = db_get_value(result, i, 5);
        const char *inter_uuid = db_get_value(result, i, 7);
        const char *inter_name = db_get_value(result, i, 8);
        const char *inter_host = db_get_value(result, i, 9);
        const char *final_uuid = db_get_value(result, i, 11);
        const char *final_name = db_get_value(result, i, 12);
        
        // Validate required fields
        if (!route_id || !route_name || !pattern || !origin_uuid || !inter_uuid || !final_uuid) {
            LOG_WARN("Skipping incomplete route %s", route_name ? route_name : "unknown");
            continue;
        }
        
        // Generate route-specific dialplan
        snprintf(filepath, sizeof(filepath), "%s/dialplan/public/route_%s.xml", 
                FS_CONF_DIR, route_id);
        
        fp = fopen(filepath, "w");
        if (!fp) {
            LOG_ERROR("Failed to create dialplan file for route %s", route_id);
            continue;
        }
        
        fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
        fprintf(fp, "<!-- Route: %s -->\n", route_name);
        fprintf(fp, "<!-- Pattern: %s -->\n", pattern);
        fprintf(fp, "<!-- Flow: %s -> S2 -> %s -> S2 -> %s -->\n", 
                origin_name ? origin_name : "unknown",
                inter_name ? inter_name : "unknown",
                final_name ? final_name : "unknown");
        fprintf(fp, "<!-- Generated: %ld -->\n", time(NULL));
        fprintf(fp, "<include>\n");
        fprintf(fp, "\n");
        
        // Extension for calls from origin (S1 -> S2)
        fprintf(fp, "  <!-- Extension for calls from origin: %s -->\n", origin_name ? origin_name : "unknown");
        fprintf(fp, "  <extension name=\"route_%s_from_origin\">\n", route_id);
        fprintf(fp, "    <condition field=\"network_addr\" expression=\"^%s$\" break=\"never\">\n", 
                origin_host ? origin_host : "127.0.0.1");
        fprintf(fp, "      <action application=\"set\" data=\"route_id=%s\"/>\n", route_id);
        fprintf(fp, "      <action application=\"set\" data=\"route_name=%s\"/>\n", route_name);
        fprintf(fp, "      <action application=\"set\" data=\"call_source=origin\"/>\n");
        fprintf(fp, "    </condition>\n");
        fprintf(fp, "    <condition field=\"destination_number\" expression=\"^(%s)$\">\n", pattern);
        fprintf(fp, "      <action application=\"log\" data=\"INFO S1->S2: Route %s from %s, ANI=${caller_id_number}, DNIS=${destination_number}\"/>\n", 
                route_name, origin_name ? origin_name : "unknown");
        fprintf(fp, "      <action application=\"lua\" data=\"route_handler.lua origin %s %s %s\"/>\n", 
                route_id, inter_uuid, final_uuid);
        fprintf(fp, "    </condition>\n");
        fprintf(fp, "  </extension>\n");
        fprintf(fp, "\n");
        
        // Extension for return calls from intermediate (S3 -> S2)
        fprintf(fp, "  <!-- Extension for return calls from intermediate: %s -->\n", inter_name ? inter_name : "unknown");
        fprintf(fp, "  <extension name=\"route_%s_from_intermediate\">\n", route_id);
        fprintf(fp, "    <condition field=\"network_addr\" expression=\"^%s$\" break=\"never\">\n", 
                inter_host ? inter_host : "127.0.0.1");
        fprintf(fp, "      <action application=\"set\" data=\"route_id=%s\"/>\n", route_id);
        fprintf(fp, "      <action application=\"set\" data=\"route_name=%s\"/>\n", route_name);
        fprintf(fp, "      <action application=\"set\" data=\"call_source=intermediate\"/>\n");
        fprintf(fp, "    </condition>\n");
        fprintf(fp, "    <condition field=\"destination_number\" expression=\"^(.+)$\">\n");
        fprintf(fp, "      <action application=\"log\" data=\"INFO S3->S2: Route %s from %s, ANI=${caller_id_number}, DNIS=${destination_number}\"/>\n", 
                route_name, inter_name ? inter_name : "unknown");
        fprintf(fp, "      <action application=\"lua\" data=\"route_handler.lua intermediate %s %s %s\"/>\n",
                route_id, origin_uuid, final_uuid);
        fprintf(fp, "    </condition>\n");
        fprintf(fp, "  </extension>\n");
        fprintf(fp, "\n");
        
        fprintf(fp, "</include>\n");
        fclose(fp);
        
        LOG_INFO("Generated dialplan for route %s: %s -> %s -> %s", 
                route_name, 
                origin_name ? origin_name : "unknown", 
                inter_name ? inter_name : "unknown", 
                final_name ? final_name : "unknown");
    }
    
    db_free_result(result);
    
    // Generate the main route handler Lua script
    fs_generate_route_handler_lua();
    
    LOG_INFO("Dialplan generation complete");
    return 0;
}

// Generate improved route handler Lua script - SIMPLIFIED VERSION
int fs_generate_route_handler_lua(void) {
    char filepath[512];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), "%s/route_handler.lua", FS_SCRIPTS_DIR);
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create route_handler.lua");
        return -1;
    }
    
    // Write simplified, safe Lua script
    fprintf(fp, "-- Dynamic Route Handler for S1->S2->S3->S2->S4 flow\n");
    fprintf(fp, "-- Generated: %ld\n", time(NULL));
    fprintf(fp, "\n");
    
    fprintf(fp, "-- Get command line arguments\n");
    fprintf(fp, "local stage = argv[1] or \"unknown\"\n");
    fprintf(fp, "local route_id = argv[2] or \"0\"\n");
    fprintf(fp, "local next_provider = argv[3] or \"\"\n");
    fprintf(fp, "local final_provider = argv[4] or \"\"\n");
    fprintf(fp, "\n");
    
    fprintf(fp, "-- Get call variables\n");
    fprintf(fp, "local call_uuid = session:getVariable(\"uuid\")\n");
    fprintf(fp, "local ani = session:getVariable(\"caller_id_number\")\n");
    fprintf(fp, "local dnis = session:getVariable(\"destination_number\")\n");
    fprintf(fp, "\n");
    
    fprintf(fp, "-- Log the call\n");
    fprintf(fp, "freeswitch.consoleLog(\"INFO\", \"Route Handler: Stage=\" .. stage .. ");
    fprintf(fp, "\", ANI=\" .. (ani or \"nil\") .. ");
    fprintf(fp, "\", DNIS=\" .. (dnis or \"nil\") .. \"\\n\")\n");
    fprintf(fp, "\n");
    
    fprintf(fp, "if stage == \"origin\" then\n");
    fprintf(fp, "    -- S1->S2: Route to intermediate\n");
    fprintf(fp, "    session:setVariable(\"original_ani\", ani)\n");
    fprintf(fp, "    session:setVariable(\"original_dnis\", dnis)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Original-ANI\", ani)\n");
    fprintf(fp, "    session:setVariable(\"sip_h_X-Original-DNIS\", dnis)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    local bridge_str = \"sofia/gateway/\" .. next_provider .. \"/\" .. dnis\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Bridging to: \" .. bridge_str .. \"\\n\")\n");
    fprintf(fp, "    session:execute(\"bridge\", bridge_str)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "elseif stage == \"intermediate\" then\n");
    fprintf(fp, "    -- S3->S2: Route to final destination\n");
    fprintf(fp, "    local orig_ani = session:getVariable(\"sip_h_X-Original-ANI\") or ani\n");
    fprintf(fp, "    local orig_dnis = session:getVariable(\"sip_h_X-Original-DNIS\") or dnis\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    -- Restore original caller ID\n");
    fprintf(fp, "    session:setVariable(\"effective_caller_id_number\", orig_ani)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "    local bridge_str = \"sofia/gateway/\" .. final_provider .. \"/\" .. orig_dnis\n");
    fprintf(fp, "    freeswitch.consoleLog(\"INFO\", \"Bridging to final: \" .. bridge_str .. \"\\n\")\n");
    fprintf(fp, "    session:execute(\"bridge\", bridge_str)\n");
    fprintf(fp, "    \n");
    fprintf(fp, "else\n");
    fprintf(fp, "    freeswitch.consoleLog(\"ERROR\", \"Unknown stage: \" .. stage .. \"\\n\")\n");
    fprintf(fp, "    session:hangup(\"UNSPECIFIED\")\n");
    fprintf(fp, "end\n");
    fprintf(fp, "\n");
    fprintf(fp, "-- End of script\n");
    
    fclose(fp);
    
    LOG_INFO("Generated route_handler.lua");
    return 0;
}

// Generate autoload configs
int fs_generate_autoload_configs(void) {
    char filepath[512];
    FILE *fp;
    
    // modules.conf.xml
    snprintf(filepath, sizeof(filepath), "%s/autoload_configs/modules.conf.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<configuration name=\"modules.conf\">\n");
    fprintf(fp, "  <modules>\n");
    fprintf(fp, "    <load module=\"mod_console\"/>\n");
    fprintf(fp, "    <load module=\"mod_logfile\"/>\n");
    fprintf(fp, "    <load module=\"mod_sofia\"/>\n");
    fprintf(fp, "    <load module=\"mod_dialplan_xml\"/>\n");
    fprintf(fp, "    <load module=\"mod_dptools\"/>\n");
    fprintf(fp, "    <load module=\"mod_commands\"/>\n");
    fprintf(fp, "    <load module=\"mod_db\"/>\n");
    fprintf(fp, "    <load module=\"mod_lua\"/>\n");
    fprintf(fp, "    <load module=\"mod_event_socket\"/>\n");
    fprintf(fp, "  </modules>\n");
    fprintf(fp, "</configuration>\n");
    
    fclose(fp);
    
    // sofia.conf.xml
    snprintf(filepath, sizeof(filepath), "%s/autoload_configs/sofia.conf.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<configuration name=\"sofia.conf\" description=\"sofia Endpoint\">\n");
    fprintf(fp, "  <global_settings>\n");
    fprintf(fp, "    <param name=\"log-level\" value=\"0\"/>\n");
    fprintf(fp, "    <param name=\"debug-presence\" value=\"0\"/>\n");
    fprintf(fp, "  </global_settings>\n");
    fprintf(fp, "  <profiles>\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"../sip_profiles/*.xml\"/>\n");
    fprintf(fp, "  </profiles>\n");
    fprintf(fp, "</configuration>\n");
    
    fclose(fp);
    
    // event_socket.conf.xml
    snprintf(filepath, sizeof(filepath), "%s/autoload_configs/event_socket.conf.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<configuration name=\"event_socket.conf\">\n");
    fprintf(fp, "  <settings>\n");
    fprintf(fp, "    <param name=\"nat-map\" value=\"false\"/>\n");
    fprintf(fp, "    <param name=\"listen-ip\" value=\"127.0.0.1\"/>\n");
    fprintf(fp, "    <param name=\"listen-port\" value=\"8021\"/>\n");
    fprintf(fp, "    <param name=\"password\" value=\"ClueCon\"/>\n");
    fprintf(fp, "  </settings>\n");
    fprintf(fp, "</configuration>\n");
    
    fclose(fp);
    
    // db.conf.xml for database connectivity
    snprintf(filepath, sizeof(filepath), "%s/autoload_configs/db.conf.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<configuration name=\"db.conf\" description=\"Database Backend\">\n");
    fprintf(fp, "  <settings>\n");
    fprintf(fp, "    <param name=\"odbc-dsn\" value=\"pgsql://router:router123@localhost/router_db\"/>\n");
    fprintf(fp, "  </settings>\n");
    fprintf(fp, "</configuration>\n");
    
    fclose(fp);
    
    LOG_INFO("Generated autoload configs");
    return 0;
}

// Generate dialplan contexts
int fs_generate_dialplan_contexts(void) {
    char filepath[512];
    FILE *fp;
    
    // default.xml
    snprintf(filepath, sizeof(filepath), "%s/dialplan/default.xml", FS_CONF_DIR);
    fp = fopen(filepath, "w");
    if (!fp) return -1;
    
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <context name=\"default\">\n");
    fprintf(fp, "    <extension name=\"unloop\">\n");
    fprintf(fp, "      <condition field=\"${unroll_loops}\" expression=\"^true$\"/>\n");
    fprintf(fp, "      <condition field=\"${sip_looped_call}\" expression=\"^true$\">\n");
    fprintf(fp, "        <action application=\"deflect\" data=\"${destination_number}\"/>\n");
    fprintf(fp, "      </condition>\n");
    fprintf(fp, "    </extension>\n");
    fprintf(fp, "    <X-PRE-PROCESS cmd=\"include\" data=\"default/*.xml\"/>\n");
    fprintf(fp, "  </context>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    
    LOG_INFO("Generated dialplan contexts");
    return 0;
}

// Remove provider configuration
int fs_remove_provider_config(const char *uuid, const char *role) {
    char filepath[512];
    
    // Determine profile directory
    const char *profile_dir = "external";
    if (strcmp(role, "intermediate") == 0) {
        profile_dir = "internal";
    }
    
    // Remove gateway XML
    snprintf(filepath, sizeof(filepath), "%s/sip_profiles/%s/%s.xml", 
            FS_CONF_DIR, profile_dir, uuid);
    unlink(filepath);
    
    // Remove provider mapping
    snprintf(filepath, sizeof(filepath), "%s/providers/%s.json", ROUTER_CONFIG_DIR, uuid);
    unlink(filepath);
    
    LOG_INFO("Removed provider config for %s (role: %s)", uuid, role);
    return 0;
}

// Reload FreeSWITCH configuration
int fs_reload_config(void) {
    LOG_INFO("Reloading FreeSWITCH configuration...");
    
    system("fs_cli -x 'reloadxml' > /dev/null 2>&1");
    system("fs_cli -x 'reload mod_sofia' > /dev/null 2>&1");
    system("fs_cli -x 'sofia profile external rescan' > /dev/null 2>&1");
    system("fs_cli -x 'sofia profile internal rescan' > /dev/null 2>&1");
    
    LOG_INFO("FreeSWITCH configuration reloaded");
    return 0;
}

// Generate complete FreeSWITCH configuration
int fs_generate_complete_config(void) {
    LOG_INFO("Generating complete FreeSWITCH configuration...");
    
    // Initialize directories
    fs_init_all_directories();
    
    // Generate main configs
    fs_generate_main_config();
    fs_generate_sip_profiles();
    fs_generate_dialplan_contexts();
    fs_generate_autoload_configs();
    
    // Generate dynamic configs from database
    fs_regenerate_all_providers();
    fs_generate_route_dialplan();
    
    // Reload FreeSWITCH
    fs_reload_config();
    
    LOG_INFO("FreeSWITCH configuration complete");
    return 0;
}

// Regenerate all provider configs from database
int fs_regenerate_all_providers(void) {
    database_t *db = get_database();
    if (!db) return -1;
    
    const char *query = 
        "SELECT uuid, name, host, port, role, auth_type, auth_data "
        "FROM providers WHERE active = true";
    
    db_result_t *result = db_query(db, query);
    if (!result) return -1;
    
    for (int i = 0; i < result->num_rows; i++) {
        const char *uuid = db_get_value(result, i, 0);
        const char *name = db_get_value(result, i, 1);
        const char *host = db_get_value(result, i, 2);
        int port = atoi(db_get_value(result, i, 3));
        const char *role = db_get_value(result, i, 4);
        const char *auth_type_str = db_get_value(result, i, 5);
        const char *auth_data = db_get_value(result, i, 6);
        
        int auth_type = strcmp(auth_type_str, "ip") == 0 ? 0 : 1;
        
        fs_generate_provider_config(uuid, name, host, port, role, auth_type, auth_data);
    }
    
    db_free_result(result);
    
    LOG_INFO("Regenerated all provider configurations");
    return 0;
}
