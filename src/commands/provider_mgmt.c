#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <uuid/uuid.h>
#include "commands/provider_cmd.h"
#include "db/database.h"
#include "core/logging.h"

// Generate UUID for provider
static char* generate_provider_uuid() {
    uuid_t uuid;
    char *uuid_str = malloc(37);
    
    uuid_generate(uuid);
    uuid_unparse_lower(uuid, uuid_str);
    
    return uuid_str;
}

// Create FreeSWITCH gateway XML
static int create_gateway_xml(const char *uuid, const char *name, const char *host, 
                             int port, const char *username, const char *password) {
    char filepath[256];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), 
             "/etc/freeswitch/conf/sip_profiles/router/%s.xml", uuid);
    
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create gateway XML for %s", name);
        return -1;
    }
    
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <gateway name=\"%s\">\n", uuid);
    fprintf(fp, "    <!-- Provider: %s -->\n", name);
    fprintf(fp, "    <param name=\"realm\" value=\"%s\"/>\n", host);
    fprintf(fp, "    <param name=\"proxy\" value=\"%s:%d\"/>\n", host, port);
    
    if (username && strlen(username) > 0) {
        fprintf(fp, "    <param name=\"username\" value=\"%s\"/>\n", username);
        fprintf(fp, "    <param name=\"password\" value=\"%s\"/>\n", password);
        fprintf(fp, "    <param name=\"register\" value=\"true\"/>\n");
    } else {
        fprintf(fp, "    <param name=\"register\" value=\"false\"/>\n");
    }
    
    fprintf(fp, "    <param name=\"register-transport\" value=\"udp\"/>\n");
    fprintf(fp, "    <param name=\"retry-seconds\" value=\"30\"/>\n");
    fprintf(fp, "    <param name=\"ping\" value=\"30\"/>\n");
    fprintf(fp, "    <param name=\"context\" value=\"router\"/>\n");
    fprintf(fp, "    <param name=\"caller-id-in-from\" value=\"true\"/>\n");
    fprintf(fp, "  </gateway>\n");
    fprintf(fp, "</include>\n");
    
    fclose(fp);
    
    // Store mapping in configs
    snprintf(filepath, sizeof(filepath), "configs/providers/%s.json", uuid);
    fp = fopen(filepath, "w");
    if (fp) {
        fprintf(fp, "{\n");
        fprintf(fp, "  \"uuid\": \"%s\",\n", uuid);
        fprintf(fp, "  \"name\": \"%s\",\n", name);
        fprintf(fp, "  \"host\": \"%s\",\n", host);
        fprintf(fp, "  \"port\": %d,\n", port);
        fprintf(fp, "  \"xml_file\": \"/etc/freeswitch/conf/sip_profiles/router/%s.xml\"\n", uuid);
        fprintf(fp, "}\n");
        fclose(fp);
    }
    
    return 0;
}

// Enhanced provider add function
int provider_add_enhanced(const char *name, const char *host, int port,
                         const char *username, const char *password, int capacity) {
    database_t *db = get_database();
    char *uuid = generate_provider_uuid();
    
    // Insert into database with UUID
    const char *sql = "INSERT INTO providers (uuid, name, host, port, username, password, "
                     "transport, capacity, active) VALUES (?, ?, ?, ?, ?, ?, 'udp', ?, 1)";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    if (!stmt) {
        free(uuid);
        return -1;
    }
    
    db_bind_string(stmt, 1, uuid);
    db_bind_string(stmt, 2, name);
    db_bind_string(stmt, 3, host);
    db_bind_int(stmt, 4, port);
    db_bind_string(stmt, 5, username);
    db_bind_string(stmt, 6, password);
    db_bind_int(stmt, 7, capacity);
    
    if (db_execute(stmt) < 0) {
        db_finalize(stmt);
        free(uuid);
        return -1;
    }
    
    db_finalize(stmt);
    
    // Create FreeSWITCH gateway XML
    if (create_gateway_xml(uuid, name, host, port, username, password) == 0) {
        // Reload FreeSWITCH profile
        system("fs_cli -x 'sofia profile router rescan reloadxml'");
        
        LOG_INFO("Provider %s added with UUID %s", name, uuid);
    }
    
    free(uuid);
    return 0;
}
