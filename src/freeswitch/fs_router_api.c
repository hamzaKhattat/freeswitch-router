/**
 * FreeSWITCH Router API Module
 * 
 * Provides routing functionality for FreeSWITCH through database lookups
 * Supports ANI/DNIS routing with configurable DID manipulation
 */

#include <switch.h>
#include "router/router.h"
#include "db/database.h"

// Module function declarations
SWITCH_MODULE_LOAD_FUNCTION(mod_fs_router_load);
SWITCH_MODULE_SHUTDOWN_FUNCTION(mod_fs_router_shutdown);
SWITCH_MODULE_DEFINITION(mod_fs_router, mod_fs_router_load, mod_fs_router_shutdown, NULL);

// Global module state
static router_t *g_router = NULL;
static database_t *g_db = NULL;
static switch_memory_pool_t *g_pool = NULL;

// Configuration defaults
#define DEFAULT_DB_PATH "router_fs2.db"
#define MAX_PARAMS 10
#define MAX_PARAM_LEN 256

/**
 * Parse command line parameters in key=value format
 */
static switch_status_t parse_parameters(const char *cmd, char **ani, char **dnis, char **source) {
    char *mydata = NULL;
    char *argv[MAX_PARAMS];
    int argc = 0;
    
    if (zstr(cmd)) {
        return SWITCH_STATUS_FALSE;
    }
    
    mydata = strdup(cmd);
    if (!mydata) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_ERROR, 
                         "Failed to allocate memory for command parsing\n");
        return SWITCH_STATUS_MEMERR;
    }
    
    // Split command into parameters
    argc = switch_split(mydata, ' ', argv);
    
    // Parse key=value pairs
    for (int i = 0; i < argc && i < MAX_PARAMS; i++) {
        char *key = argv[i];
        char *val = strchr(key, '=');
        
        if (val) {
            *val++ = '\0';
            
            if (!strcmp(key, "ani")) {
                *ani = strdup(val);
            } else if (!strcmp(key, "dnis")) {
                *dnis = strdup(val);
            } else if (!strcmp(key, "source")) {
                *source = strdup(val);
            }
        }
    }
    
    switch_safe_free(mydata);
    return SWITCH_STATUS_SUCCESS;
}

/**
 * Apply DID manipulation rules based on route type
 */
static char* apply_did_manipulation(const char *route_type, const char *dnis, switch_memory_pool_t *pool) {
    if (!route_type || !dnis) {
        return NULL;
    }
    
    // FS3 requires 11-digit format (prepend '1' if not present)
    if (!strcmp(route_type, "FS3")) {
        if (dnis[0] != '1' && strlen(dnis) == 10) {
            return switch_core_sprintf(pool, "1%s", dnis);
        }
    }
    
    // Default: return original DNIS
    return switch_core_strdup(pool, dnis);
}

/**
 * Main router query function - handles API calls from FreeSWITCH
 */
static switch_status_t router_query_function(const char *cmd, switch_core_session_t *session, 
                                           switch_stream_handle_t *stream) {
    char *ani = NULL, *dnis = NULL, *source = NULL;
    char *manipulated_dnis = NULL;
    switch_status_t status = SWITCH_STATUS_SUCCESS;
    
    // Validate inputs
    if (!stream) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_ERROR, 
                         "Invalid stream handle\n");
        return SWITCH_STATUS_FALSE;
    }
    
    if (!g_router) {
        stream->write_function(stream, "error=router_not_initialized");
        return SWITCH_STATUS_SUCCESS;
    }
    
    // Parse command parameters
    if (parse_parameters(cmd, &ani, &dnis, &source) != SWITCH_STATUS_SUCCESS) {
        stream->write_function(stream, "error=parameter_parse_failed");
        goto cleanup;
    }
    
    // Validate required parameters
    if (!ani || !dnis) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_WARNING, 
                         "Missing required parameters: ani=%s, dnis=%s\n", 
                         ani ? ani : "NULL", dnis ? dnis : "NULL");
        stream->write_function(stream, "error=missing_required_params");
        goto cleanup;
    }
    
    // Log the routing request
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                     "Routing request: ani=%s, dnis=%s, source=%s\n", 
                     ani, dnis, source ? source : "NULL");
    
    // Prepare route request
    route_request_t req = {
        .ani = ani,
        .dnis = dnis,
        .provider = source,
        .route_type = NULL
    };
    
    // Perform routing lookup
    int route_result = router_route_call(g_router, &req);
    
    if (route_result == 0 && req.route_type) {
        // Apply DID manipulation if needed
        manipulated_dnis = apply_did_manipulation(req.route_type, dnis, g_pool);
        
        if (manipulated_dnis) {
            stream->write_function(stream, "gateway=%s dnis=%s", 
                                 req.route_type, manipulated_dnis);
            switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                             "Route found: gateway=%s, original_dnis=%s, final_dnis=%s\n", 
                             req.route_type, dnis, manipulated_dnis);
        } else {
            stream->write_function(stream, "gateway=%s dnis=%s", 
                                 req.route_type, dnis);
            switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                             "Route found: gateway=%s, dnis=%s\n", 
                             req.route_type, dnis);
        }
        
        // Free allocated route type
        switch_safe_free(req.route_type);
    } else {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_WARNING, 
                         "No route found for ani=%s, dnis=%s, source=%s\n", 
                         ani, dnis, source ? source : "NULL");
        stream->write_function(stream, "error=no_route_found");
    }

cleanup:
    // Clean up allocated memory
    switch_safe_free(ani);
    switch_safe_free(dnis);
    switch_safe_free(source);
    
    return status;
}

/**
 * Module load function - called when FreeSWITCH loads the module
 */
SWITCH_MODULE_LOAD_FUNCTION(mod_fs_router_load) {
    switch_api_interface_t *api_interface;
    switch_status_t status = SWITCH_STATUS_SUCCESS;
    
    // Create module interface
    *module_interface = switch_loadable_module_create_module_interface(pool, modname);
    if (!*module_interface) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_ERROR, 
                         "Failed to create module interface\n");
        return SWITCH_STATUS_GENERR;
    }
    
    // Store pool reference for memory management
    g_pool = pool;
    
    // Initialize database connection
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                     "Initializing database: %s\n", DEFAULT_DB_PATH);
    
    g_db = db_init(DEFAULT_DB_PATH);
    if (!g_db) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_ERROR, 
                         "Failed to initialize database: %s\n", DEFAULT_DB_PATH);
        return SWITCH_STATUS_GENERR;
    }
    
    // Initialize router with database connection
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                     "Initializing router engine\n");
    
    g_router = router_create(g_db, NULL, NULL);
    if (!g_router) {
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_ERROR, 
                         "Failed to initialize router engine\n");
        db_close(g_db);
        g_db = NULL;
        return SWITCH_STATUS_GENERR;
    }
    
    // Register API command
    SWITCH_ADD_API(api_interface, "router_query", 
                   "Query routing decision - Usage: router_query ani=<number> dnis=<number> [source=<provider>]", 
                   router_query_function, "");
    
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_NOTICE, 
                     "FreeSWITCH Router API module loaded successfully\n");
    
    return status;
}

/**
 * Module shutdown function - called when FreeSWITCH unloads the module
 */
SWITCH_MODULE_SHUTDOWN_FUNCTION(mod_fs_router_shutdown) {
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_INFO, 
                     "Shutting down FreeSWITCH Router API module\n");
    
    // Clean up router
    if (g_router) {
        router_destroy(g_router);
        g_router = NULL;
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_DEBUG, 
                         "Router engine destroyed\n");
    }
    
    // Clean up database connection
    if (g_db) {
        db_close(g_db);
        g_db = NULL;
        switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_DEBUG, 
                         "Database connection closed\n");
    }
    
    // Clear pool reference
    g_pool = NULL;
    
    switch_log_printf(SWITCH_CHANNEL_LOG, SWITCH_LOG_NOTICE, 
                     "FreeSWITCH Router API module shutdown complete\n");
    
    return SWITCH_STATUS_SUCCESS;
}
