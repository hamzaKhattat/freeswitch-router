#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "freeswitch_integration.h"
#include "db/database.h"
#include "core/logging.h"

#define FS_CONF_DIR "/etc/freeswitch/conf"
#define FS_PROFILES_DIR FS_CONF_DIR "/sip_profiles"
#define FS_DIALPLAN_DIR FS_CONF_DIR "/dialplan"
#define FS_GATEWAYS_DIR FS_PROFILES_DIR "/router"

int fs_init_directories(void) {
    LOG_INFO("Initializing FreeSWITCH directories");
    return 0;
}

int fs_add_provider(const char *name, const char *host, int port, 
                    const char *username, const char *password) {
    char filepath[256];
    FILE *fp;
    
    snprintf(filepath, sizeof(filepath), "%s/%s.xml", FS_GATEWAYS_DIR, name);
    fp = fopen(filepath, "w");
    if (!fp) {
        LOG_ERROR("Failed to create gateway config for %s", name);
        return -1;
    }
    
    fprintf(fp, "<include>\n");
    fprintf(fp, "  <gateway name=\"%s\">\n", name);
    fprintf(fp, "    <param name=\"realm\" value=\"%s\"/>\n", host);
    fprintf(fp, "    <param name=\"proxy\" value=\"%s:%d\"/>\n", host, port);
    
    if (username && password) {
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
    
    fs_reload_profile();
    
    LOG_INFO("Added provider %s (%s:%d) to FreeSWITCH", name, host, port);
    return 0;
}

int fs_remove_provider(const char *name) {
    char filepath[256];
    char cmd[512];
    
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'sofia profile router killgw %s'", name);
    system(cmd);
    
    snprintf(filepath, sizeof(filepath), "%s/%s.xml", FS_GATEWAYS_DIR, name);
    unlink(filepath);
    
    fs_reload_profile();
    
    LOG_INFO("Removed provider %s from FreeSWITCH", name);
    return 0;
}

int fs_reload_profile(void) {
    char cmd[256];
    
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'sofia profile router rescan reloadxml'");
    system(cmd);
    
    return 0;
}

int fs_get_gateway_status(const char *name, gateway_status_t *status) {
    char cmd[256];
    FILE *fp;
    char buffer[1024];
    
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'sofia status gateway %s' 2>/dev/null", name);
    fp = popen(cmd, "r");
    if (!fp) {
        return -1;
    }
    
    status->registered = 0;
    status->calls_in = 0;
    status->calls_out = 0;
    
    while (fgets(buffer, sizeof(buffer), fp)) {
        if (strstr(buffer, "Status") && strstr(buffer, "REGED")) {
            status->registered = 1;
        }
    }
    
    pclose(fp);
    return 0;
}

void fs_monitor_gateways(void) {
    // Implementation for monitoring
}
