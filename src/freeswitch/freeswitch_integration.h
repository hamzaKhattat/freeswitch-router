#ifndef FREESWITCH_INTEGRATION_H
#define FREESWITCH_INTEGRATION_H

typedef struct {
    int registered;
    int calls_in;
    int calls_out;
} gateway_status_t;

// Initialize FreeSWITCH configuration
int fs_init_directories(void);
int fs_create_router_profile(void);
int fs_create_router_dialplan(void);
int fs_create_lua_router(void);

// Provider management
int fs_add_provider(const char *name, const char *host, int port, 
                   const char *username, const char *password);
int fs_remove_provider(const char *name);

// Route management
int fs_add_route(const char *pattern, const char *provider, int priority);

// Utility functions
int fs_reload_profile(void);
int fs_get_gateway_status(const char *name, gateway_status_t *status);
void fs_monitor_gateways(void);

#endif
