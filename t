.
├── bin
├── build
│   ├── api
│   │   ├── handlers.o
│   │   └── route_handler.o
│   ├── cli
│   │   ├── cli_commands.o
│   │   └── cli.o
│   ├── commands
│   │   ├── calls_cmd.o
│   │   ├── did_cmd.o
│   │   ├── module2_cmd.o
│   │   ├── monitor_cmd.o
│   │   ├── provider_cmd.o
│   │   ├── route_cmd.o
│   │   ├── sip_cmd.o
│   │   ├── stats_cmd.o
│   │   └── validation_cmd.o
│   ├── core
│   │   ├── config.o
│   │   ├── models.o
│   │   ├── server.o
│   │   └── utils.o
│   ├── db
│   │   ├── cache.o
│   │   └── database_pg.o
│   ├── freeswitch
│   │   ├── fs_generate_module2_dialplan.o
│   │   └── fs_xml_generator.o
│   ├── main.o
│   ├── router
│   │   ├── load_balancer.o
│   │   └── router.o
│   ├── sip
│   │   ├── freeswitch_handler.o
│   │   ├── sip_server_dynamic.o
│   │   └── sip_server_global.o
│   ├── utils
│   │   └── logger.o
│   └── validation
│       └── call_validator.o
├── CMakeLists.txt
├── configs
│   ├── config.json
│   ├── dialplan
│   │   └── router.xml
│   ├── dialplans
│   ├── dids
│   ├── freeswitch
│   │   ├── fs2_dialplan.xml
│   │   ├── fs2_sip_profile.xml
│   │   └── gateways
│   │       ├── fs1.xml
│   │       ├── fs3.xml
│   │       └── fs4.xml
│   ├── freeswitch_s2.json
│   ├── gateways
│   ├── production.json
│   ├── providers
│   └── routes
├── DEPLOYMENT.md
├── dialplan_test.sh
├── docs
├── examples
│   ├── routing_demo.sh
│   └── usage.sh
├── generate_dynamic_dialplan.sh
├── include
│   ├── api
│   │   └── handlers.h
│   ├── cli
│   │   ├── cli_commands.h
│   │   └── cli.h
│   ├── commands
│   │   ├── calls_cmd.h
│   │   ├── did_cmd.h
│   │   ├── module2_cmd.h
│   │   ├── monitor_cmd.h
│   │   ├── provider_cmd.h
│   │   ├── route_cmd.h
│   │   ├── sip_cmd.h
│   │   ├── stats_cmd.h
│   │   └── validation_cmd.h
│   ├── core
│   │   ├── cli.h
│   │   ├── common.h
│   │   ├── config.h
│   │   ├── logging.h
│   │   ├── models.h
│   │   └── server.h
│   ├── db
│   │   ├── cache.h
│   │   └── database.h
│   ├── freeswitch
│   │   └── fs_xml_generator.h
│   ├── router
│   │   ├── load_balancer.h
│   │   └── router.h
│   ├── sip
│   │   ├── esl_handler.h
│   │   ├── freeswitch_handler.h
│   │   └── sip_server.h
│   ├── utils
│   │   └── logger.h
│   └── validation
│       ├── call_validator.h
│       └── state_sync_service.h
├── logs
│   ├── router_daemon.log
│   ├── router.log
│   └── router_output.log
├── Makefile
├── Makefile.backup
├── Makefile.bak
├── Makefile.freeswitch
├── Makefile.safe
├── Makefile.simple
├── monitor_module2.sh
├── monitor_providers.sh
├── provider_route_enhanced.c
├── quick-fix
├── README.md
├── route_handler_corrected.lua
├── route_handler_validated.lua
├── router
├── router.backup.20250814_170040
├── run
├── scripts
│   ├── freeswitch-router.service
│   ├── route_handler_validated
│   ├── route_handler_with_validation.lua
│   ├── router.lua
│   ├── schema_enhanced.sql
│   ├── schema_module2.sql
│   ├── schema_pg.sql
│   ├── schema_pq.sql
│   ├── schema.sh
│   ├── schema.sql
│   ├── schema_validate.sql
│   ├── schema_validation.sql
│   └── setup_freeswitch_router.sh
├── setup_db.sh
├── setup_postgresql.sh
├── setup_postgres.sh
├── setup_validation.sh
├── src
│   ├── api
│   │   ├── handlers.c
│   │   ├── handlers.o
│   │   ├── route_handler.c
│   │   └── route_handler.o
│   ├── cli
│   │   ├── cli.c
│   │   ├── cli_commands.c
│   │   ├── cli_commands.o
│   │   └── cli.o
│   ├── CMakeLists.txt
│   ├── commands
│   │   ├── calls_cmd.c
│   │   ├── calls_cmd.o
│   │   ├── did_cmd.c
│   │   ├── did_cmd.o
│   │   ├── module2_cmd.c
│   │   ├── monitor_cmd.c
│   │   ├── monitor_cmd.c.bak2
│   │   ├── monitor_cmd.o
│   │   ├── monitor_fix.c
│   │   ├── monitor_fix.o
│   │   ├── provider_cmd.c
│   │   ├── provider_cmd.c.backup_20250815_020427
│   │   ├── provider_cmd.c.bak
│   │   ├── provider_cmd.o
│   │   ├── provider_mgmt.c
│   │   ├── provider_mgmt.o
│   │   ├── route_cmd.c
│   │   ├── route_cmd.c.backup
│   │   ├── route_cmd.c.backup_20250815_020427
│   │   ├── route_cmd.c.bak
│   │   ├── route_cmd.o
│   │   ├── sip_cmd.c
│   │   ├── sip_cmd.o
│   │   ├── stats_cmd.c
│   │   ├── stats_cmd.o
│   │   └── validation_cmd.c
│   ├── core
│   │   ├── config.c
│   │   ├── config.o
│   │   ├── models.c
│   │   ├── models.o
│   │   ├── server.c
│   │   ├── server.o
│   │   ├── utils.c
│   │   └── utils.o
│   ├── db
│   │   ├── cache.c
│   │   ├── cache.o
│   │   ├── database.c.backup
│   │   ├── database_pg.c
│   │   └── database_pg.o
│   ├── freeswitch
│   │   ├── freeswitch_integration.c
│   │   ├── freeswitch_integration.h
│   │   ├── freeswitch_integration.o
│   │   ├── fs_generate_module2_dialplan.c
│   │   ├── fs_router_api.c
│   │   ├── fs_xml_generator.c
│   │   ├── fs_xml_generator.c.backup
│   │   └── fs_xml_generator.o
│   ├── main.c
│   ├── main.c.bak
│   ├── main_module2_update.c
│   ├── main.o
│   ├── router
│   │   ├── load_balancer.c
│   │   ├── load_balancer.o
│   │   ├── router.c
│   │   ├── router.c.orig
│   │   ├── router.c.rej
│   │   └── router.o
│   ├── sip
│   │   ├── freeswitch_handler.c
│   │   ├── freeswitch_handler.o
│   │   ├── sip_server.c.backup
│   │   ├── sip_server_dynamic.c
│   │   ├── sip_server_dynamic.o
│   │   ├── sip_server_global.c
│   │   └── sip_server_global.o
│   ├── tests
│   ├── tests_disabled
│   │   └── test_router.c
│   ├── utils
│   │   ├── logger.c
│   │   └── logger.o
│   └── validation
│       ├── call_validator.c
│       └── state_sync_service.c
├── start_module2.sh
├── t
├── test_module2_complete.sh
├── test_module2.sh
└── test_sip.py

50 directories, 192 files
#include <microhttpd.h>
#include <string.h>
#include "core/logging.h"

int handle_api_request(struct MHD_Connection *connection, 
                      const char *url,
                      const char *method,
                      const char *upload_data,
                      size_t *upload_data_size) {
    
    // Suppress unused parameter warnings
    (void)url;
    (void)method;
    (void)upload_data;
    (void)upload_data_size;
    
    const char *response = "{\"status\":\"ok\"}";
    
    struct MHD_Response *mhd_response = MHD_create_response_from_buffer(
        strlen(response), (void*)response, MHD_RESPMEM_PERSISTENT);
    
    int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
    MHD_destroy_response(mhd_response);
    
    return ret;
}
#include <microhttpd.h>
#include <json-c/json.h>
#include <string.h>
#include "db/database.h"
#include "core/logging.h"

int handle_route_request(struct MHD_Connection *connection, const char *data) {
    struct json_object *request, *response;
    struct json_object *ani_obj, *dnis_obj, *provider_obj;
    const char *ani = NULL, *dnis = NULL, *provider = NULL;
    
    request = json_tokener_parse(data);
    if (!request) {
        return MHD_HTTP_BAD_REQUEST;
    }
    
    // Get JSON objects first, then extract strings
    if (json_object_object_get_ex(request, "ani", &ani_obj)) {
        ani = json_object_get_string(ani_obj);
    }
    if (json_object_object_get_ex(request, "dnis", &dnis_obj)) {
        dnis = json_object_get_string(dnis_obj);
    }
    if (json_object_object_get_ex(request, "provider", &provider_obj)) {
        provider = json_object_get_string(provider_obj);
    }
    
    // Log the request
    LOG_INFO("Route request: ANI=%s, DNIS=%s, Provider=%s", 
             ani ? ani : "null", 
             dnis ? dnis : "null", 
             provider ? provider : "null");
    
    // Query database for route
    database_t *db = get_database();
    const char *sql = "SELECT p.name FROM routes r "
                     "JOIN providers p ON r.provider_id = p.id "
                     "WHERE ? REGEXP r.pattern "
                     "ORDER BY r.priority LIMIT 1";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, dnis);
    
    db_result_t *result = db_execute_query(stmt);
    
    response = json_object_new_object();
    
    if (result && result->num_rows > 0) {
        const char *gateway = db_get_value(result, 0, 0);
        json_object_object_add(response, "gateway", json_object_new_string(gateway));
        json_object_object_add(response, "type", json_object_new_string("route"));
        json_object_object_add(response, "ani", json_object_new_string(ani ? ani : ""));
        json_object_object_add(response, "dnis", json_object_new_string(dnis ? dnis : ""));
    } else {
        json_object_object_add(response, "error", json_object_new_string("No route found"));
    }
    
    const char *response_str = json_object_to_json_string(response);
    
    struct MHD_Response *mhd_response = MHD_create_response_from_buffer(
        strlen(response_str), (void *)response_str, MHD_RESPMEM_MUST_COPY);
    
    MHD_add_response_header(mhd_response, "Content-Type", "application/json");
    
    int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
    
    MHD_destroy_response(mhd_response);
    json_object_put(response);
    json_object_put(request);
    if (result) db_free_result(result);
    db_finalize(stmt);
    
    return ret;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <readline/readline.h>
#include <readline/history.h>
#include "cli/cli.h"
#include "cli/cli_commands.h"
#include "core/logging.h"

// g_cli is now defined in main.c, not here
// Remove: cli_t *g_cli = NULL;
// Just declare it as extern since it's defined in main.c
extern cli_t *g_cli;

cli_t* cli_create(void) {
    cli_t *cli = calloc(1, sizeof(cli_t));
    if (!cli) return NULL;
    
    cli->running = true;
    // Don't set g_cli here since main.c manages it
    
    return cli;
}

void cli_destroy(cli_t *cli) {
    if (cli) {
        free(cli);
        // Don't set g_cli to NULL here since main.c manages it
    }
}

void cli_run(cli_t *cli) {
    char *line;
    char *argv[MAX_ARGS];
    int argc;
    
    printf("FreeSWITCH Router CLI v3.0\n");
    printf("Type 'help' for available commands\n");
    
    while (cli->running) {
        line = readline("fs-router> ");
        if (!line) break;
        
        if (strlen(line) > 0) {
            add_history(line);
            
            argc = 0;
            char *token = strtok(line, " ");
            while (token && argc < MAX_ARGS) {
                argv[argc++] = token;
                token = strtok(NULL, " ");
            }
            
            if (argc > 0) {
                cli_execute_command(argc, argv);
            }
        }
        
        free(line);
    }
}

void cli_stop(cli_t *cli) {
    if (cli) {
        cli->running = false;
    }
}
// src/cli/cli_commands.c - Updated with validation commands
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "cli/cli_commands.h"
#include "cli/cli.h"

// External command handlers
extern int cmd_provider(int argc, char *argv[]);
extern int cmd_route(int argc, char *argv[]);
extern int cmd_did(int argc, char *argv[]);
extern int cmd_monitor(int argc, char *argv[]);
extern int cmd_stats(int argc, char *argv[]);
extern int cmd_calls(int argc, char *argv[]);
extern int cmd_sip(int argc, char *argv[]);
extern int cmd_validation(int argc, char *argv[]);  // New validation command
extern int cmd_module2(int argc, char *argv[]);

int cli_execute_command(int argc, char *argv[]) {
    if (argc == 0) return 0;
    
    if (strcmp(argv[0], "help") == 0) {
        printf("\n╔════════════════════════════════════════════════════╗\n");
        printf("║         FreeSWITCH Router Commands                ║\n");
        printf("╚════════════════════════════════════════════════════╝\n\n");
        
        printf("Core Commands:\n");
        printf("  provider    Manage providers\n");
        printf("  route       Manage routes (S1→S2→S3→S2→S4)\n");
        printf("  did         Manage DIDs\n");
        printf("  calls       Manage calls\n");
        printf("\n");
        
        printf("Validation Commands:\n");
        printf("  validation  Call validation system\n");
        printf("              - status: Show validation status\n");
        printf("              - stats:  Show validation statistics\n");
        printf("              - rules:  Manage validation rules\n");
        printf("              - events: Show security events\n");
        printf("              - test:   Test validation for a call\n");
        printf("\n");
        
        printf("Monitoring Commands:\n");
        printf("  monitor     Monitor system\n");
        printf("  stats       Show statistics\n");
        printf("  sip         SIP server status\n");
        printf("\n");
        
        printf("System Commands:\n");
        printf("  exit/quit   Exit the CLI\n");
        printf("  help        Show this help message\n");
        printf("\n");
        
        printf("Examples:\n");
        printf("  provider add s1 10.0.0.1:5060 origin 100 ip:10.0.0.1\n");
        printf("  route add test_route s1 s3 s4 '1[2-9][0-9]{9}' 100\n");
        printf("  did add 18005551234 US\n");
        printf("  validation status\n");
        printf("  validation events\n");
        printf("\n");
        
        return 0;
    }
    
    if (strcmp(argv[0], "exit") == 0 || strcmp(argv[0], "quit") == 0) {
        printf("Exiting...\n");
        exit(0);
    }
    
    if (strcmp(argv[0], "provider") == 0) {
        return cmd_provider(argc, argv);
    }
    
    if (strcmp(argv[0], "route") == 0) {
        return cmd_route(argc, argv);
    }
    
    if (strcmp(argv[0], "did") == 0) {
        return cmd_did(argc, argv);
    }
    
    if (strcmp(argv[0], "monitor") == 0) {
        return cmd_monitor(argc, argv);
    }
    
    if (strcmp(argv[0], "stats") == 0) {
        return cmd_stats(argc, argv);
    }
    
    if (strcmp(argv[0], "calls") == 0) {
        return cmd_calls(argc, argv);
    }
    
    if (strcmp(argv[0], "sip") == 0) {
        return cmd_sip(argc, argv);
    }
    
    if (strcmp(argv[0], "validation") == 0) {
    
    if (strcmp(argv[0], "module2") == 0) {
        return cmd_module2(argc, argv);
    }
        return cmd_validation(argc, argv);
    }
    
    printf("Unknown command: %s\n", argv[0]);
    printf("Type 'help' for available commands\n");
    return -1;
}
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "commands/calls_cmd.h"
#include "db/database.h"
#include "core/logging.h"

int cmd_calls(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: calls <add|delete|list>\n");
        return -1;
    }
    
    if (strcmp(argv[1], "add") == 0) {
        return cmd_calls_add(argc, argv);
    } else if (strcmp(argv[1], "delete") == 0) {
        return cmd_calls_delete(argc, argv);
    } else if (strcmp(argv[1], "list") == 0) {
        return cmd_calls_list(argc, argv);
    }
    
    printf("Unknown calls command: %s\n", argv[1]);
    return -1;
}

int cmd_calls_add(int argc, char *argv[]) {
    if (argc < 5) {
        printf("Usage: calls add <from> <to> <provider>\n");
        return -1;
    }
    
    const char *from = argv[2];
    const char *to = argv[3];
    const char *provider = argv[4];
    
    printf("Simulating call from %s to %s via %s\n", from, to, provider);
    return 0;
}

int cmd_calls_delete(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: calls delete <call_id>\n");
        return -1;
    }
    
    printf("Deleting call %s\n", argv[2]);
    return 0;
}

int cmd_calls_list(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    const char *sql = "SELECT id, ani, dnis, provider, status, created_at "
                     "FROM calls WHERE status = 'active' "
                     "ORDER BY created_at DESC LIMIT 20";
    
    db_result_t *result = db_query(db, sql);
    if (!result) {
        printf("No active calls\n");
        return 0;
    }
    
    printf("\nActive Calls\n");
    printf("============\n");
    printf("%-10s %-15s %-15s %-20s %-10s\n", 
           "ID", "From", "To", "Provider", "Status");
    printf("%-10s %-15s %-15s %-20s %-10s\n", 
           "----------", "---------------", "---------------", 
           "--------------------", "----------");
    
    for (int i = 0; i < result->num_rows; i++) {
        printf("%-10s %-15s %-15s %-20s %-10s\n",
               db_get_value(result, i, 0),
               db_get_value(result, i, 1),
               db_get_value(result, i, 2),
               db_get_value(result, i, 3),
               db_get_value(result, i, 4));
    }
    
    db_free_result(result);
    return 0;
}

// Stub functions
int cmd_calls_show(int argc, char *argv[]) { return cmd_calls_list(argc, argv); }
int cmd_calls_test(int argc, char *argv[]) { (void)argc; (void)argv; return 0; }
// src/commands/did_cmd.c
// Complete DID Management with Module 2 Support

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "commands/did_cmd.h"
#include "db/database.h"
#include "core/logging.h"

// Forward declarations for internal functions
static int cmd_did_import_csv(int argc, char *argv[]);
static int cmd_did_list_enhanced(int argc, char *argv[]);

// ============================================================================
// Basic DID Management Functions
// ============================================================================

int cmd_did_add(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Usage: did add <number> <country> [provider]\n");
        printf("Example: did add 18005551234 US provider1\n");
        return -1;
    }
    
    const char *number = argv[2];
    const char *country = argv[3];
    const char *provider = (argc > 4) ? argv[4] : NULL;
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    int provider_id = 0;
    if (provider) {
        const char *sql = "SELECT id FROM providers WHERE name = ?";
        db_stmt_t *stmt = db_prepare(db, sql);
        db_bind_string(stmt, 1, provider);
        db_result_t *result = db_execute_query(stmt);
        
        if (!result || result->num_rows == 0) {
            printf("Provider '%s' not found\n", provider);
            if (result) db_free_result(result);
            db_finalize(stmt);
            return -1;
        }
        
        provider_id = atoi(db_get_value(result, 0, 0));
        db_free_result(result);
        db_finalize(stmt);
    }
    
    // Add DID to database
    const char *sql = "INSERT INTO dids (did, country, provider_id, in_use, active) "
                     "VALUES (?, ?, ?, false, true)";
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, number);
    db_bind_string(stmt, 2, country);
    if (provider_id > 0) {
        db_bind_int(stmt, 3, provider_id);
    } else {
        db_bind_int(stmt, 3, 0);
    }
    
    if (db_execute(stmt) < 0) {
        printf("Failed to add DID (may already exist)\n");
        db_finalize(stmt);
        return -1;
    }
    
    db_finalize(stmt);
    printf("DID '%s' added successfully (Country: %s)\n", number, country);
    return 0;
}

int cmd_did_delete(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: did delete <number>\n");
        return -1;
    }
    
    const char *number = argv[2];
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    const char *sql = "DELETE FROM dids WHERE did = ?";
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, number);
    
    if (db_execute(stmt) < 0) {
        printf("Failed to delete DID\n");
        db_finalize(stmt);
        return -1;
    }
    
    db_finalize(stmt);
    printf("DID '%s' deleted successfully\n", number);
    return 0;
}

int cmd_did_list(int argc, char *argv[]) {
    // Use enhanced listing
    return cmd_did_list_enhanced(argc, argv);
}

int cmd_did_show(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: did show <number>\n");
        return -1;
    }
    
    const char *number = argv[2];
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    const char *sql = "SELECT d.*, p.name as provider_name "
                     "FROM dids d "
                     "LEFT JOIN providers p ON d.provider_id = p.id "
                     "WHERE d.did = ?";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, number);
    db_result_t *result = db_execute_query(stmt);
    
    if (!result || result->num_rows == 0) {
        printf("DID '%s' not found\n", number);
        if (result) db_free_result(result);
        db_finalize(stmt);
        return -1;
    }
    
    printf("\nDID Details\n");
    printf("===========\n");
    for (int i = 0; i < result->num_cols; i++) {
        printf("%-20s: %s\n", result->columns[i], db_get_value(result, 0, i));
    }
    
    db_free_result(result);
    db_finalize(stmt);
    return 0;
}

int cmd_did_test(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    printf("DID test function - not implemented\n");
    return 0;
}

// ============================================================================
// Module 2 Enhanced Functions
// ============================================================================

static int cmd_did_import_csv(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Usage: did import <csv_file> <provider_name> [country]\n");
        printf("CSV Format: One DID number per line\n");
        printf("Example: did import dids.csv provider1 US\n");
        return -1;
    }
    
    const char *csv_file = argv[2];
    const char *provider_name = argv[3];
    const char *country = (argc > 4) ? argv[4] : "US";
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    // Get provider ID
    const char *provider_query = "SELECT id FROM providers WHERE name = ?";
    db_stmt_t *stmt = db_prepare(db, provider_query);
    db_bind_string(stmt, 1, provider_name);
    db_result_t *result = db_execute_query(stmt);
    
    if (!result || result->num_rows == 0) {
        printf("Provider '%s' not found\n", provider_name);
        printf("Please add the provider first:\n");
        printf("  provider add %s <host:port> <role> <capacity> <auth>\n", provider_name);
        if (result) db_free_result(result);
        db_finalize(stmt);
        return -1;
    }
    
    int provider_id = atoi(db_get_value(result, 0, 0));
    db_free_result(result);
    db_finalize(stmt);
    
    // Open CSV file
    FILE *fp = fopen(csv_file, "r");
    if (!fp) {
        printf("Failed to open CSV file: %s\n", csv_file);
        return -1;
    }
    
    char line[256];
    int imported = 0;
    int failed = 0;
    int skipped = 0;
    
    printf("Importing DIDs from %s...\n", csv_file);
    
    // Begin transaction for better performance
    db_query(db, "BEGIN TRANSACTION");
    
    while (fgets(line, sizeof(line), fp)) {
        // Remove newline and whitespace
        char *did = line;
        while (*did && (*did == ' ' || *did == '\t')) did++;
        char *end = did + strlen(did) - 1;
        while (end > did && (*end == '\n' || *end == '\r' || *end == ' ' || *end == '\t')) {
            *end = '\0';
            end--;
        }
        
        // Skip empty lines
        if (strlen(did) == 0) {
            continue;
        }
        
        // Skip comment lines
        if (did[0] == '#' || did[0] == '/') {
            skipped++;
            continue;
        }
        
        // Validate DID format (basic validation - digits only, 10-15 chars)
        int valid = 1;
        for (char *p = did; *p; p++) {
            if (!isdigit(*p)) {
                valid = 0;
                break;
            }
        }
        
        if (!valid || strlen(did) < 10 || strlen(did) > 15) {
            printf("  ✗ Invalid DID format: %s\n", did);
            failed++;
            continue;
        }
        
        // Insert DID into database
        const char *insert_query = 
            "INSERT INTO dids (did, country, provider_id, in_use, active) "
            "VALUES (?, ?, ?, false, true) "
            "ON CONFLICT (did) DO NOTHING";
        
        stmt = db_prepare(db, insert_query);
        db_bind_string(stmt, 1, did);
        db_bind_string(stmt, 2, country);
        db_bind_int(stmt, 3, provider_id);
        
        if (db_execute(stmt) == 0) {
            imported++;
            printf("  ✓ Imported: %s\n", did);
        } else {
            failed++;
            printf("  ✗ Failed or duplicate: %s\n", did);
        }
        
        db_finalize(stmt);
    }
    
    // Commit transaction
    db_query(db, "COMMIT");
    
    fclose(fp);
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║                 Import Summary                     ║\n");
    printf("╚════════════════════════════════════════════════════╝\n");
    printf("  Successfully imported: %d DIDs\n", imported);
    printf("  Failed/Duplicates: %d\n", failed);
    printf("  Skipped (comments/empty): %d\n", skipped);
    printf("  Provider: %s (ID: %d)\n", provider_name, provider_id);
    printf("  Country: %s\n", country);
    
    return 0;
}

static int cmd_did_list_enhanced(int argc, char *argv[]) {
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    // Parse filter options
    const char *filter_provider = NULL;
    const char *filter_status = NULL;
    
    for (int i = 2; i < argc; i++) {
        if (strcmp(argv[i], "--provider") == 0 && i + 1 < argc) {
            filter_provider = argv[++i];
        } else if (strcmp(argv[i], "--status") == 0 && i + 1 < argc) {
            filter_status = argv[++i];
        }
    }
    
    // Build query with filters
    char query[1024];
    snprintf(query, sizeof(query),
        "SELECT d.did, d.country, d.in_use, d.destination, "
        "p.name as provider_name, d.call_id, d.original_ani, "
        "d.allocated_at "
        "FROM dids d "
        "LEFT JOIN providers p ON d.provider_id = p.id "
        "WHERE d.active = true");
    
    if (filter_provider) {
        char filter[256];
        snprintf(filter, sizeof(filter), " AND p.name = '%s'", filter_provider);
        strcat(query, filter);
    }
    
    if (filter_status) {
        if (strcmp(filter_status, "in_use") == 0) {
            strcat(query, " AND d.in_use = true");
        } else if (strcmp(filter_status, "available") == 0) {
            strcat(query, " AND d.in_use = false");
        }
    }
    
    strcat(query, " ORDER BY p.name, d.country, d.did");
    
    db_result_t *result = db_query(db, query);
    if (!result || result->num_rows == 0) {
        printf("No DIDs found\n");
        if (result) db_free_result(result);
        return 0;
    }
    
    printf("\n╔════════════════════════════════════════════════════════════════════════════╗\n");
    printf("║                          DID Pool Management                               ║\n");
    printf("╚════════════════════════════════════════════════════════════════════════════╝\n\n");
    
    printf("%-20s %-10s %-15s %-10s %-20s %-30s\n",
           "DID", "Country", "Provider", "Status", "Destination", "Call Info");
    printf("%-20s %-10s %-15s %-10s %-20s %-30s\n",
           "--------------------", "----------", "---------------", "----------",
           "--------------------", "------------------------------");
    
    int total = 0, in_use = 0, available = 0;
    char current_provider[256] = "";
    
    for (int i = 0; i < result->num_rows; i++) {
        const char *did = db_get_value(result, i, 0);
        const char *country = db_get_value(result, i, 1);
        int is_in_use = strcmp(db_get_value(result, i, 2), "t") == 0;
        const char *destination = db_get_value(result, i, 3);
        const char *provider = db_get_value(result, i, 4);
        const char *call_id = db_get_value(result, i, 5);
        const char *original_ani = db_get_value(result, i, 6);
        
        // Group by provider
        if (provider && strcmp(current_provider, provider) != 0) {
            if (strlen(current_provider) > 0) {
                printf("\n");
            }
            strcpy(current_provider, provider);
        }
        
        char call_info[64] = "-";
        if (is_in_use && call_id && strlen(call_id) > 0) {
            snprintf(call_info, sizeof(call_info), "%.15s... ANI:%.10s",
                    call_id, original_ani ? original_ani : "N/A");
        }
        
        printf("%-20s %-10s %-15s %-10s %-20s %-30s\n",
               did,
               country ? country : "-",
               provider ? provider : "Unassigned",
               is_in_use ? "IN USE" : "Available",
               (destination && strlen(destination) > 0) ? destination : "-",
               call_info);
        
        total++;
        if (is_in_use) in_use++; else available++;
    }
    
    printf("\n");
    printf("╔════════════════════════════════════════════════════════════════════════════╗\n");
    printf("║ Summary: Total: %d | In Use: %d | Available: %d", total, in_use, available);
    // Pad to fill the box
    int padding = 77 - 30 - snprintf(NULL, 0, "%d | In Use: %d | Available: %d", total, in_use, available);
    for (int i = 0; i < padding; i++) printf(" ");
    printf("║\n");
    printf("╚════════════════════════════════════════════════════════════════════════════╝\n");
    
    // Show DIDs by provider summary
    printf("\nDIDs by Provider:\n");
    snprintf(query, sizeof(query),
        "SELECT p.name, COUNT(d.id) as total, "
        "SUM(CASE WHEN d.in_use THEN 1 ELSE 0 END) as in_use "
        "FROM providers p "
        "LEFT JOIN dids d ON p.id = d.provider_id AND d.active = true "
        "WHERE p.role = 'intermediate' "
        "GROUP BY p.name "
        "ORDER BY p.name");
    
    db_result_t *summary = db_query(db, query);
    if (summary && summary->num_rows > 0) {
        for (int i = 0; i < summary->num_rows; i++) {
            printf("  %s: %s DIDs (%s in use)\n",
                   db_get_value(summary, i, 0),
                   db_get_value(summary, i, 1),
                   db_get_value(summary, i, 2));
        }
        db_free_result(summary);
    }
    
    db_free_result(result);
    return 0;
}

// ============================================================================
// Main Command Handler - EXPORTED (NOT STATIC!)
// ============================================================================

int cmd_did(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: did <command> [options]\n");
        printf("\nCommands:\n");
        printf("  add <number> <country> [provider]     - Add single DID\n");
        printf("  import <csv_file> <provider> [country] - Import DIDs from CSV\n");
        printf("  list [--provider NAME] [--status in_use|available]\n");
        printf("  show <number>                          - Show DID details\n");
        printf("  delete <number>                        - Delete DID\n");
        printf("  release <number>                       - Release DID from active call\n");
        printf("\nModule 2 DID Management:\n");
        printf("  DIDs are used for dynamic call routing in S1→S2→S3→S2→S4 flow\n");
        printf("  DIDs must be assigned to intermediate providers (S3)\n");
        printf("\nCSV Format for import:\n");
        printf("  One DID number per line (10-15 digits)\n");
        printf("  Lines starting with # are treated as comments\n");
        printf("\nExamples:\n");
        printf("  did add 18005551234 US s3\n");
        printf("  did import dids.csv s3 US\n");
        printf("  did list --provider s3 --status available\n");
        return -1;
    }
    
    const char *command = argv[1];
    
    if (strcmp(command, "add") == 0) {
        return cmd_did_add(argc, argv);
    } else if (strcmp(command, "delete") == 0) {
        return cmd_did_delete(argc, argv);
    } else if (strcmp(command, "list") == 0) {
        return cmd_did_list(argc, argv);
    } else if (strcmp(command, "show") == 0) {
        return cmd_did_show(argc, argv);
    } else if (strcmp(command, "test") == 0) {
        return cmd_did_test(argc, argv);
    } else if (strcmp(command, "import") == 0) {
        return cmd_did_import_csv(argc, argv);
    } else if (strcmp(command, "release") == 0) {
        if (argc < 3) {
            printf("Usage: did release <number>\n");
            return -1;
        }
        
        const char *did_number = argv[2];
        database_t *db = get_database();
        if (!db) {
            printf("Database not available\n");
            return -1;
        }
        
        char query[512];
        snprintf(query, sizeof(query),
                "UPDATE dids SET in_use = false, destination = NULL, "
                "call_id = NULL, original_ani = NULL, allocated_at = NULL "
                "WHERE did = '%s'", did_number);
        
        db_result_t *result = db_query(db, query);
        if (result) {
            printf("DID %s released\n", did_number);
            db_free_result(result);
        } else {
            printf("Failed to release DID %s\n", did_number);
        }
        return 0;
    }
    
    printf("Unknown did command: %s\n", command);
    printf("Type 'did' for usage information\n");
    return -1;
}

// module2_cmd.c - Module 2 specific CLI commands
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "commands/module2_cmd.h"
#include "db/database.h"
#include "core/logging.h"

int cmd_module2(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: module2 <status|test|monitor|validate>\n");
        printf("\nCommands:\n");
        printf("  status                Show Module 2 system status\n");
        printf("  test <ani> <dnis>     Test call transformation\n");
        printf("  monitor               Monitor active transformations\n");
        printf("  validate <did>        Validate S1 origin for DID\n");
        return -1;
    }
    
    if (strcmp(argv[1], "status") == 0) {
        return cmd_module2_status(argc, argv);
    } else if (strcmp(argv[1], "test") == 0) {
        return cmd_module2_test(argc, argv);
    } else if (strcmp(argv[1], "monitor") == 0) {
        return cmd_module2_monitor(argc, argv);
    } else if (strcmp(argv[1], "validate") == 0) {
        return cmd_module2_validate(argc, argv);
    }
    
    printf("Unknown module2 command: %s\n", argv[1]);
    return -1;
}

int cmd_module2_status(int argc, char *argv[]) {
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║           Module 2 System Status                   ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    // Check active transformations
    db_result_t *result = db_query(db,
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN transformation_type = 'forward' THEN 1 ELSE 0 END) as forward, "
        "SUM(CASE WHEN transformation_type = 'return' THEN 1 ELSE 0 END) as return_count "
        "FROM call_transformations WHERE created_at > NOW() - INTERVAL '1 hour'");
    
    if (result && result->num_rows > 0) {
        printf("Transformations (Last Hour):\n");
        printf("  Total:   %s\n", db_get_value(result, 0, 0));
        printf("  Forward: %s (S1→S2→S3)\n", db_get_value(result, 0, 1));
        printf("  Return:  %s (S3→S2→S4)\n", db_get_value(result, 0, 2));
        db_free_result(result);
    }
    
    // Check S1 origin calls
    result = db_query(db,
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active, "
        "SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed "
        "FROM s1_origin_calls");
    
    if (result && result->num_rows > 0) {
        printf("\nS1 Origin Tracking:\n");
        printf("  Total:     %s\n", db_get_value(result, 0, 0));
        printf("  Active:    %s\n", db_get_value(result, 0, 1));
        printf("  Completed: %s\n", db_get_value(result, 0, 2));
        db_free_result(result);
    }
    
    // Check state synchronization
    result = db_query(db,
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN state_matched THEN 1 ELSE 0 END) as matched, "
        "SUM(CASE WHEN NOT state_matched THEN 1 ELSE 0 END) as mismatched "
        "FROM call_state_sync WHERE checked_at > NOW() - INTERVAL '5 minutes'");
    
    if (result && result->num_rows > 0) {
        printf("\nState Synchronization (Last 5 min):\n");
        printf("  Total Checks: %s\n", db_get_value(result, 0, 0));
        printf("  Matched:      %s\n", db_get_value(result, 0, 1));
        printf("  Mismatched:   %s\n", db_get_value(result, 0, 2));
        db_free_result(result);
    }
    
    // Check DIDs in use
    result = db_query(db,
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN in_use THEN 1 ELSE 0 END) as in_use "
        "FROM dids WHERE active = true");
    
    if (result && result->num_rows > 0) {
        int total = atoi(db_get_value(result, 0, 0));
        int in_use = atoi(db_get_value(result, 0, 1));
        int available = total - in_use;
        
        printf("\nDID Pool Status:\n");
        printf("  Total:     %d\n", total);
        printf("  In Use:    %d (%.1f%%)\n", in_use, 
               total > 0 ? (in_use * 100.0 / total) : 0);
        printf("  Available: %d (%.1f%%)\n", available,
               total > 0 ? (available * 100.0 / total) : 0);
        db_free_result(result);
    }
    
    return 0;
}

int cmd_module2_test(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Usage: module2 test <ani> <dnis>\n");
        return -1;
    }
    
    const char *ani = argv[2];
    const char *dnis = argv[3];
    database_t *db = get_database();
    
    printf("\nTesting Module 2 Transformation\n");
    printf("================================\n");
    printf("Original: ANI=%s, DNIS=%s\n\n", ani, dnis);
    
    // Test forward transformation
    char query[1024];
    snprintf(query, sizeof(query),
        "SELECT * FROM apply_call_transformation('test_%ld', 2, '%s', '%s', 'forward')",
        time(NULL), ani, dnis);
    
    db_result_t *result = db_query(db, query);
    if (result && result->num_rows > 0) {
        printf("Forward Transformation (S1→S2→S3):\n");
        printf("  ANI-1 (%s) → ANI-2 (%s)\n", ani, db_get_value(result, 0, 0));
        printf("  DNIS-1 (%s) → DID (%s)\n", dnis, db_get_value(result, 0, 1));
        
        const char *did = db_get_value(result, 0, 2);
        
        // Test return transformation
        if (did && strlen(did) > 0) {
            snprintf(query, sizeof(query),
                "SELECT * FROM apply_call_transformation('test_%ld', 3, '%s', '%s', 'return')",
                time(NULL), dnis, did);
            
            db_result_t *return_result = db_query(db, query);
            if (return_result && return_result->num_rows > 0) {
                printf("\nReturn Transformation (S3→S2→S4):\n");
                printf("  ANI-2 (%s) → ANI-1 (%s)\n", dnis, db_get_value(return_result, 0, 0));
                printf("  DID (%s) → DNIS-1 (%s)\n", did, db_get_value(return_result, 0, 1));
                db_free_result(return_result);
            }
        }
        
        db_free_result(result);
    } else {
        printf("Transformation failed (no available DIDs?)\n");
    }
    
    return 0;
}

int cmd_module2_monitor(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║        Module 2 Active Call Monitoring             ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    db_result_t *result = db_query(db,
        "SELECT * FROM module2_call_flow "
        "WHERE created_at > NOW() - INTERVAL '10 minutes' "
        "ORDER BY created_at DESC, stage LIMIT 20");
    
    if (result && result->num_rows > 0) {
        printf("%-15s %-20s %-15s %-15s %-10s\n",
               "Call ID", "Stage", "Original ANI", "DID", "Validated");
        printf("%-15s %-20s %-15s %-15s %-10s\n",
               "---------------", "--------------------", 
               "---------------", "---------------", "----------");
        
        for (int i = 0; i < result->num_rows; i++) {
            char call_id_short[16];
            strncpy(call_id_short, db_get_value(result, i, 0), 15);
            call_id_short[15] = '\0';
            
            printf("%-15s %-20s %-15s %-15s %-10s\n",
                   call_id_short,
                   db_get_value(result, i, 2), // stage_description
                   db_get_value(result, i, 3), // original_ani
                   db_get_value(result, i, 5), // assigned_did
                   strcmp(db_get_value(result, i, 8), "t") == 0 ? "Yes" : "No");
        }
        
        db_free_result(result);
    } else {
        printf("No active calls in the last 10 minutes\n");
    }
    
    return 0;
}

int cmd_module2_validate(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: module2 validate <did>\n");
        return -1;
    }
    
    const char *did = argv[2];
    database_t *db = get_database();
    
    char query[512];
    snprintf(query, sizeof(query),
        "SELECT validate_s1_origin('%s', '0.0.0.0')", did);
    
    db_result_t *result = db_query(db, query);
    if (result && result->num_rows > 0) {
        bool is_valid = strcmp(db_get_value(result, 0, 0), "t") == 0;
        
        if (is_valid) {
            printf("✓ DID %s has valid S1 origin\n", did);
            
            // Show details
            snprintf(query, sizeof(query),
                "SELECT s1_ip, original_ani, original_dnis, initiated_at "
                "FROM s1_origin_calls WHERE did_assigned = '%s' AND status = 'active'",
                did);
            
            db_result_t *details = db_query(db, query);
            if (details && details->num_rows > 0) {
                printf("  S1 IP:        %s\n", db_get_value(details, 0, 0));
                printf("  Original ANI: %s\n", db_get_value(details, 0, 1));
                printf("  Original DNIS: %s\n", db_get_value(details, 0, 2));
                printf("  Initiated:    %s\n", db_get_value(details, 0, 3));
                db_free_result(details);
            }
        } else {
            printf("✗ DID %s does NOT have valid S1 origin\n", did);
            printf("  Return calls would be rejected with 503\n");
        }
        
        db_free_result(result);
    }
    
    return 0;
}
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "commands/monitor_cmd.h"
#include "db/database.h"
#include "core/logging.h"

int cmd_monitor(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: monitor <add|delete|list|show|test>\n");
        return -1;
    }
    
    if (strcmp(argv[1], "show") == 0) {
        return cmd_monitor_show(argc, argv);
    }
    
    printf("Monitor command '%s' not implemented\n", argv[1]);
    return 0;
}

int cmd_monitor_show(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    printf("\nSystem Monitor\n");
    printf("==============\n");
    
    // Show database statistics
    database_t *db = get_database();
    if (db) {
        // Count active calls
        db_result_t *result = db_query(db, "SELECT COUNT(*) FROM calls WHERE status = 'active'");
        int active_calls = 0;
        if (result && result->num_rows > 0) {
            active_calls = atoi(db_get_value(result, 0, 0));
            db_free_result(result);
        }
        
        // Count providers
        result = db_query(db, "SELECT COUNT(*) FROM providers WHERE active = 1");
        int active_providers = 0;
        if (result && result->num_rows > 0) {
            active_providers = atoi(db_get_value(result, 0, 0));
            db_free_result(result);
        }
        
        // Count routes
        result = db_query(db, "SELECT COUNT(*) FROM routes WHERE active = 1");
        int active_routes = 0;
        if (result && result->num_rows > 0) {
            active_routes = atoi(db_get_value(result, 0, 0));
            db_free_result(result);
        }
        
        printf("Router Statistics:\n");
        printf("  Active Providers: %d\n", active_providers);
        printf("  Active Routes:    %d\n", active_routes);
        printf("  Active Calls:     %d\n", active_calls);
    }
    
    // Check if SIP port is listening
    FILE *fp = popen("netstat -tuln 2>/dev/null | grep -q ':5060 ' && echo 'Active' || echo 'Inactive'", "r");
    if (fp) {
        char status[32];
        if (fgets(status, sizeof(status), fp)) {
            status[strcspn(status, "\n")] = 0;
            printf("\nSIP Server Status:\n");
            printf("  Port 5060:       %s\n", status);
        }
        pclose(fp);
    }
    
    // Show recent call activity from database
    if (db) {
        printf("\nRecent Call Activity:\n");
        db_result_t *result = db_query(db, 
            "SELECT datetime(created_at, 'localtime') as time, ani, dnis, provider "
            "FROM calls ORDER BY created_at DESC LIMIT 5");
        
        if (result && result->num_rows > 0) {
            for (int i = 0; i < result->num_rows; i++) {
                printf("  %s: %s -> %s via %s\n",
                    db_get_value(result, i, 0),
                    db_get_value(result, i, 1),
                    db_get_value(result, i, 2),
                    db_get_value(result, i, 3));
            }
            db_free_result(result);
        } else {
            printf("  No recent calls\n");
        }
    }
    
    return 0;
}

// Stub functions
int cmd_monitor_add(int argc, char *argv[]) { 
    (void)argc; (void)argv; 
    printf("Monitor add not implemented\n");
    return 0; 
}

int cmd_monitor_delete(int argc, char *argv[]) { 
    (void)argc; (void)argv; 
    printf("Monitor delete not implemented\n");
    return 0; 
}

int cmd_monitor_list(int argc, char *argv[]) { 
    return cmd_monitor_show(argc, argv); 
}

int cmd_monitor_test(int argc, char *argv[]) { 
    (void)argc; (void)argv; 
    printf("Monitor test not implemented\n");
    return 0; 
}
#include <stdio.h>
#include <string.h>
#include "commands/monitor_cmd.h"
#include "sip/sip_server.h"

extern sip_server_t *g_sip_server;

// This file contains monitor command fixes only
// cmd_sip is defined in sip_cmd.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <uuid/uuid.h>
#include "commands/provider_cmd.h"
#include "db/database.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

// Generate UUID for provider
static char* generate_provider_uuid() {
    uuid_t uuid;
    char *uuid_str = malloc(37);
    
    uuid_generate(uuid);
    uuid_unparse_lower(uuid, uuid_str);
    
    return uuid_str;
}

int cmd_provider(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: provider <add|delete|list|show|reload>\n");
        return -1;
    }
    
    if (strcmp(argv[1], "add") == 0) {
        return cmd_provider_add(argc, argv);
    } else if (strcmp(argv[1], "delete") == 0) {
        return cmd_provider_delete(argc, argv);
    } else if (strcmp(argv[1], "list") == 0) {
        return cmd_provider_list(argc, argv);
    } else if (strcmp(argv[1], "show") == 0) {
        return cmd_provider_show(argc, argv);
    } else if (strcmp(argv[1], "reload") == 0) {
        return cmd_provider_reload(argc, argv);
    }
    
    printf("Unknown provider command: %s\n", argv[1]);
    return -1;
}

int cmd_provider_add(int argc, char *argv[]) {
    if (argc < 6) {
        printf("Usage: provider add <name> <host:port> <role> <capacity> <auth>\n");
        printf("  role: origin|intermediate|final\n");
        printf("  auth: ip:<allowed_ip> or user:<username>:<password>\n");
        return -1;
    }
    
    const char *name = argv[2];
    char host[256];
    int port = 5060;
    
    // Parse host:port
    char *colon = strchr(argv[3], ':');
    if (colon) {
        size_t host_len = colon - argv[3];
        if (host_len >= sizeof(host)) host_len = sizeof(host) - 1;
        strncpy(host, argv[3], host_len);
        host[host_len] = '\0';
        port = atoi(colon + 1);
    } else {
        strncpy(host, argv[3], sizeof(host) - 1);
        host[sizeof(host) - 1] = '\0';
    }
    
    const char *role = argv[4];
    int capacity = atoi(argv[5]);
    
    // Parse auth
    int auth_type = 0;  // 0=IP, 1=User/Pass
    char auth_data[512] = "";
    if (argc > 6) {
        if (strncmp(argv[6], "ip:", 3) == 0) {
            auth_type = 0;
            strncpy(auth_data, argv[6] + 3, sizeof(auth_data) - 1);
        } else if (strncmp(argv[6], "user:", 5) == 0) {
            auth_type = 1;
            strncpy(auth_data, argv[6] + 5, sizeof(auth_data) - 1);
        }
    }
    
    // Validate role
    if (strcmp(role, "origin") != 0 && 
        strcmp(role, "intermediate") != 0 && 
        strcmp(role, "final") != 0 &&
        strcmp(role, "general") != 0) {
        printf("Invalid role. Must be: origin, intermediate, final, or general\n");
        return -1;
    }
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not initialized\n");
        return -1;
    }
    
    // Generate UUID
    char *uuid = generate_provider_uuid();
    
    // Insert into database
    const char *sql = "INSERT INTO providers (uuid, name, host, port, role, capacity, "
                     "auth_type, auth_data, transport, active) "
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'udp', true)";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    if (!stmt) {
        free(uuid);
        printf("Failed to prepare statement\n");
        return -1;
    }
    
    db_bind_string(stmt, 1, uuid);
    db_bind_string(stmt, 2, name);
    db_bind_string(stmt, 3, host);
    db_bind_int(stmt, 4, port);
    db_bind_string(stmt, 5, role);
    db_bind_int(stmt, 6, capacity);
    db_bind_string(stmt, 7, auth_type == 0 ? "ip" : "userpass");
    db_bind_string(stmt, 8, auth_data);
    
    if (db_execute(stmt) < 0) {
        printf("Failed to add provider (may already exist)\n");
        db_finalize(stmt);
        free(uuid);
        return -1;
    }
    
    db_finalize(stmt);
    
    // Generate FreeSWITCH configuration
    fs_generate_provider_config(uuid, name, host, port, role, auth_type, auth_data);
    
    printf("Provider '%s' added successfully\n", name);
    printf("  UUID: %s\n", uuid);
    printf("  Role: %s\n", role);
    printf("  Host: %s:%d\n", host, port);
    printf("  Capacity: %d\n", capacity);
    
    free(uuid);
    return 0;
}

int cmd_provider_delete(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: provider delete <name>\n");
        return -1;
    }
    
    const char *name = argv[2];
    database_t *db = get_database();
    
    // Get provider info first
    const char *select_sql = "SELECT uuid, role FROM providers WHERE name = ?";
    db_stmt_t *select_stmt = db_prepare(db, select_sql);
    db_bind_string(select_stmt, 1, name);
    db_result_t *result = db_execute_query(select_stmt);
    
    if (!result || result->num_rows == 0) {
        printf("Provider '%s' not found\n", name);
        if (result) db_free_result(result);
        db_finalize(select_stmt);
        return -1;
    }
    
    const char *uuid = db_get_value(result, 0, 0);
    const char *role = db_get_value(result, 0, 1);
    
    // Remove FreeSWITCH configuration
    fs_remove_provider_config(uuid, role);
    
    db_free_result(result);
    db_finalize(select_stmt);
    
    // Delete from database
    const char *sql = "DELETE FROM providers WHERE name = ?";
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, name);
    
    if (db_execute(stmt) < 0) {
        printf("Failed to delete provider\n");
        db_finalize(stmt);
        return -1;
    }
    
    db_finalize(stmt);
    printf("Provider '%s' deleted successfully\n", name);
    
    // Reload FreeSWITCH
    fs_reload_config();
    
    return 0;
}

int cmd_provider_list(int argc, char *argv[]) {
    int verbose = 0;
    if (argc > 2 && strcmp(argv[2], "-v") == 0) {
        verbose = 1;
    }
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not initialized\n");
        return -1;
    }
    
    const char *sql = 
        "SELECT name, uuid, role, host, port, auth_type, capacity, "
        "current_calls, active "
        "FROM providers ORDER BY role, name";
    
    db_result_t *result = db_query(db, sql);
    if (!result || result->num_rows == 0) {
        printf("No providers found\n");
        if (result) db_free_result(result);
        return 0;
    }
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║     FreeSWITCH Dynamic Call Router v3.0           ║\n");
    printf("║     S1 → S2 → S3 → S2 → S4 Call Flow              ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    if (!verbose) {
        printf("%-20s %-12s %-20s %-6s %-10s %-8s %-8s %-8s\n", 
               "Name", "Role", "Host", "Port", "Auth", "Capacity", "Calls", "Status");
        printf("%-20s %-12s %-20s %-6s %-10s %-8s %-8s %-8s\n", 
               "--------------------", "------------", "--------------------", 
               "------", "----------", "--------", "--------", "--------");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("%-20s %-12s %-20s %-6s %-10s %-8s %-8s %-8s\n",
                   db_get_value(result, i, 0),  // name
                   db_get_value(result, i, 2),  // role
                   db_get_value(result, i, 3),  // host
                   db_get_value(result, i, 4),  // port
                   db_get_value(result, i, 5),  // auth_type
                   db_get_value(result, i, 6),  // capacity
                   db_get_value(result, i, 7),  // current_calls
                   strcmp(db_get_value(result, i, 8), "t") == 0 ? "Active" : "Inactive");
        }
    } else {
        printf("Providers (Verbose Mode)\n");
        printf("========================\n\n");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("Provider: %s\n", db_get_value(result, i, 0));
            printf("  UUID: %s\n", db_get_value(result, i, 1));
            printf("  Role: %s\n", db_get_value(result, i, 2));
            printf("  Host:Port: %s:%s\n", db_get_value(result, i, 3), db_get_value(result, i, 4));
            printf("  Auth Type: %s\n", db_get_value(result, i, 5));
            printf("  Capacity/Current: %s/%s\n", db_get_value(result, i, 6), db_get_value(result, i, 7));
            printf("  Status: %s\n", strcmp(db_get_value(result, i, 8), "t") == 0 ? "Active" : "Inactive");
            printf("\n");
        }
    }
    
    if (!verbose) {
        printf("\nUse './router provider list -v' for detailed view\n");
    }
    
    db_free_result(result);
    return 0;
}

int cmd_provider_show(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: provider show <name>\n");
        return -1;
    }
    
    const char *name = argv[2];
    database_t *db = get_database();
    
    const char *sql = "SELECT * FROM providers WHERE name = ?";
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, name);
    db_result_t *result = db_execute_query(stmt);
    
    if (!result || result->num_rows == 0) {
        printf("Provider '%s' not found\n", name);
        if (result) db_free_result(result);
        db_finalize(stmt);
        return -1;
    }
    
    printf("\nProvider Details\n");
    printf("================\n");
    
    for (int i = 0; i < result->num_cols; i++) {
        printf("%-20s: %s\n", result->columns[i], db_get_value(result, 0, i));
    }
    
    db_free_result(result);
    db_finalize(stmt);
    
    return 0;
}

int cmd_provider_reload(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    printf("Reloading all provider configurations...\n");
    
    if (fs_regenerate_all_providers() == 0) {
        printf("  ✓ Regenerated provider configs\n");
        fs_reload_config();
        printf("  ✓ Reloaded FreeSWITCH\n");
        printf("\nProvider configurations reloaded successfully\n");
    } else {
        printf("  ✗ Failed to reload providers\n");
        return -1;
    }
    
    return 0;
}

int cmd_provider_test(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    printf("Provider test not implemented\n");
    return 0;
}
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
// src/commands/route_cmd.c
// Complete implementation with enhanced functions properly integrated

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <uuid/uuid.h>
#include "commands/route_cmd.h"
#include "db/database.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

// External function declarations for Module 2
extern int fs_generate_module2_route_dialplan(void);
extern int fs_remove_route_dialplan(const char *route_id);
extern int fs_clear_dialplan_cache(void);
extern int fs_restore_dialplans_from_cache(void);

// Forward declarations for enhanced functions
static int cmd_route_add_enhanced(int argc, char *argv[]);
static int cmd_route_delete_enhanced(int argc, char *argv[]);
static int cmd_route_reload_enhanced(int argc, char *argv[]);
static int cmd_route_test_enhanced(int argc, char *argv[]);
static int cmd_route_cache(int argc, char *argv[]);

static char* generate_uuid(void) {
    uuid_t uuid;
    char *uuid_str = malloc(37);
    uuid_generate(uuid);
    uuid_unparse_lower(uuid, uuid_str);
    return uuid_str;
}

// Main route command dispatcher - USES ENHANCED VERSIONS
int cmd_route(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: route <add|delete|list|show|reload|test|cache> [options]\n");
        printf("\nCommands:\n");
        printf("  add <name> <origin> <intermediate> <final> <pattern> <priority>\n");
        printf("  delete <id|name>  - Delete route and its cached dialplan\n");
        printf("  list              - List all routes\n");
        printf("  show <id|name>    - Show route details\n");
        printf("  reload            - Regenerate all dialplans\n");
        printf("  test <number>     - Test number against routes\n");
        printf("  cache <clear|restore> - Manage dialplan cache\n");
        return -1;
    }
    
    // USE ENHANCED VERSIONS FOR ALL COMMANDS
    if (strcmp(argv[1], "add") == 0) {
        return cmd_route_add_enhanced(argc, argv);  // Enhanced version
    } else if (strcmp(argv[1], "delete") == 0) {
        return cmd_route_delete_enhanced(argc, argv);  // Enhanced version
    } else if (strcmp(argv[1], "list") == 0) {
        return cmd_route_list(argc, argv);
    } else if (strcmp(argv[1], "show") == 0) {
        return cmd_route_show(argc, argv);
    } else if (strcmp(argv[1], "reload") == 0) {
        return cmd_route_reload_enhanced(argc, argv);  // Enhanced version
    } else if (strcmp(argv[1], "test") == 0) {
        return cmd_route_test_enhanced(argc, argv);  // Enhanced version
    } else if (strcmp(argv[1], "cache") == 0) {
        return cmd_route_cache(argc, argv);
    }
    
    printf("Unknown route command: %s\n", argv[1]);
    return -1;
}

// Enhanced add command with full Module 2 support
static int cmd_route_add_enhanced(int argc, char *argv[]) {
    if (argc < 8) {
        printf("Usage: route add <name> <origin> <intermediate> <final> <pattern> <priority>\n");
        printf("\nModule 2 Call Flow:\n");
        printf("  S1 (origin) -> S2 (our server) -> S3 (intermediate) -> S2 -> S4 (final)\n");
        printf("\nTransformations:\n");
        printf("  S1->S2: Receive ANI-1/DNIS-1\n");
        printf("  S2->S3: Send DNIS-1(as ANI-2)/DID\n");
        printf("  S3->S2: Return ANI-2/DID\n");
        printf("  S2->S4: Send ANI-1/DNIS-1 (restored)\n");
        printf("\nExample:\n");
        printf("  route add us_route s1 s3 s4 '1[2-9][0-9]{9}' 100\n");
        return -1;
    }
    
    const char *name = argv[2];
    const char *origin_name = argv[3];
    const char *inter_name = argv[4];
    const char *final_name = argv[5];
    const char *pattern = argv[6];
    int priority = atoi(argv[7]);
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not initialized\n");
        return -1;
    }
    
    // Validate providers and check they have DIDs
    const char *provider_names[] = {origin_name, inter_name, final_name};
    const char *expected_roles[] = {"origin", "intermediate", "final"};
    int provider_ids[3] = {0, 0, 0};
    int did_counts[3] = {0, 0, 0};
    
    for (int i = 0; i < 3; i++) {
        const char *sql = "SELECT p.id, p.role, COUNT(d.id) as did_count "
                         "FROM providers p "
                         "LEFT JOIN dids d ON p.id = d.provider_id AND d.active = true "
                         "WHERE p.name = ? "
                         "GROUP BY p.id, p.role";
        
        db_stmt_t *stmt = db_prepare(db, sql);
        if (!stmt) continue;
        
        db_bind_string(stmt, 1, provider_names[i]);
        db_result_t *result = db_execute_query(stmt);
        
        if (!result || result->num_rows == 0) {
            printf("Error: Provider '%s' not found\n", provider_names[i]);
            if (result) db_free_result(result);
            db_finalize(stmt);
            return -1;
        }
        
        provider_ids[i] = atoi(db_get_value(result, 0, 0));
        const char *actual_role = db_get_value(result, 0, 1);
        did_counts[i] = atoi(db_get_value(result, 0, 2));
        
        // Check role
        if (strcmp(actual_role, expected_roles[i]) != 0 && strcmp(actual_role, "general") != 0) {
            printf("Warning: Provider '%s' has role '%s', expected '%s'\n",
                   provider_names[i], actual_role, expected_roles[i]);
        }
        
        // Check DIDs for intermediate provider (required for Module 2)
        if (i == 1 && did_counts[i] == 0) {
            printf("Error: Intermediate provider '%s' has no DIDs available\n", inter_name);
            printf("Please add DIDs first using: did add <number> <country> %s\n", inter_name);
            printf("Or import multiple: did import <csv_file> %s\n", inter_name);
            db_free_result(result);
            db_finalize(stmt);
            return -1;
        }
        
        db_free_result(result);
        db_finalize(stmt);
    }
    
    // Check for duplicate route name
    const char *check_sql = "SELECT id FROM routes WHERE name = ?";
    db_stmt_t *check_stmt = db_prepare(db, check_sql);
    if (check_stmt) {
        db_bind_string(check_stmt, 1, name);
        db_result_t *check_result = db_execute_query(check_stmt);
        if (check_result && check_result->num_rows > 0) {
            printf("Error: Route '%s' already exists\n", name);
            db_free_result(check_result);
            db_finalize(check_stmt);
            return -1;
        }
        if (check_result) db_free_result(check_result);
        db_finalize(check_stmt);
    }
    
    // Generate UUID for the route
    char *uuid = generate_uuid();
    
    // Insert route into database
    const char *sql = "INSERT INTO routes (uuid, name, pattern, origin_provider_id, "
                     "intermediate_provider_id, final_provider_id, priority, active) "
                     "VALUES (?, ?, ?, ?, ?, ?, ?, true)";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    if (!stmt) {
        printf("Failed to prepare statement\n");
        free(uuid);
        return -1;
    }
    
    db_bind_string(stmt, 1, uuid);
    db_bind_string(stmt, 2, name);
    db_bind_string(stmt, 3, pattern);
    db_bind_int(stmt, 4, provider_ids[0]);
    db_bind_int(stmt, 5, provider_ids[1]);
    db_bind_int(stmt, 6, provider_ids[2]);
    db_bind_int(stmt, 7, priority);
    
    if (db_execute(stmt) < 0) {
        printf("Failed to add route to database\n");
        db_finalize(stmt);
        free(uuid);
        return -1;
    }
    
    db_finalize(stmt);
    
    printf("Route '%s' added successfully\n", name);
    printf("  UUID: %s\n", uuid);
    printf("  Module 2 Call Flow:\n");
    printf("    S1 (%s) -> S2 (transforms ANI/DNIS)\n", origin_name);
    printf("    S2 -> S3 (%s) with DNIS-1/DID\n", inter_name);
    printf("    S3 -> S2 (returns with ANI-2/DID)\n");
    printf("    S2 -> S4 (%s) with restored ANI-1/DNIS-1\n", final_name);
    printf("  Pattern: %s\n", pattern);
    printf("  Priority: %d\n", priority);
    printf("  Available DIDs in %s: %d\n", inter_name, did_counts[1]);
    
    printf("\nGenerating FreeSWITCH dialplan with caching...\n");
    
    // CALL THE DIALPLAN GENERATION FUNCTION
    if (fs_generate_module2_route_dialplan() == 0) {
        printf("  ✓ Generated and cached route dialplan\n");
        printf("  ✓ Generated Lua handler scripts\n");
        printf("  ✓ Reloading FreeSWITCH...\n");
        fs_reload_config();
        printf("\nRoute is now active and ready to handle Module 2 call flow\n");
    } else {
        printf("  ✗ Failed to generate dialplan\n");
    }
    
    free(uuid);
    return 0;
}

// Enhanced delete command
static int cmd_route_delete_enhanced(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: route delete <id|name>\n");
        return -1;
    }
    
    const char *identifier = argv[2];
    database_t *db = get_database();
    
    // Get route info
    char query[512];
    if (atoi(identifier) > 0) {
        snprintf(query, sizeof(query), 
                "SELECT id, name, uuid FROM routes WHERE id = %d", atoi(identifier));
    } else {
        snprintf(query, sizeof(query), 
                "SELECT id, name, uuid FROM routes WHERE name = '%s'", identifier);
    }
    
    db_result_t *result = db_query(db, query);
    
    if (!result || result->num_rows == 0) {
        printf("Route '%s' not found\n", identifier);
        if (result) db_free_result(result);
        return -1;
    }
    
    const char *route_id = db_get_value(result, 0, 0);
    const char *route_name = db_get_value(result, 0, 1);
    
    printf("Deleting route '%s' (ID: %s)...\n", route_name, route_id);
    
    // Remove dialplan from cache and filesystem
    fs_remove_route_dialplan(route_id);
    printf("  ✓ Removed cached dialplan\n");
    
    // Delete from database
    snprintf(query, sizeof(query), "DELETE FROM routes WHERE id = %s", route_id);
    db_query(db, query);
    
    db_free_result(result);
    
    printf("Route '%s' deleted successfully\n", route_name);
    
    // Regenerate dialplans
    printf("Regenerating remaining dialplans...\n");
    fs_generate_module2_route_dialplan();
    fs_reload_config();
    
    return 0;
}

// Enhanced reload command
static int cmd_route_reload_enhanced(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    printf("Reloading all route configurations for Module 2...\n");
    
    // Clear cache first if requested
    if (argc > 2 && strcmp(argv[2], "--clear-cache") == 0) {
        fs_clear_dialplan_cache();
        printf("  ✓ Cleared dialplan cache\n");
    }
    
    if (fs_generate_module2_route_dialplan() == 0) {
        printf("  ✓ Regenerated route dialplans with caching\n");
        printf("  ✓ Regenerated Lua scripts\n");
        fs_reload_config();
        printf("  ✓ Reloaded FreeSWITCH\n");
        printf("\nModule 2 route configurations reloaded successfully\n");
    } else {
        printf("  ✗ Failed to reload routes\n");
        return -1;
    }
    
    return 0;
}

// Enhanced test command
static int cmd_route_test_enhanced(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: route test <number>\n");
        printf("Tests which route would handle the given number\n");
        return -1;
    }
    
    const char *test_number = argv[2];
    database_t *db = get_database();
    
    printf("\nTesting number: %s\n", test_number);
    printf("=====================================\n");
    
    // Find matching routes
    const char *query = 
        "SELECT r.name, r.pattern, r.priority, "
        "p1.name as origin, p2.name as intermediate, p3.name as final, "
        "(SELECT COUNT(*) FROM dids WHERE provider_id = p2.id AND active = true AND in_use = false) as available_dids "
        "FROM routes r "
        "JOIN providers p1 ON r.origin_provider_id = p1.id "
        "JOIN providers p2 ON r.intermediate_provider_id = p2.id "
        "JOIN providers p3 ON r.final_provider_id = p3.id "
        "WHERE r.active = true "
        "ORDER BY r.priority DESC";
    
    db_result_t *result = db_query(db, query);
    if (!result) {
        printf("No routes configured\n");
        return 0;
    }
    
    int found = 0;
    for (int i = 0; i < result->num_rows; i++) {
        const char *pattern = db_get_value(result, i, 1);
        
        // Simple pattern matching (would need regex in production)
        int matches = 0;
        if (strstr(pattern, test_number) || strcmp(pattern, ".*") == 0) {
            matches = 1;
        }
        
        if (matches) {
            if (!found) {
                printf("Matching route found:\n");
            }
            found++;
            
            printf("\nRoute: %s (Priority: %s)\n", 
                   db_get_value(result, i, 0),
                   db_get_value(result, i, 2));
            printf("  Pattern: %s\n", pattern);
            printf("  Module 2 Call Flow:\n");
            printf("    1. S1 (%s) sends ANI-1/DNIS-1 to S2\n", 
                   db_get_value(result, i, 3));
            printf("    2. S2 allocates DID, transforms to DNIS-1/DID\n");
            printf("    3. S2 sends to S3 (%s)\n", 
                   db_get_value(result, i, 4));
            printf("    4. S3 returns ANI-2/DID to S2\n");
            printf("    5. S2 releases DID, restores ANI-1/DNIS-1\n");
            printf("    6. S2 sends to S4 (%s)\n", 
                   db_get_value(result, i, 5));
            printf("  Available DIDs: %s\n", 
                   db_get_value(result, i, 6));
            
            break; // Show only the highest priority match
        }
    }
    
    if (!found) {
        printf("No matching route found for %s\n", test_number);
    }
    
    db_free_result(result);
    return 0;
}

// Cache management command
static int cmd_route_cache(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: route cache <clear|restore|status>\n");
        return -1;
    }
    
    if (strcmp(argv[2], "clear") == 0) {
        fs_clear_dialplan_cache();
        printf("Dialplan cache cleared\n");
    } else if (strcmp(argv[2], "restore") == 0) {
        fs_restore_dialplans_from_cache();
        printf("Dialplans restored from cache\n");
        fs_reload_config();
    } else if (strcmp(argv[2], "status") == 0) {
        // Show cache status
        printf("Cache directory: /opt/freeswitch-router/cache/dialplans\n");
        system("ls -la /opt/freeswitch-router/cache/dialplans/*.xml 2>/dev/null | wc -l | xargs printf 'Cached dialplans: %s\\n'");
    } else {
        printf("Unknown cache command: %s\n", argv[2]);
        return -1;
    }
    
    return 0;
}

// List command
int cmd_route_list(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not initialized\n");
        return -1;
    }
    
    const char *sql = 
        "SELECT r.id, r.name, "
        "p1.name as origin, p2.name as intermediate, p3.name as final, "
        "r.pattern, r.priority, r.active "
        "FROM routes r "
        "LEFT JOIN providers p1 ON r.origin_provider_id = p1.id "
        "LEFT JOIN providers p2 ON r.intermediate_provider_id = p2.id "
        "LEFT JOIN providers p3 ON r.final_provider_id = p3.id "
        "ORDER BY r.priority DESC, r.name";
    
    db_result_t *result = db_query(db, sql);
    if (!result || result->num_rows == 0) {
        printf("No routes configured\n");
        if (result) db_free_result(result);
        return 0;
    }
    
    printf("\nRoutes (S1 → S2 → S3 → S2 → S4 flow)\n");
    printf("=====================================\n");
    printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s\n", 
           "ID", "Name", "Origin", "Intermediate", "Final", "Pattern", "Priority", "Status");
    printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s\n", 
           "-----", "--------------------", "------------", "------------", 
           "------------", "-------------------------", "--------", "--------");
    
    for (int i = 0; i < result->num_rows; i++) {
        const char *id = db_get_value(result, i, 0);
        const char *name = db_get_value(result, i, 1);
        const char *origin = db_get_value(result, i, 2);
        const char *inter = db_get_value(result, i, 3);
        const char *final = db_get_value(result, i, 4);
        const char *pattern = db_get_value(result, i, 5);
        const char *priority = db_get_value(result, i, 6);
        int active = strcmp(db_get_value(result, i, 7), "t") == 0;
        
        char pattern_display[26];
        if (strlen(pattern) > 25) {
            strncpy(pattern_display, pattern, 22);
            strcpy(pattern_display + 22, "...");
        } else {
            strcpy(pattern_display, pattern);
        }
        
        printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s\n",
               id, name, 
               origin ? origin : "-",
               inter ? inter : "-",
               final ? final : "-",
               pattern_display, priority,
               active ? "Active" : "Inactive");
    }
    
    printf("\nTotal routes: %d\n", result->num_rows);
    db_free_result(result);
    
    return 0;
}

// Show command
int cmd_route_show(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: route show <id|name>\n");
        return -1;
    }
    
    const char *identifier = argv[2];
    database_t *db = get_database();
    
    char query[512];
    if (atoi(identifier) > 0) {
        snprintf(query, sizeof(query), 
                "SELECT * FROM routes WHERE id = %d", atoi(identifier));
    } else {
        snprintf(query, sizeof(query), 
                "SELECT * FROM routes WHERE name = '%s'", identifier);
    }
    
    db_result_t *result = db_query(db, query);
    
    if (!result || result->num_rows == 0) {
        printf("Route '%s' not found\n", identifier);
        if (result) db_free_result(result);
        return -1;
    }
    
    printf("\nRoute Details\n");
    printf("=============\n");
    
    // Display all fields
    for (int i = 0; i < result->num_cols; i++) {
        printf("%-20s: %s\n", result->columns[i], db_get_value(result, 0, i));
    }
    
    db_free_result(result);
    return 0;
}

// Stub for backward compatibility
int cmd_route_add(int argc, char *argv[]) {
    return cmd_route_add_enhanced(argc, argv);
}

int cmd_route_delete(int argc, char *argv[]) {
    return cmd_route_delete_enhanced(argc, argv);
}

int cmd_route_test(int argc, char *argv[]) {
    return cmd_route_test_enhanced(argc, argv);
}

int cmd_route_reload(int argc, char *argv[]) {
    return cmd_route_reload_enhanced(argc, argv);
}
#include <stdio.h>
#include <string.h>
#include "db/database.h"

int cmd_sip(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: sip <status|stats>\n");
        return -1;
    }
    
    if (strcmp(argv[1], "status") == 0 || strcmp(argv[1], "stats") == 0) {
        printf("\nSIP Server Status\n");
        printf("=================\n");
        printf("Status: Active\n");
        printf("Port: 5060\n");
        printf("Routing Mode: S1→S2→S3→S2→S4\n");
        
        database_t *db = get_database();
        if (db) {
            db_result_t *result = db_query(db, "SELECT COUNT(*) FROM active_calls");
            if (result && result->num_rows > 0) {
                printf("Active Calls: %s\n", db_get_value(result, 0, 0));
                db_free_result(result);
            }
        }
        
        return 0;
    }
    
    printf("Unknown sip command: %s\n", argv[1]);
    return -1;
}
#include <stdio.h>
#include <string.h>
#include "commands/stats_cmd.h"
#include "db/database.h"
#include "core/logging.h"

int cmd_stats(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    
    printf("\nSystem Statistics\n");
    printf("=================\n");
    
    // Provider stats
    db_result_t *result = db_query(db, "SELECT COUNT(*) FROM providers WHERE active = 1");
    if (result) {
        printf("Active Providers: %s\n", db_get_value(result, 0, 0));
        db_free_result(result);
    }
    
    // Route stats
    result = db_query(db, "SELECT COUNT(*) FROM routes");
    if (result) {
        printf("Configured Routes: %s\n", db_get_value(result, 0, 0));
        db_free_result(result);
    }
    
    // DID stats
    result = db_query(db, "SELECT COUNT(*) FROM dids WHERE active = 1");
    if (result) {
        printf("Active DIDs: %s\n", db_get_value(result, 0, 0));
        db_free_result(result);
    }
    
    // Call stats
    result = db_query(db, "SELECT COUNT(*) FROM calls WHERE status = 'active'");
    if (result) {
        printf("Active Calls: %s\n", db_get_value(result, 0, 0));
        db_free_result(result);
    }
    
    return 0;
}

// Stub functions for header compatibility
int cmd_stats_add(int argc, char *argv[]) { (void)argc; (void)argv; return 0; }
int cmd_stats_delete(int argc, char *argv[]) { (void)argc; (void)argv; return 0; }
int cmd_stats_list(int argc, char *argv[]) { return cmd_stats(argc, argv); }
int cmd_stats_show(int argc, char *argv[]) { return cmd_stats(argc, argv); }
int cmd_stats_test(int argc, char *argv[]) { (void)argc; (void)argv; return 0; }
// src/commands/validation_cmd.c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "commands/validation_cmd.h"
#include "validation/call_validator.h"
#include "db/database.h"
#include "core/logging.h"

extern call_validator_t *g_validator;  // Defined in main.c

int cmd_validation(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: validation <status|stats|rules|events|test>\n");
        printf("\nCommands:\n");
        printf("  status              Show validation system status\n");
        printf("  stats               Show validation statistics\n");
        printf("  rules               Manage validation rules\n");
        printf("  events              Show recent security events\n");
        printf("  test                Test validation with live call data\n");
        return -1;
    }
    
    if (strcmp(argv[1], "status") == 0) {
        return cmd_validation_status(argc, argv);
    } else if (strcmp(argv[1], "stats") == 0) {
        return cmd_validation_stats(argc, argv);
    } else if (strcmp(argv[1], "rules") == 0) {
        return cmd_validation_rules(argc, argv);
    } else if (strcmp(argv[1], "events") == 0) {
        return cmd_validation_events(argc, argv);
    } else if (strcmp(argv[1], "test") == 0) {
        return cmd_validation_test(argc, argv);
    }
    
    printf("Unknown validation command: %s\n", argv[1]);
    return -1;
}

int cmd_validation_status(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    if (!g_validator) {
        printf("Validation system not initialized\n");
        return -1;
    }
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║          Call Validation System Status             ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    // Get validation statistics
    uint64_t total, successful, failed, diverted;
    get_validation_stats(g_validator, &total, &successful, &failed, &diverted);
    
    printf("Overall Statistics:\n");
    printf("  Total Validations:     %lu\n", total);
    printf("  Successful:            %lu (%.1f%%)\n", 
           successful, total > 0 ? (successful * 100.0 / total) : 0);
    printf("  Failed:                %lu (%.1f%%)\n", 
           failed, total > 0 ? (failed * 100.0 / total) : 0);
    printf("  Diverted Calls:        %lu\n", diverted);
    printf("\n");
    
    // Show active validations from database
    const char *active_query = 
        "SELECT call_id, origin_ani, origin_dnis, current_state, "
        "created_at, validation_status "
        "FROM call_validations "
        "WHERE validation_status = 'active' "
        "ORDER BY created_at DESC LIMIT 10";
    
    db_result_t *result = db_query(db, active_query);
    if (result && result->num_rows > 0) {
        printf("Active Validations:\n");
        printf("%-30s %-15s %-15s %-10s %-20s\n",
               "Call ID", "ANI", "DNIS", "State", "Started");
        printf("%-30s %-15s %-15s %-10s %-20s\n",
               "------------------------------", "---------------", 
               "---------------", "----------", "--------------------");
        
        for (int i = 0; i < result->num_rows; i++) {
            const char *state_str[] = {"", "ORIG", "RING", "ANS", "HUNG", "FAIL", "DIV"};
            int state = atoi(db_get_value(result, i, 3));
            
            printf("%-30s %-15s %-15s %-10s %-20s\n",
                   db_get_value(result, i, 0),  // call_id
                   db_get_value(result, i, 1),  // ani
                   db_get_value(result, i, 2),  // dnis
                   state_str[state],             // state
                   db_get_value(result, i, 4));  // created_at
        }
        db_free_result(result);
    } else {
        printf("No active validations\n");
    }
    
    printf("\n");
    
    // Show validation rules status
    const char *rules_query = 
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN enabled THEN 1 ELSE 0 END) as enabled "
        "FROM call_validation_rules";
    
    result = db_query(db, rules_query);
    if (result && result->num_rows > 0) {
        printf("Validation Rules:\n");
        printf("  Total Rules:           %s\n", db_get_value(result, 0, 0));
        printf("  Enabled Rules:         %s\n", db_get_value(result, 0, 1));
        db_free_result(result);
    }
    
    return 0;
}

int cmd_validation_stats(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║         Call Validation Statistics                ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    // Hourly statistics
    const char *hourly_query = 
        "SELECT DATE_TRUNC('hour', checked_at) as hour, "
        "COUNT(*) as total, "
        "SUM(CASE WHEN passed THEN 1 ELSE 0 END) as passed, "
        "AVG(CASE WHEN passed THEN 100 ELSE 0 END) as success_rate "
        "FROM validation_checkpoints "
        "WHERE checked_at > NOW() - INTERVAL '24 hours' "
        "GROUP BY DATE_TRUNC('hour', checked_at) "
        "ORDER BY hour DESC LIMIT 24";
    
    db_result_t *result = db_query(db, hourly_query);
    if (result && result->num_rows > 0) {
        printf("Hourly Validation Performance (Last 24 Hours):\n");
        printf("%-20s %-10s %-10s %-15s\n",
               "Hour", "Total", "Passed", "Success Rate");
        printf("%-20s %-10s %-10s %-15s\n",
               "--------------------", "----------", "----------", "---------------");
        
        for (int i = 0; i < result->num_rows && i < 10; i++) {
            printf("%-20s %-10s %-10s %6.1f%%\n",
                   db_get_value(result, i, 0),
                   db_get_value(result, i, 1),
                   db_get_value(result, i, 2),
                   atof(db_get_value(result, i, 3)));
        }
        db_free_result(result);
    }
    
    printf("\n");
    
    // Checkpoint statistics
    const char *checkpoint_query = 
        "SELECT checkpoint_name, COUNT(*) as total, "
        "SUM(CASE WHEN passed THEN 1 ELSE 0 END) as passed, "
        "AVG(CASE WHEN passed THEN 100 ELSE 0 END) as success_rate "
        "FROM validation_checkpoints "
        "WHERE checked_at > NOW() - INTERVAL '1 hour' "
        "GROUP BY checkpoint_name "
        "ORDER BY total DESC";
    
    result = db_query(db, checkpoint_query);
    if (result && result->num_rows > 0) {
        printf("Checkpoint Performance (Last Hour):\n");
        printf("%-30s %-10s %-10s %-15s\n",
               "Checkpoint", "Total", "Passed", "Success Rate");
        printf("%-30s %-10s %-10s %-15s\n",
               "------------------------------", "----------", "----------", "---------------");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("%-30s %-10s %-10s %6.1f%%\n",
                   db_get_value(result, i, 0),
                   db_get_value(result, i, 1),
                   db_get_value(result, i, 2),
                   atof(db_get_value(result, i, 3)));
        }
        db_free_result(result);
    }
    
    // Failed validation reasons
    const char *failures_query = 
        "SELECT failure_reason, COUNT(*) as count "
        "FROM validation_checkpoints "
        "WHERE passed = false AND failure_reason IS NOT NULL "
        "AND checked_at > NOW() - INTERVAL '1 hour' "
        "GROUP BY failure_reason "
        "ORDER BY count DESC LIMIT 10";
    
    result = db_query(db, failures_query);
    if (result && result->num_rows > 0) {
        printf("\nTop Failure Reasons (Last Hour):\n");
        printf("%-50s %-10s\n", "Reason", "Count");
        printf("%-50s %-10s\n", 
               "--------------------------------------------------", "----------");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("%-50s %-10s\n",
                   db_get_value(result, i, 0),
                   db_get_value(result, i, 1));
        }
        db_free_result(result);
    }
    
    return 0;
}

int cmd_validation_rules(int argc, char *argv[]) {
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    if (argc < 3) {
        // List all rules
        const char *query = 
            "SELECT id, rule_name, rule_type, priority, enabled "
            "FROM call_validation_rules "
            "ORDER BY priority DESC, rule_name";
        
        db_result_t *result = db_query(db, query);
        if (result && result->num_rows > 0) {
            printf("\nValidation Rules:\n");
            printf("%-5s %-40s %-20s %-10s %-10s\n",
                   "ID", "Rule Name", "Type", "Priority", "Enabled");
            printf("%-5s %-40s %-20s %-10s %-10s\n",
                   "-----", "----------------------------------------",
                   "--------------------", "----------", "----------");
            
            for (int i = 0; i < result->num_rows; i++) {
                printf("%-5s %-40s %-20s %-10s %-10s\n",
                       db_get_value(result, i, 0),
                       db_get_value(result, i, 1),
                       db_get_value(result, i, 2),
                       db_get_value(result, i, 3),
                       strcmp(db_get_value(result, i, 4), "t") == 0 ? "Yes" : "No");
            }
            db_free_result(result);
        } else {
            printf("No validation rules configured\n");
        }
        
        printf("\nUsage: validation rules <enable|disable> <rule_id>\n");
        return 0;
    }
    
    if (strcmp(argv[2], "enable") == 0 && argc > 3) {
        int rule_id = atoi(argv[3]);
        char query[256];
        snprintf(query, sizeof(query),
                "UPDATE call_validation_rules SET enabled = true WHERE id = %d",
                rule_id);
        
        if (db_query(db, query)) {
            printf("Rule %d enabled\n", rule_id);
        } else {
            printf("Failed to enable rule %d\n", rule_id);
        }
    } else if (strcmp(argv[2], "disable") == 0 && argc > 3) {
        int rule_id = atoi(argv[3]);
        char query[256];
        snprintf(query, sizeof(query),
                "UPDATE call_validation_rules SET enabled = false WHERE id = %d",
                rule_id);
        
        if (db_query(db, query)) {
            printf("Rule %d disabled\n", rule_id);
        } else {
            printf("Failed to disable rule %d\n", rule_id);
        }
    }
    
    return 0;
}

int cmd_validation_events(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    printf("\n╔════════════════════════════════════════════════════╗\n");
    printf("║            Security Events Log                    ║\n");
    printf("╚════════════════════════════════════════════════════╝\n\n");
    
    const char *query = 
        "SELECT event_type, severity, call_id, source_ip, details, created_at "
        "FROM security_events "
        "ORDER BY created_at DESC LIMIT 20";
    
    db_result_t *result = db_query(db, query);
    if (result && result->num_rows > 0) {
        for (int i = 0; i < result->num_rows; i++) {
            const char *severity = db_get_value(result, i, 1);
            
            // Color code by severity
            if (strcmp(severity, "CRITICAL") == 0) {
                printf("\033[1;31m");  // Red
            } else if (strcmp(severity, "HIGH") == 0) {
                printf("\033[1;33m");  // Yellow
            } else {
                printf("\033[0m");     // Normal
            }
            
            printf("[%s] %s - %s\n",
                   db_get_value(result, i, 5),  // created_at
                   db_get_value(result, i, 0),  // event_type
                   severity);
            
            printf("  Call ID: %s\n", db_get_value(result, i, 2));
            
            const char *source_ip = db_get_value(result, i, 3);
            if (source_ip && strlen(source_ip) > 0) {
                printf("  Source: %s\n", source_ip);
            }
            
            printf("  Details: %s\n", db_get_value(result, i, 4));
            printf("\033[0m");  // Reset color
            printf("\n");
        }
        db_free_result(result);
    } else {
        printf("No security events recorded\n");
    }
    
    // Summary statistics
    const char *summary_query = 
        "SELECT severity, COUNT(*) as count "
        "FROM security_events "
        "WHERE created_at > NOW() - INTERVAL '24 hours' "
        "GROUP BY severity";
    
    result = db_query(db, summary_query);
    if (result && result->num_rows > 0) {
        printf("Event Summary (Last 24 Hours):\n");
        for (int i = 0; i < result->num_rows; i++) {
            printf("  %s: %s events\n",
                   db_get_value(result, i, 0),
                   db_get_value(result, i, 1));
        }
        db_free_result(result);
    }
    
    return 0;
}

int cmd_validation_test(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    if (!g_validator) {
        printf("Validation system not initialized\n");
        return -1;
    }
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not available\n");
        return -1;
    }
    
    printf("Testing validation with live data from database...\n\n");
    
    // Get a recent call from the database to test with
    const char *call_query = 
        "SELECT c.call_id, c.ani, c.dnis, p.host as source_ip, "
        "d.did, c.provider "
        "FROM calls c "
        "LEFT JOIN providers p ON p.name = c.provider "
        "LEFT JOIN dids d ON d.active = true AND d.in_use = false "
        "WHERE c.status = 'active' OR c.created_at > NOW() - INTERVAL '1 hour' "
        "ORDER BY c.created_at DESC LIMIT 1";
    
    db_result_t *result = db_query(db, call_query);
    
    if (!result || result->num_rows == 0) {
        printf("No recent calls found in database to test with.\n");
        printf("Generating test call with data from providers and DIDs tables...\n\n");
        
        // Get data from providers and DIDs
        const char *test_query = 
            "SELECT p.host, p.name, d.did "
            "FROM providers p, dids d "
            "WHERE p.active = true AND p.role = 'origin' "
            "AND d.active = true AND d.in_use = false "
            "LIMIT 1";
        
        result = db_query(db, test_query);
        if (!result || result->num_rows == 0) {
            printf("No test data available. Please add providers and DIDs first.\n");
            return -1;
        }
        
        // Generate test call ID
        char test_call_id[256];
        snprintf(test_call_id, sizeof(test_call_id), "test_%ld", time(NULL));
        
        const char *source_ip = db_get_value(result, 0, 0);
        const char *did = db_get_value(result, 0, 2);
        
        // Get sample ANI/DNIS from routes table
        const char *route_query = 
            "SELECT pattern FROM routes WHERE active = true LIMIT 1";
        db_result_t *route_result = db_query(db, route_query);
        
        char test_ani[64] = "15551234567";  // Default
        char test_dnis[64] = "18005551234"; // Default
        
        if (route_result && route_result->num_rows > 0) {
            const char *pattern = db_get_value(route_result, 0, 0);
            // Use pattern to generate test numbers
            if (strstr(pattern, "1[2-9]")) {
                strcpy(test_dnis, "12125551234");
            }
            db_free_result(route_result);
        }
        
        printf("Test Call ID: %s\n", test_call_id);
        printf("Test ANI: %s\n", test_ani);
        printf("Test DNIS: %s\n", test_dnis);
        printf("Source IP: %s\n", source_ip);
        printf("Test DID: %s\n\n", did);
        
        // Test validation stages
        printf("1. Testing call initiation validation...\n");
        validation_result_t val_result = validate_call_initiation(g_validator,
                                                                 test_call_id,
                                                                 test_ani,
                                                                 test_dnis,
                                                                 source_ip);
        
        printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
        
        if (val_result == VALIDATION_SUCCESS) {
            // Test state progression
            printf("2. Testing state progression to RINGING...\n");
            val_result = validate_call_progress(g_validator, test_call_id, 
                                               CALL_STATE_RINGING, source_ip);
            printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
            
            // Test DID assignment
            printf("3. Testing DID assignment...\n");
            val_result = validate_did_assignment(g_validator, test_call_id,
                                                did, source_ip);
            printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
            
            // Get destination from providers for routing test
            const char *dest_query = 
                "SELECT host FROM providers WHERE role = 'final' AND active = true LIMIT 1";
            db_result_t *dest_result = db_query(db, dest_query);
            
            if (dest_result && dest_result->num_rows > 0) {
                const char *dest_ip = db_get_value(dest_result, 0, 0);
                
                printf("4. Testing route validation...\n");
                val_result = validate_call_routing(g_validator, test_call_id,
                                                  dest_ip, dest_ip);
                printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
                
                db_free_result(dest_result);
            }
            
            // Test state progression to ANSWERED
            printf("5. Testing state progression to ANSWERED...\n");
            val_result = validate_call_progress(g_validator, test_call_id,
                                               CALL_STATE_ANSWERED, source_ip);
            printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
            
            // Test final state
            printf("6. Testing state progression to HUNG_UP...\n");
            val_result = validate_call_progress(g_validator, test_call_id,
                                               CALL_STATE_HUNG_UP, source_ip);
            printf("   Result: %s\n", val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
            
            // Clean up test data
            char cleanup_query[512];
            snprintf(cleanup_query, sizeof(cleanup_query),
                    "DELETE FROM call_validations WHERE call_id = '%s'",
                    test_call_id);
            db_query(db, cleanup_query);
            
            snprintf(cleanup_query, sizeof(cleanup_query),
                    "DELETE FROM validation_checkpoints WHERE call_id = '%s'",
                    test_call_id);
            db_query(db, cleanup_query);
        }
        
        db_free_result(result);
    } else {
        // Use actual call data from database
        const char *call_id = db_get_value(result, 0, 0);
        const char *ani = db_get_value(result, 0, 1);
        const char *dnis = db_get_value(result, 0, 2);
        const char *source_ip = db_get_value(result, 0, 3);
        const char *did = db_get_value(result, 0, 4);
        
        printf("Using live call data:\n");
        printf("  Call ID: %s\n", call_id);
        printf("  ANI: %s\n", ani);
        printf("  DNIS: %s\n", dnis);
        printf("  Source: %s\n\n", source_ip);
        
        // Run validation tests with live data
        printf("Running validation tests...\n");
        validation_result_t val_result = validate_call_initiation(g_validator,
                                                                 call_id,
                                                                 ani,
                                                                 dnis,
                                                                 source_ip);
        printf("Call initiation validation: %s\n", 
               val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
        
        if (did && strlen(did) > 0) {
            val_result = validate_did_assignment(g_validator, call_id, did, source_ip);
            printf("DID assignment validation: %s\n", 
                   val_result == VALIDATION_SUCCESS ? "PASSED" : "FAILED");
        }
        
        db_free_result(result);
    }
    
    printf("\nValidation test completed\n");
    
    // Show recent checkpoints for tested calls
    printf("\nRecent validation checkpoints:\n");
    const char *checkpoint_query = 
        "SELECT checkpoint_name, passed, failure_reason "
        "FROM validation_checkpoints "
        "WHERE checked_at > NOW() - INTERVAL '5 minutes' "
        "ORDER BY checked_at DESC LIMIT 10";
    
    result = db_query(db, checkpoint_query);
    if (result && result->num_rows > 0) {
        for (int i = 0; i < result->num_rows; i++) {
            printf("  %s: %s %s\n",
                   db_get_value(result, i, 0),
                   strcmp(db_get_value(result, i, 1), "t") == 0 ? "PASSED" : "FAILED",
                   db_get_value(result, i, 2) ? db_get_value(result, i, 2) : "");
        }
        db_free_result(result);
    }
    
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>
#include "core/config.h"
#include "core/logging.h"

static char* json_get_string(struct json_object *obj, const char *key, const char *default_val) {
    struct json_object *val;
    if (json_object_object_get_ex(obj, key, &val)) {
        return strdup(json_object_get_string(val));
    }
    return strdup(default_val);
}

static int json_get_int(struct json_object *obj, const char *key, int default_val) {
    struct json_object *val;
    if (json_object_object_get_ex(obj, key, &val)) {
        return json_object_get_int(val);
    }
    return default_val;
}

static bool json_get_bool(struct json_object *obj, const char *key, bool default_val) {
    struct json_object *val;
    if (json_object_object_get_ex(obj, key, &val)) {
        return json_object_get_boolean(val);
    }
    return default_val;
}

app_config_t* config_load(const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        LOG_ERROR("Failed to open config file: %s", filename);
        
        // Return default configuration
        app_config_t *config = calloc(1, sizeof(app_config_t));
        if (!config) return NULL;
        
        // FreeSWITCH defaults
        config->freeswitch.host = strdup("localhost");
        config->freeswitch.port = 8021;
        config->freeswitch.password = strdup("ClueCon");
        config->freeswitch.max_connections = 10;
        config->freeswitch.event_threads = 4;
        
        // Database defaults - optimized for high load
        config->database.path = strdup("router.db");
        config->database.pool_size = 50;
        config->database.max_connections = 100;
        config->database.wal_mode = true;
        
        // Cache defaults
        config->cache.host = strdup("localhost");
        config->cache.port = 6379;
        config->cache.pool_size = 20;
        config->cache.db_index = 0;
        config->cache.password = strdup("");
        config->cache.timeout_ms = 1000;
        
        // Server defaults
        config->server.listen_address = strdup("0.0.0.0");
        config->server.port = 8083;
        config->server.worker_threads = 8;
        config->server.max_connections = 1000;
        
        // Router defaults - optimized for thousands of routes
        config->router.max_routes = 10000;
        config->router.max_providers = 1000;
        config->router.route_cache_ttl = 300;
        config->router.stats_interval = 60;
        config->router.enable_failover = true;
        config->router.failover_timeout = 5;
        
        // Logging defaults
        config->log_file = strdup("logs/router.log");
        config->log_level = strdup("INFO");
        
        return config;
    }
    
    // Read file contents
    fseek(fp, 0, SEEK_END);
    long length = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    char *data = malloc(length + 1);
    fread(data, 1, length, fp);
    data[length] = '\0';
    fclose(fp);
    
    // Parse JSON
    struct json_object *root = json_tokener_parse(data);
    free(data);
    
    if (!root) {
        LOG_ERROR("Failed to parse config file");
        return NULL;
    }
    
    app_config_t *config = calloc(1, sizeof(app_config_t));
    if (!config) {
        json_object_put(root);
        return NULL;
    }
    
    // Parse FreeSWITCH section
    struct json_object *fs_obj;
    if (json_object_object_get_ex(root, "freeswitch", &fs_obj)) {
        config->freeswitch.host = json_get_string(fs_obj, "host", "localhost");
        config->freeswitch.port = json_get_int(fs_obj, "port", 8021);
        config->freeswitch.password = json_get_string(fs_obj, "password", "ClueCon");
        config->freeswitch.max_connections = json_get_int(fs_obj, "max_connections", 10);
        config->freeswitch.event_threads = json_get_int(fs_obj, "event_threads", 4);
    }
    
    // Parse Database section
    struct json_object *db_obj;
    if (json_object_object_get_ex(root, "database", &db_obj)) {
        config->database.path = json_get_string(db_obj, "path", "router.db");
        config->database.pool_size = json_get_int(db_obj, "pool_size", 50);
        config->database.max_connections = json_get_int(db_obj, "max_connections", 100);
        config->database.wal_mode = json_get_bool(db_obj, "wal_mode", true);
    }
    
    // Parse Cache section
    struct json_object *cache_obj;
    if (json_object_object_get_ex(root, "cache", &cache_obj)) {
        config->cache.host = json_get_string(cache_obj, "host", "localhost");
        config->cache.port = json_get_int(cache_obj, "port", 6379);
        config->cache.pool_size = json_get_int(cache_obj, "pool_size", 20);
        config->cache.timeout_ms = json_get_int(cache_obj, "timeout_ms", 1000);
    }
    
    // Parse Server section
    struct json_object *server_obj;
    if (json_object_object_get_ex(root, "server", &server_obj)) {
        config->server.listen_address = json_get_string(server_obj, "listen_address", "0.0.0.0");
        config->server.port = json_get_int(server_obj, "port", 8083);
        config->server.worker_threads = json_get_int(server_obj, "worker_threads", 8);
        config->server.max_connections = json_get_int(server_obj, "max_connections", 1000);
    }
    
    // Parse Router section
    struct json_object *router_obj;
    if (json_object_object_get_ex(root, "router", &router_obj)) {
        config->router.max_routes = json_get_int(router_obj, "max_routes", 10000);
        config->router.max_providers = json_get_int(router_obj, "max_providers", 1000);
        config->router.route_cache_ttl = json_get_int(router_obj, "route_cache_ttl", 300);
        config->router.enable_failover = json_get_bool(router_obj, "enable_failover", true);
    }
    
    // Logging
    config->log_file = json_get_string(root, "log_file", "logs/router.log");
    config->log_level = json_get_string(root, "log_level", "INFO");
    
    json_object_put(root);
    
    LOG_INFO("Configuration loaded successfully");
    return config;
}

void config_free(app_config_t *config) {
    if (!config) return;
    
    free(config->freeswitch.host);
    free(config->freeswitch.password);
    free(config->database.path);
    free(config->cache.host);
    free(config->cache.password);
    free(config->server.listen_address);
    free(config->log_file);
    free(config->log_level);
    free(config);
}

void config_print(app_config_t *config) {
    if (!config) return;
    
    printf("Configuration:\n");
    printf("  FreeSWITCH:\n");
    printf("    Host: %s:%d\n", config->freeswitch.host, config->freeswitch.port);
    printf("    Max Connections: %d\n", config->freeswitch.max_connections);
    printf("  Database:\n");
    printf("    Path: %s\n", config->database.path);
    printf("    Pool Size: %d\n", config->database.pool_size);
    printf("  Server:\n");
    printf("    Listen: %s:%d\n", config->server.listen_address, config->server.port);
    printf("  Router:\n");
    printf("    Max Routes: %d\n", config->router.max_routes);
    printf("    Max Providers: %d\n", config->router.max_providers);
}
#include "core/logging.h"
#include <stdlib.h>
#include <string.h>
#include "core/models.h"

// Provider functions
provider_t* provider_create(void) {
    provider_t *provider = calloc(1, sizeof(provider_t));
    if (!provider) return NULL;
    
    // Set defaults
    provider->port = 5060;
    provider->capacity = 100;
    provider->active = true;
    provider->priority = 100;
    strcpy(provider->transport, "udp");
    
    return provider;
}

void provider_free(provider_t *provider) {
    if (!provider) return;
    
    // Free metadata if allocated
    if (provider->metadata) {
        free(provider->metadata);
    }
    
    free(provider);
}

// Route functions
route_t* route_create(void) {
    route_t *route = calloc(1, sizeof(route_t));
    if (!route) return NULL;
    
    route->active = true;
    route->priority = 100;
    
    return route;
}

void route_free(route_t *route) {
    if (!route) return;
    free(route);
}

// DID functions
did_t* did_create(void) {
    did_t *did = calloc(1, sizeof(did_t));
    if (!did) return NULL;
    
    did->active = true;
    
    return did;
}

void did_free(did_t *did) {
    if (!did) return;
    free(did);
}

// Call functions
call_t* call_create(void) {
    call_t *call = calloc(1, sizeof(call_t));
    if (!call) return NULL;
    
    strcpy(call->status, "active");
    call->created_at = time(NULL);
    
    return call;
}

void call_free(call_t *call) {
    if (!call) return;
    free(call);
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <microhttpd.h>
#include "core/server.h"
#include "core/logging.h"
#include "router/router.h"
#include "api/handlers.h"

struct server {
    struct MHD_Daemon *daemon;
    router_t *router;
    int port;
    bool running;
};

server_t* server_create(int port, router_t *router) {
    server_t *server = calloc(1, sizeof(server_t));
    if (!server) return NULL;
    
    server->port = port;
    server->router = router;
    server->running = false;
    
    return server;
}

void server_destroy(server_t *server) {
    if (server) {
        server_stop(server);
        free(server);
    }
}

// Updated to use enum MHD_Result
static enum MHD_Result handle_request(void *cls,
                                     struct MHD_Connection *connection,
                                     const char *url,
                                     const char *method,
                                     const char *version,
                                     const char *upload_data,
                                     size_t *upload_data_size,
                                     void **con_cls) {
    
    (void)cls;
    (void)version;
    (void)con_cls;
    
    int ret = handle_api_request(connection, url, method, upload_data, upload_data_size);
    
    // Convert int to enum MHD_Result
    return (ret == MHD_HTTP_OK || ret == MHD_YES) ? MHD_YES : MHD_NO;
}

int server_start(server_t *server) {
    server->daemon = MHD_start_daemon(
        MHD_USE_SELECT_INTERNALLY | MHD_USE_EPOLL_LINUX_ONLY,
        server->port,
        NULL, NULL,
        &handle_request, server,
        MHD_OPTION_THREAD_POOL_SIZE, (unsigned int)8,
        MHD_OPTION_CONNECTION_LIMIT, (unsigned int)1000,
        MHD_OPTION_CONNECTION_TIMEOUT, (unsigned int)30,
        MHD_OPTION_END);
    
    if (!server->daemon) {
        LOG_ERROR("Failed to start HTTP server on port %d", server->port);
        return -1;
    }
    
    server->running = true;
    LOG_INFO("HTTP server started on 0.0.0.0:%d", server->port);
    return 0;
}

void server_stop(server_t *server) {
    if (server && server->daemon) {
        MHD_stop_daemon(server->daemon);
        server->daemon = NULL;
        server->running = false;
    }
}

bool server_is_running(server_t *server) {
    return server && server->running;
}
#include <stdio.h>
#include <string.h>
#include <time.h>

char* get_timestamp(void) {
    static char buffer[32];
    time_t now = time(NULL);
    struct tm *tm = localtime(&now);
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", tm);
    return buffer;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include "db/cache.h"
#include "core/logging.h"

struct cache {
    char *host;
    int port;
    int pool_size;
    bool connected;
};

cache_t* cache_create(const char *host, int port, int pool_size) {
    cache_t *cache = calloc(1, sizeof(cache_t));
    if (!cache) return NULL;
    
    cache->host = strdup(host);
    cache->port = port;
    cache->pool_size = pool_size;
    cache->connected = false;
    
    // For now, we'll use a dummy cache
    LOG_WARN("Cache implementation is a stub - using memory only");
    
    return cache;
}

void cache_destroy(cache_t *cache) {
    if (cache) {
        free(cache->host);
        free(cache);
    }
}

int cache_get(cache_t *cache, const char *key, char *value, size_t len) {
    (void)cache;
    (void)key;
    (void)value;
    (void)len;
    return -1; // Not found
}

int cache_set(cache_t *cache, const char *key, const char *value, int ttl) {
    (void)cache;
    (void)key;
    (void)value;
    (void)ttl;
    return 0; // Success (dummy)
}
// database_pg.c - Complete PostgreSQL 12 implementation with dynamic queries
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <libpq-fe.h>
#include "db/database.h"
#include "core/logging.h"

struct database {
    PGconn *conn;
    pthread_mutex_t mutex;
    char *connection_string;
    int reconnect_attempts;
    int max_reconnect_attempts;
};

// Global database instance
static database_t *g_database = NULL;

// Helper function to escape strings for SQL
static char* escape_string(PGconn *conn, const char *str) {
    if (!str) return strdup("NULL");
    
    size_t len = strlen(str);
    char *escaped = malloc(2 * len + 1);
    PQescapeStringConn(conn, escaped, str, len, NULL);
    return escaped;
}

// Convert PGresult to db_result_t
static db_result_t* pg_to_db_result(PGresult *pg_res) {
    if (!pg_res) return NULL;
    
    ExecStatusType status = PQresultStatus(pg_res);
    if (status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK) {
        LOG_ERROR("Query failed: %s", PQerrorMessage(g_database->conn));
        PQclear(pg_res);
        return NULL;
    }
    
    int num_rows = PQntuples(pg_res);
    int num_cols = PQnfields(pg_res);
    
    if (num_rows == 0 || num_cols == 0) {
        PQclear(pg_res);
        return NULL;
    }
    
    db_result_t *result = calloc(1, sizeof(db_result_t));
    if (!result) {
        PQclear(pg_res);
        return NULL;
    }
    
    result->num_rows = num_rows;
    result->num_cols = num_cols;
    result->data = calloc(num_rows * num_cols, sizeof(char*));
    result->columns = calloc(num_cols, sizeof(char*));
    
    // Copy column names
    for (int col = 0; col < num_cols; col++) {
        result->columns[col] = strdup(PQfname(pg_res, col));
    }
    
    // Copy data
    for (int row = 0; row < num_rows; row++) {
        for (int col = 0; col < num_cols; col++) {
            int idx = row * num_cols + col;
            if (PQgetisnull(pg_res, row, col)) {
                result->data[idx] = strdup("");
            } else {
                result->data[idx] = strdup(PQgetvalue(pg_res, row, col));
            }
        }
    }
    
    PQclear(pg_res);
    return result;
}

// Reconnect to database if connection lost
static int db_reconnect(database_t *db) {
    if (!db) return -1;
    
    if (PQstatus(db->conn) == CONNECTION_OK) {
        return 0;
    }
    
    LOG_WARN("Database connection lost, attempting to reconnect...");
    
    for (int i = 0; i < db->max_reconnect_attempts; i++) {
        PQreset(db->conn);
        
        if (PQstatus(db->conn) == CONNECTION_OK) {
            LOG_INFO("Database reconnected successfully");
            return 0;
        }
        
        LOG_WARN("Reconnect attempt %d/%d failed", i+1, db->max_reconnect_attempts);
        usleep(1000000); // Wait 1 second before retry
    }
    
    LOG_ERROR("Failed to reconnect to database after %d attempts", db->max_reconnect_attempts);
    return -1;
}

database_t* db_init(const char *connection_string) {
    if (g_database) return g_database;
    
    database_t *db = calloc(1, sizeof(database_t));
    if (!db) return NULL;
    
    // Use environment variable or provided connection string
    const char *conn_str = connection_string;
    if (!conn_str) {
        conn_str = getenv("ROUTER_DB_CONNECTION");
        if (!conn_str) {
            conn_str = "host=localhost dbname=router_db user=router password=router123 connect_timeout=10";
        }
    }
    
    db->connection_string = strdup(conn_str);
    db->max_reconnect_attempts = 3;
    db->reconnect_attempts = 0;
    
    db->conn = PQconnectdb(conn_str);
    
    if (PQstatus(db->conn) != CONNECTION_OK) {
        LOG_ERROR("Failed to connect to PostgreSQL: %s", PQerrorMessage(db->conn));
        PQfinish(db->conn);
        free(db->connection_string);
        free(db);
        return NULL;
    }
    
    pthread_mutex_init(&db->mutex, NULL);
    
    // Set client encoding
    PQsetClientEncoding(db->conn, "UTF8");
    
    // Enable autocommit
    PGresult *res = PQexec(db->conn, "SET autocommit TO on");
    PQclear(res);
    
    g_database = db;
    LOG_INFO("Connected to PostgreSQL database");
    
    return db;
}

void db_close(database_t *db) {
    if (!db) return;
    
    pthread_mutex_lock(&db->mutex);
    
    if (db->conn) {
        PQfinish(db->conn);
    }
    
    pthread_mutex_unlock(&db->mutex);
    pthread_mutex_destroy(&db->mutex);
    
    free(db->connection_string);
    
    if (g_database == db) {
        g_database = NULL;
    }
    
    free(db);
}

db_result_t* db_query(database_t *db, const char *query) {
    if (!db || !query) return NULL;
    
    pthread_mutex_lock(&db->mutex);
    
    // Check connection and reconnect if needed
    if (db_reconnect(db) != 0) {
        pthread_mutex_unlock(&db->mutex);
        return NULL;
    }
    
    PGresult *res = PQexec(db->conn, query);
    db_result_t *result = pg_to_db_result(res);
    
    pthread_mutex_unlock(&db->mutex);
    
    return result;
}

void db_free_result(db_result_t *result) {
    if (!result) return;
    
    if (result->data) {
        for (int i = 0; i < result->num_rows * result->num_cols; i++) {
            free(result->data[i]);
        }
        free(result->data);
    }
    
    if (result->columns) {
        for (int i = 0; i < result->num_cols; i++) {
            free(result->columns[i]);
        }
        free(result->columns);
    }
    
    free(result);
}

const char* db_get_value(db_result_t *result, int row, int col) {
    if (!result || !result->data) return "";
    if (row >= result->num_rows || col >= result->num_cols) return "";
    
    return result->data[row * result->num_cols + col];
}

// Prepared statement implementation
typedef struct {
    database_t *db;
    char *sql;
    char **params;
    int *param_lengths;
    int *param_formats;
    Oid *param_types;
    int param_count;
    int param_capacity;
} pg_stmt_t;

db_stmt_t* db_prepare(database_t *db, const char *sql) {
    if (!db || !sql) return NULL;
    
    pg_stmt_t *stmt = calloc(1, sizeof(pg_stmt_t));
    stmt->db = db;
    stmt->sql = strdup(sql);
    stmt->param_capacity = 10;
    stmt->params = calloc(stmt->param_capacity, sizeof(char*));
    stmt->param_lengths = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_formats = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_types = calloc(stmt->param_capacity, sizeof(Oid));
    
    return (db_stmt_t*)stmt;
}

int db_bind_string(db_stmt_t *stmt, int index, const char *value) {
    if (!stmt) return -1;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    if (index > pg_stmt->param_capacity) {
        pg_stmt->param_capacity = index + 10;
        pg_stmt->params = realloc(pg_stmt->params, pg_stmt->param_capacity * sizeof(char*));
        pg_stmt->param_lengths = realloc(pg_stmt->param_lengths, pg_stmt->param_capacity * sizeof(int));
        pg_stmt->param_formats = realloc(pg_stmt->param_formats, pg_stmt->param_capacity * sizeof(int));
        pg_stmt->param_types = realloc(pg_stmt->param_types, pg_stmt->param_capacity * sizeof(Oid));
    }
    
    if (pg_stmt->params[index-1]) {
        free(pg_stmt->params[index-1]);
    }
    
    if (value) {
        pg_stmt->params[index-1] = strdup(value);
        pg_stmt->param_lengths[index-1] = strlen(value);
    } else {
        pg_stmt->params[index-1] = NULL;
        pg_stmt->param_lengths[index-1] = 0;
    }
    
    pg_stmt->param_formats[index-1] = 0; // text format
    pg_stmt->param_types[index-1] = 0; // let server deduce type
    
    if (index > pg_stmt->param_count) {
        pg_stmt->param_count = index;
    }
    
    return 0;
}

int db_bind_int(db_stmt_t *stmt, int index, int value) {
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%d", value);
    return db_bind_string(stmt, index, buffer);
}

// Convert SQL placeholders from ? to $1, $2, etc.
static char* convert_sql_placeholders(const char *sql) {
    char *converted = malloc(strlen(sql) * 2);
    char *dest = converted;
    const char *src = sql;
    int param_num = 1;
    
    while (*src) {
        if (*src == '?') {
            dest += sprintf(dest, "$%d", param_num++);
        } else {
            *dest++ = *src;
        }
        src++;
    }
    *dest = '\0';
    
    return converted;
}

int db_execute(db_stmt_t *stmt) {
    if (!stmt) return -1;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Check connection
    if (db_reconnect(pg_stmt->db) != 0) {
        pthread_mutex_unlock(&pg_stmt->db->mutex);
        return -1;
    }
    
    char *pg_sql = convert_sql_placeholders(pg_stmt->sql);
    
    PGresult *res = PQexecParams(pg_stmt->db->conn,
                                 pg_sql,
                                 pg_stmt->param_count,
                                 pg_stmt->param_types,
                                 (const char * const *)pg_stmt->params,
                                 pg_stmt->param_lengths,
                                 pg_stmt->param_formats,
                                 0);
    
    free(pg_sql);
    
    ExecStatusType status = PQresultStatus(res);
    int result = (status == PGRES_COMMAND_OK || status == PGRES_TUPLES_OK) ? 0 : -1;
    
    if (result < 0) {
        LOG_ERROR("Execute failed: %s", PQerrorMessage(pg_stmt->db->conn));
    }
    
    PQclear(res);
    pthread_mutex_unlock(&pg_stmt->db->mutex);
    
    return result;
}

db_result_t* db_execute_query(db_stmt_t *stmt) {
    if (!stmt) return NULL;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Check connection
    if (db_reconnect(pg_stmt->db) != 0) {
        pthread_mutex_unlock(&pg_stmt->db->mutex);
        return NULL;
    }
    
    char *pg_sql = convert_sql_placeholders(pg_stmt->sql);
    
    PGresult *res = PQexecParams(pg_stmt->db->conn,
                                 pg_sql,
                                 pg_stmt->param_count,
                                 pg_stmt->param_types,
                                 (const char * const *)pg_stmt->params,
                                 pg_stmt->param_lengths,
                                 pg_stmt->param_formats,
                                 0);
    
    free(pg_sql);
    
    db_result_t *result = pg_to_db_result(res);
    
    pthread_mutex_unlock(&pg_stmt->db->mutex);
    
    return result;
}

void db_finalize(db_stmt_t *stmt) {
    if (!stmt) return;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    free(pg_stmt->sql);
    
    for (int i = 0; i < pg_stmt->param_count; i++) {
        if (pg_stmt->params[i]) {
            free(pg_stmt->params[i]);
        }
    }
    
    free(pg_stmt->params);
    free(pg_stmt->param_lengths);
    free(pg_stmt->param_formats);
    free(pg_stmt->param_types);
    free(pg_stmt);
}

database_t* get_database(void) {
    return g_database;
}
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
#include <stdlib.h>
#include "core/logging.h"

typedef struct load_balancer {
    int dummy;
} load_balancer_t;

load_balancer_t* lb_create(void) {
    return calloc(1, sizeof(load_balancer_t));
}

void lb_destroy(load_balancer_t *lb) {
    free(lb);
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <time.h>
#include <unistd.h>
#include "router/router.h"
#include "core/logging.h"

typedef enum {
    ROUTE_TYPE_INBOUND,
    ROUTE_TYPE_INTERMEDIATE,
    ROUTE_TYPE_FINAL
} route_type_t;

typedef struct call_state {
    char call_id[256];
    char ani[64];
    char dnis[64];
    char current_provider[128];
    route_type_t current_stage;
    char route_name[128];
    time_t created_at;
    struct call_state *next;
} call_state_t;

struct router {
    database_t *db;
    pthread_mutex_t mutex;
    call_state_t *active_calls;
    
    struct {
        uint64_t total_calls;
        uint64_t successful_calls;
        uint64_t failed_calls;
    } stats;
};

router_t* router_create(database_t *db, void *cache, void *fs_handler) {
    router_t *router = calloc(1, sizeof(router_t));
    if (!router) return NULL;
    
    router->db = db;
    pthread_mutex_init(&router->mutex, NULL);
    
    LOG_INFO("Router created successfully");
    
    return router;
}

void router_destroy(router_t *router) {
    if (!router) return;
    
    pthread_mutex_lock(&router->mutex);
    
    // Free active calls
    call_state_t *call = router->active_calls;
    while (call) {
        call_state_t *next = call->next;
        free(call);
        call = next;
    }
    
    pthread_mutex_unlock(&router->mutex);
    pthread_mutex_destroy(&router->mutex);
    free(router);
}

int router_route_call(router_t *router, route_request_t *request) {
    if (!router || !request || !request->dnis) return -1;
    
    LOG_INFO("Routing request: ANI=%s, DNIS=%s, Provider=%s", 
             request->ani, request->dnis, request->provider);
    
// Fix for router.c - line 75-83
    char sql[1024];
    snprintf(sql, sizeof(sql),
        "SELECT COALESCE(p.name, r.intermediate_provider) as provider_name "
        "FROM routes r "
        "LEFT JOIN providers p ON r.provider_id = p.id "
        "WHERE '%s' GLOB r.pattern AND r.active = 1 "
        "ORDER BY r.priority DESC LIMIT 1",
        request->dnis);
    
    db_result_t *result = db_query(router->db, sql);
    
    if (result && result->num_rows > 0) {
        const char *provider = db_get_value(result, 0, 0);
        request->gateway = strdup(provider);
        request->route_type = strdup("standard");
        
        LOG_INFO("Route found: %s -> gateway %s", request->dnis, provider);
        
        db_free_result(result);
        
        router->stats.total_calls++;
        return 0;
    }
    
    if (result) db_free_result(result);
    
    LOG_WARN("No route found for %s", request->dnis);
    router->stats.failed_calls++;
    return -1;
}

int router_get_stats(router_t *router, void *stats) {
    if (!router || !stats) return -1;
    
    memcpy(stats, &router->stats, sizeof(router->stats));
    
    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>
#include <unistd.h>
#include "sip/freeswitch_handler.h"
#include "core/logging.h"

struct freeswitch_handler {
    char *host;
    int port;
    char *password;
    bool connected;
    bool running;
    pthread_t event_thread;
    pthread_mutex_t mutex;
};

// Stub implementation without ESL
freeswitch_handler_t* freeswitch_handler_create(const char *host, int port, const char *password) {
    freeswitch_handler_t *handler = calloc(1, sizeof(freeswitch_handler_t));
    if (!handler) return NULL;
    
    handler->host = strdup(host);
    handler->port = port;
    handler->password = strdup(password);
    handler->connected = false;
    handler->running = false;
    
    pthread_mutex_init(&handler->mutex, NULL);
    
    LOG_INFO("FreeSWITCH handler created (stub mode - no ESL)");
    
    return handler;
}

void freeswitch_handler_destroy(freeswitch_handler_t *handler) {
    if (!handler) return;
    
    if (handler->running) {
        handler->running = false;
        pthread_join(handler->event_thread, NULL);
    }
    
    free(handler->host);
    free(handler->password);
    pthread_mutex_destroy(&handler->mutex);
    free(handler);
}

int freeswitch_handler_connect(freeswitch_handler_t *handler) {
    if (!handler) return -1;
    
    pthread_mutex_lock(&handler->mutex);
    
    // Simulate connection
    LOG_INFO("Simulating FreeSWITCH connection to %s:%d", handler->host, handler->port);
    handler->connected = true;
    
    pthread_mutex_unlock(&handler->mutex);
    return 0;
}

int freeswitch_handler_execute(freeswitch_handler_t *handler, const char *command) {
    if (!handler || !command || !handler->connected) return -1;
    
    LOG_DEBUG("Would execute FreeSWITCH command: %s", command);
    
    return 0;
}

int freeswitch_handler_get_stats(freeswitch_handler_t *handler, fs_stats_t *stats) {
    if (!handler || !stats) return -1;
    
    stats->total_calls = 0;
    stats->active_calls = 0;
    stats->failed_calls = 0;
    stats->connected = handler->connected;
    
    return 0;
}

bool freeswitch_handler_is_connected(freeswitch_handler_t *handler) {
    return handler && handler->connected;
}

static void* event_thread_func(void *arg) {
    freeswitch_handler_t *handler = (freeswitch_handler_t*)arg;
    
    while (handler->running && handler->connected) {
        // Simulate event processing
        sleep(1);
    }
    
    return NULL;
}

int freeswitch_handler_start_event_loop(freeswitch_handler_t *handler) {
    if (!handler || !handler->connected || handler->running) return -1;
    
    handler->running = true;
    
    if (pthread_create(&handler->event_thread, NULL, event_thread_func, handler) != 0) {
        handler->running = false;
        return -1;
    }
    
    return 0;
}

void freeswitch_handler_stop_event_loop(freeswitch_handler_t *handler) {
    if (!handler || !handler->running) return;
    
    handler->running = false;
    pthread_join(handler->event_thread, NULL);
}
// sip_server_dynamic.c - Complete rewrite with full database integration
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <limits.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <errno.h>
#include <stdbool.h>
#include "sip/sip_server.h"
#include "router/router.h"
#include "db/database.h"
#include "core/logging.h"

#define SIP_PORT 5060
#define BUFFER_SIZE 65536

// Provider structure from database
typedef struct provider {
    int id;
    char uuid[64];
    char name[256];
    char host[256];
    int port;
    char auth_type[32];
    char auth_data[512];
    char transport[16];
    int capacity;
    char role[32];  // 'origin', 'intermediate', 'final', 'general'
    int current_calls;
    bool active;
    time_t last_updated;
    struct provider *next;
} provider_t;

// DID structure from database
typedef struct did {
    int id;
    char did[64];
    char country[32];
    int provider_id;
    bool in_use;
    char destination[64];
    char call_id[256];
    char original_ani[64];
    time_t allocated_at;
    bool active;
    struct did *next;
} did_t;

// Call state tracking
typedef struct call_state {
    char call_id[256];
    char original_ani[64];
    char original_dnis[64];
    char assigned_did[64];
    int origin_provider_id;
    int intermediate_provider_id;
    int final_provider_id;
    int stage;  // 1=origin->intermediate, 2=intermediate->final
    time_t created_at;
    struct call_state *next;
} call_state_t;

// Route structure from database
typedef struct route {
    int id;
    char uuid[64];
    char name[256];
    char pattern[256];
    int origin_provider_id;
    int intermediate_provider_id;
    int final_provider_id;
    int priority;
    bool active;
    struct route *next;
} route_t;

// Main SIP server structure
struct sip_server {
    // Network
    int socket_fd;
    struct sockaddr_in server_addr;
    pthread_t listen_thread;
    
    // Database
    database_t *db;
    
    // Providers linked list
    provider_t *providers;
    pthread_mutex_t provider_mutex;
    
    // DIDs linked list
    did_t *dids;
    pthread_mutex_t did_mutex;
    
    // Routes linked list
    route_t *routes;
    pthread_mutex_t route_mutex;
    
    // Active calls
    call_state_t *active_calls;
    pthread_mutex_t call_mutex;
    
    // Router reference
    router_t *router;
    
    // Statistics
    struct {
        uint64_t total_invites;
        uint64_t forwarded_calls;
        uint64_t failed_calls;
    } stats;
    
    int running;
    pthread_t monitor_thread;
};

// Global server instance
extern sip_server_t *g_sip_server; // Defined in main.c

// Free provider list
static void free_providers(provider_t *providers) {
    while (providers) {
        provider_t *next = providers->next;
        free(providers);
        providers = next;
    }
}

// Free DID list
static void free_dids(did_t *dids) {
    while (dids) {
        did_t *next = dids->next;
        free(dids);
        dids = next;
    }
}

// Free route list
static void free_routes(route_t *routes) {
    while (routes) {
        route_t *next = routes->next;
        free(routes);
        routes = next;
    }
}

// Load providers from database
static int load_providers_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, uuid, name, host, port, auth_type, auth_data, transport, "
        "capacity, role, current_calls, active "
        "FROM providers WHERE active = true ORDER BY role, name";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load providers from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->provider_mutex);
    
    // Free old provider list
    free_providers(server->providers);
    server->providers = NULL;
    provider_t **pp = &server->providers;
    
    for (int i = 0; i < result->num_rows; i++) {
        provider_t *provider = calloc(1, sizeof(provider_t));
        
        provider->id = atoi(db_get_value(result, i, 0));
        strncpy(provider->uuid, db_get_value(result, i, 1), sizeof(provider->uuid) - 1);
        strncpy(provider->name, db_get_value(result, i, 2), sizeof(provider->name) - 1);
        strncpy(provider->host, db_get_value(result, i, 3), sizeof(provider->host) - 1);
        provider->port = atoi(db_get_value(result, i, 4));
        strncpy(provider->auth_type, db_get_value(result, i, 5), sizeof(provider->auth_type) - 1);
        strncpy(provider->auth_data, db_get_value(result, i, 6), sizeof(provider->auth_data) - 1);
        strncpy(provider->transport, db_get_value(result, i, 7), sizeof(provider->transport) - 1);
        provider->capacity = atoi(db_get_value(result, i, 8));
        strncpy(provider->role, db_get_value(result, i, 9), sizeof(provider->role) - 1);
        provider->current_calls = atoi(db_get_value(result, i, 10));
        provider->active = strcmp(db_get_value(result, i, 11), "t") == 0;
        provider->last_updated = time(NULL);
        
        // Add to linked list
        *pp = provider;
        pp = &provider->next;
        
        LOG_INFO("Loaded provider: %s (UUID: %s, Role: %s, Host: %s:%d)", 
                provider->name, provider->uuid, provider->role, provider->host, provider->port);
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d providers from database", result->num_rows);
    return 0;
}

// Load DIDs from database
static int load_dids_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, did, country, provider_id, in_use, destination, "
        "call_id, original_ani, allocated_at, active "
        "FROM dids WHERE active = true ORDER BY did";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load DIDs from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->did_mutex);
    
    // Free old DID list
    free_dids(server->dids);
    server->dids = NULL;
    did_t **pp = &server->dids;
    
    for (int i = 0; i < result->num_rows; i++) {
        did_t *did = calloc(1, sizeof(did_t));
        
        did->id = atoi(db_get_value(result, i, 0));
        strncpy(did->did, db_get_value(result, i, 1), sizeof(did->did) - 1);
        strncpy(did->country, db_get_value(result, i, 2), sizeof(did->country) - 1);
        
        const char *provider_id_str = db_get_value(result, i, 3);
        did->provider_id = (provider_id_str && strlen(provider_id_str) > 0) ? atoi(provider_id_str) : 0;
        
        did->in_use = strcmp(db_get_value(result, i, 4), "t") == 0;
        
        const char *dest = db_get_value(result, i, 5);
        if (dest && strlen(dest) > 0) {
            strncpy(did->destination, dest, sizeof(did->destination) - 1);
        }
        
        const char *cid = db_get_value(result, i, 6);
        if (cid && strlen(cid) > 0) {
            strncpy(did->call_id, cid, sizeof(did->call_id) - 1);
        }
        
        const char *ani = db_get_value(result, i, 7);
        if (ani && strlen(ani) > 0) {
            strncpy(did->original_ani, ani, sizeof(did->original_ani) - 1);
        }
        
        did->active = strcmp(db_get_value(result, i, 9), "t") == 0;
        
        // Add to linked list
        *pp = did;
        pp = &did->next;
    }
    
    pthread_mutex_unlock(&server->did_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d DIDs from database", result->num_rows);
    return 0;
}

// Load routes from database
static int load_routes_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, uuid, name, pattern, origin_provider_id, "
        "intermediate_provider_id, final_provider_id, priority, active "
        "FROM routes WHERE active = true ORDER BY priority DESC, name";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load routes from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->route_mutex);
    
    // Free old route list
    free_routes(server->routes);
    server->routes = NULL;
    route_t **pp = &server->routes;
    
    for (int i = 0; i < result->num_rows; i++) {
        route_t *route = calloc(1, sizeof(route_t));
        
        route->id = atoi(db_get_value(result, i, 0));
        strncpy(route->uuid, db_get_value(result, i, 1), sizeof(route->uuid) - 1);
        strncpy(route->name, db_get_value(result, i, 2), sizeof(route->name) - 1);
        strncpy(route->pattern, db_get_value(result, i, 3), sizeof(route->pattern) - 1);
        
        const char *origin_id = db_get_value(result, i, 4);
        route->origin_provider_id = (origin_id && strlen(origin_id) > 0) ? atoi(origin_id) : 0;
        
        const char *inter_id = db_get_value(result, i, 5);
        route->intermediate_provider_id = (inter_id && strlen(inter_id) > 0) ? atoi(inter_id) : 0;
        
        const char *final_id = db_get_value(result, i, 6);
        route->final_provider_id = (final_id && strlen(final_id) > 0) ? atoi(final_id) : 0;
        
        route->priority = atoi(db_get_value(result, i, 7));
        route->active = strcmp(db_get_value(result, i, 8), "t") == 0;
        
        // Add to linked list
        *pp = route;
        pp = &route->next;
        
        LOG_INFO("Loaded route: %s (Pattern: %s, Priority: %d)", 
                route->name, route->pattern, route->priority);
    }
    
    pthread_mutex_unlock(&server->route_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d routes from database", result->num_rows);
    return 0;
}

// Find provider by ID
static provider_t* find_provider_by_id(sip_server_t *server, int id) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    while (provider) {
        if (provider->id == id) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return NULL;
}

// Find provider by IP
static provider_t* find_provider_by_ip(sip_server_t *server, const char *ip) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    while (provider) {
        // Check direct host match
        if (strcmp(provider->host, ip) == 0) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        
        // Check if IP is in auth_data for IP auth
        if (strcmp(provider->auth_type, "ip") == 0 && 
            strstr(provider->auth_data, ip) != NULL) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return NULL;
}

// Find provider by role
static provider_t* find_provider_by_role(sip_server_t *server, const char *role) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    provider_t *selected = NULL;
    int min_calls = INT_MAX;
    
    // Find the provider with the specified role that has the least current calls
    while (provider) {
        if (strcmp(provider->role, role) == 0 && provider->active) {
            if (provider->current_calls < min_calls && 
                provider->current_calls < provider->capacity) {
                selected = provider;
                min_calls = provider->current_calls;
            }
        }
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return selected;
}

// Allocate DID from pool
static did_t* allocate_did(sip_server_t *server, const char *ani, const char *dnis, const char *call_id) {
    pthread_mutex_lock(&server->did_mutex);
    
    did_t *did = server->dids;
    did_t *selected = NULL;
    
    while (did) {
        if (!did->in_use && did->active) {
            selected = did;
            break;
        }
        did = did->next;
    }
    
    if (selected) {
        // Update DID in memory
        selected->in_use = true;
        selected->allocated_at = time(NULL);
        strncpy(selected->destination, dnis, sizeof(selected->destination) - 1);
        strncpy(selected->original_ani, ani, sizeof(selected->original_ani) - 1);
        strncpy(selected->call_id, call_id, sizeof(selected->call_id) - 1);
        
        // Update database
        char query[1024];
        snprintf(query, sizeof(query),
                "UPDATE dids SET in_use = true, destination = '%s', "
                "original_ani = '%s', call_id = '%s', allocated_at = CURRENT_TIMESTAMP "
                "WHERE id = %d",
                dnis, ani, call_id, selected->id);
        
        db_query(server->db, query);
        
        LOG_INFO("Allocated DID %s for call %s (ANI: %s, DNIS: %s)", 
                selected->did, call_id, ani, dnis);
    }
    
    pthread_mutex_unlock(&server->did_mutex);
    return selected;
}

// Release DID back to pool
static void release_did(sip_server_t *server, const char *did_number) {
    pthread_mutex_lock(&server->did_mutex);
    
    did_t *did = server->dids;
    while (did) {
        if (strcmp(did->did, did_number) == 0) {
            // Update DID in memory
            did->in_use = false;
            memset(did->destination, 0, sizeof(did->destination));
            memset(did->original_ani, 0, sizeof(did->original_ani));
            memset(did->call_id, 0, sizeof(did->call_id));
            did->allocated_at = 0;
            
            // Update database
            char query[512];
            snprintf(query, sizeof(query),
                    "UPDATE dids SET in_use = false, destination = NULL, "
                    "original_ani = NULL, call_id = NULL, allocated_at = NULL "
                    "WHERE id = %d",
                    did->id);
            
            db_query(server->db, query);
            
            LOG_INFO("Released DID %s", did_number);
            break;
        }
        did = did->next;
    }
    
    pthread_mutex_unlock(&server->did_mutex);
}

// Create call record in database
static void create_call_record(sip_server_t *server, const char *call_id, 
                              const char *ani, const char *dnis, const char *did,
                              int origin_id, int inter_id, int final_id) {
    char query[1024];
    snprintf(query, sizeof(query),
            "INSERT INTO call_records (call_id, original_ani, original_dnis, assigned_did, "
            "origin_provider_id, intermediate_provider_id, final_provider_id, status, stage) "
            "VALUES ('%s', '%s', '%s', '%s', %d, %d, %d, 'routing', 1)",
            call_id, ani, dnis, did, origin_id, inter_id, final_id);
    
    db_query(server->db, query);
}

// Update call record stage
static void update_call_record_stage(sip_server_t *server, const char *call_id, int stage) {
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_records SET stage = %d, updated_at = CURRENT_TIMESTAMP "
            "WHERE call_id = '%s'",
            stage, call_id);
    
    db_query(server->db, query);
}

// Extract SIP header value
static char* extract_sip_header(const char *message, const char *header) {
    static char value[256];
    char search[128];
    
    snprintf(search, sizeof(search), "%s:", header);
    const char *pos = strstr(message, search);
    if (!pos) return NULL;
    
    pos += strlen(search);
    while (*pos == ' ') pos++;
    
    const char *end = strchr(pos, '\r');
    if (!end) end = strchr(pos, '\n');
    if (!end) return NULL;
    
    size_t len = end - pos;
    if (len >= sizeof(value)) len = sizeof(value) - 1;
    
    memcpy(value, pos, len);
    value[len] = '\0';
    
    return value;
}

// Extract call ID from SIP message
static char* extract_call_id(const char *message) {
    return extract_sip_header(message, "Call-ID");
}

// Get source IP from socket address
static char* get_source_ip(struct sockaddr_in *addr) {
    static char ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &addr->sin_addr, ip, sizeof(ip));
    return ip;
}

// Create SIP response
static char* create_sip_response(int code, const char *reason, const char *call_id) {
    static char response[1024];
    
    snprintf(response, sizeof(response),
            "SIP/2.0 %d %s\r\n"
            "Via: SIP/2.0/UDP %s:%d\r\n"
            "Call-ID: %s\r\n"
            "Content-Length: 0\r\n"
            "\r\n",
            code, reason, "10.0.0.2", SIP_PORT, call_id ? call_id : "unknown");
    
    return response;
}

// Handle SIP INVITE
static void handle_sip_invite(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    char *source_ip = get_source_ip(from_addr);
    char *call_id = extract_call_id(message);
    char *from = extract_sip_header(message, "From");
    char *to = extract_sip_header(message, "To");
    
    LOG_INFO("INVITE from %s: From=%s, To=%s, Call-ID=%s", source_ip, from, to, call_id);
    
    // Find source provider by IP
    provider_t *source_provider = find_provider_by_ip(server, source_ip);
    if (!source_provider) {
        LOG_WARN("Unknown source IP: %s", source_ip);
        
        // Send 403 Forbidden
        char *response = create_sip_response(403, "Forbidden", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.failed_calls++;
        return;
    }
    
    LOG_INFO("Call from provider: %s (ID: %d, Role: %s, UUID: %s)", 
            source_provider->name, source_provider->id, source_provider->role, source_provider->uuid);
    
    // Route based on provider role from database
    if (strcmp(source_provider->role, "origin") == 0) {
        // Origin -> Intermediate flow (S1 -> S2 -> S3)
        
        // Find intermediate provider
        provider_t *intermediate = find_provider_by_role(server, "intermediate");
        if (!intermediate) {
            LOG_ERROR("No intermediate provider available");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Find final provider for complete route
        provider_t *final = find_provider_by_role(server, "final");
        if (!final) {
            LOG_ERROR("No final provider available");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Allocate DID
        did_t *did = allocate_did(server, from, to, call_id);
        if (!did) {
            LOG_ERROR("No available DID");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Create call state
        call_state_t *call = calloc(1, sizeof(call_state_t));
        strncpy(call->call_id, call_id, sizeof(call->call_id) - 1);
        strncpy(call->original_ani, from, sizeof(call->original_ani) - 1);
        strncpy(call->original_dnis, to, sizeof(call->original_dnis) - 1);
        strncpy(call->assigned_did, did->did, sizeof(call->assigned_did) - 1);
        call->origin_provider_id = source_provider->id;
        call->intermediate_provider_id = intermediate->id;
        call->final_provider_id = final->id;
        call->stage = 1;
        call->created_at = time(NULL);
        
        pthread_mutex_lock(&server->call_mutex);
        call->next = server->active_calls;
        server->active_calls = call;
        pthread_mutex_unlock(&server->call_mutex);
        
        // Create call record in database
        create_call_record(server, call_id, from, to, did->did,
                          source_provider->id, intermediate->id, final->id);
        
        // Update provider call counts
        source_provider->current_calls++;
        intermediate->current_calls++;
        
        LOG_INFO("Routing S1->S3: %s -> %s (DID: %s)", 
                source_provider->name, intermediate->name, did->did);
        
        // Send 100 Trying
        char *response = create_sip_response(100, "Trying", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        // In production, would forward actual INVITE to intermediate
        // For now, send 302 redirect
        response = create_sip_response(302, "Moved Temporarily", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.forwarded_calls++;
        
    } else if (strcmp(source_provider->role, "intermediate") == 0) {
        // Intermediate -> Final flow (S3 -> S2 -> S4)
        
        // Find the call state
        pthread_mutex_lock(&server->call_mutex);
        call_state_t *call = server->active_calls;
        call_state_t *found_call = NULL;
        
        while (call) {
            if (strcmp(call->call_id, call_id) == 0) {
                found_call = call;
                break;
            }
            call = call->next;
        }
        pthread_mutex_unlock(&server->call_mutex);
        
        if (!found_call) {
            LOG_ERROR("Call state not found for call_id: %s", call_id);
            char *response = create_sip_response(404, "Not Found", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            return;
        }
        
        // Find final provider
        provider_t *final = find_provider_by_id(server, found_call->final_provider_id);
        if (!final) {
            LOG_ERROR("Final provider not found");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Update call stage
        found_call->stage = 2;
        update_call_record_stage(server, call_id, 2);
        
        // Release DID
        release_did(server, found_call->assigned_did);
        
        LOG_INFO("Routing S3->S4: %s -> %s (Restored ANI: %s, DNIS: %s)", 
                source_provider->name, final->name, 
                found_call->original_ani, found_call->original_dnis);
        
        // Send response
        char *response = create_sip_response(302, "Moved Temporarily", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.forwarded_calls++;
    } else {
        LOG_WARN("Provider role '%s' not handled for routing", source_provider->role);
        char *response = create_sip_response(501, "Not Implemented", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
    }
    
    server->stats.total_invites++;
}

// Handle SIP OPTIONS
static void handle_sip_options(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    (void)server;  // Unused
    char *call_id = extract_call_id(message);
    
    // Send 200 OK
    char *response = create_sip_response(200, "OK", call_id);
    sendto(server->socket_fd, response, strlen(response), 0,
           (struct sockaddr*)from_addr, sizeof(*from_addr));
}

// Process SIP message
static void process_sip_message(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    // Extract method
    char method[32];
    if (sscanf(message, "%31s", method) != 1) {
        return;
    }
    
    if (strcmp(method, "INVITE") == 0) {
        handle_sip_invite(server, message, from_addr);
    } else if (strcmp(method, "OPTIONS") == 0) {
        handle_sip_options(server, message, from_addr);
    } else if (strcmp(method, "REGISTER") == 0) {
        // Send 200 OK for REGISTER
        char *call_id = extract_call_id(message);
        char *response = create_sip_response(200, "OK", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
    }
}

// Listen thread
static void* sip_listen_thread(void *arg) {
    sip_server_t *server = (sip_server_t*)arg;
    char buffer[BUFFER_SIZE];
    struct sockaddr_in from_addr;
    socklen_t addr_len = sizeof(from_addr);
    
    LOG_INFO("SIP server listening on port %d", SIP_PORT);
    
    while (server->running) {
        ssize_t len = recvfrom(server->socket_fd, buffer, sizeof(buffer) - 1, 0,
                              (struct sockaddr*)&from_addr, &addr_len);
        
        if (len > 0) {
            buffer[len] = '\0';
            process_sip_message(server, buffer, &from_addr);
        } else if (len < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
            LOG_ERROR("recvfrom error: %s", strerror(errno));
        }
    }
    
    return NULL;
}

// Monitor thread for maintenance
static void* monitor_thread(void *arg) {
    sip_server_t *server = (sip_server_t*)arg;
    
    while (server->running) {
        // Reload data from database every 30 seconds
        load_providers_from_db(server);
        load_dids_from_db(server);
        load_routes_from_db(server);
        
        // Clean up stale DIDs (allocated > 5 minutes ago)
        time_t now = time(NULL);
        pthread_mutex_lock(&server->did_mutex);
        
        did_t *did = server->dids;
        while (did) {
            if (did->in_use && did->allocated_at > 0 && 
                (now - did->allocated_at) > 300) {
                LOG_WARN("Releasing stale DID: %s", did->did);
                release_did(server, did->did);
            }
            did = did->next;
        }
        
        pthread_mutex_unlock(&server->did_mutex);
        
        // Clean up old call states (older than 1 hour)
        pthread_mutex_lock(&server->call_mutex);
        call_state_t **pp = &server->active_calls;
        while (*pp) {
            call_state_t *call = *pp;
            if ((now - call->created_at) > 3600) {
                *pp = call->next;
                
                // Update database
                char query[256];
                snprintf(query, sizeof(query),
                        "UPDATE call_records SET status = 'timeout', ended_at = CURRENT_TIMESTAMP "
                        "WHERE call_id = '%s'",
                        call->call_id);
                db_query(server->db, query);
                
                free(call);
            } else {
                pp = &call->next;
            }
        }
        pthread_mutex_unlock(&server->call_mutex);
        
        sleep(30);
    }
    
    return NULL;
}

// Public functions
sip_server_t* sip_server_create(router_t *router, database_t *db) {
    sip_server_t *server = calloc(1, sizeof(sip_server_t));
    if (!server) return NULL;
    
    server->router = router;
    server->db = db;
    
    // Initialize mutexes
    pthread_mutex_init(&server->provider_mutex, NULL);
    pthread_mutex_init(&server->did_mutex, NULL);
    pthread_mutex_init(&server->route_mutex, NULL);
    pthread_mutex_init(&server->call_mutex, NULL);
    
    // Create UDP socket
    server->socket_fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (server->socket_fd < 0) {
        LOG_ERROR("Failed to create socket: %s", strerror(errno));
        free(server);
        return NULL;
    }
    
    // Set socket options
    int reuse = 1;
    setsockopt(server->socket_fd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    setsockopt(server->socket_fd, SOL_SOCKET, SO_REUSEPORT, &reuse, sizeof(reuse));
    
    // Set non-blocking timeout
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    setsockopt(server->socket_fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    
    // Bind to port
    server->server_addr.sin_family = AF_INET;
    server->server_addr.sin_addr.s_addr = INADDR_ANY;
    server->server_addr.sin_port = htons(SIP_PORT);
    
    if (bind(server->socket_fd, (struct sockaddr*)&server->server_addr, 
             sizeof(server->server_addr)) < 0) {
        LOG_ERROR("Failed to bind to port %d: %s", SIP_PORT, strerror(errno));
        close(server->socket_fd);
        free(server);
        return NULL;
    }
    
    // Load initial data from database
    load_providers_from_db(server);
    load_dids_from_db(server);
    load_routes_from_db(server);
    
    g_sip_server = server;
    
    LOG_INFO("SIP server created on port %d", SIP_PORT);
    return server;
}

void sip_server_destroy(sip_server_t *server) {
    if (!server) return;
    
    sip_server_stop(server);
    
    if (server->socket_fd >= 0) {
        close(server->socket_fd);
    }
    
    // Clean up all linked lists
    pthread_mutex_lock(&server->provider_mutex);
    free_providers(server->providers);
    pthread_mutex_unlock(&server->provider_mutex);
    
    pthread_mutex_lock(&server->did_mutex);
    free_dids(server->dids);
    pthread_mutex_unlock(&server->did_mutex);
    
    pthread_mutex_lock(&server->route_mutex);
    free_routes(server->routes);
    pthread_mutex_unlock(&server->route_mutex);
    
    // Clean up call states
    call_state_t *call = server->active_calls;
    while (call) {
        call_state_t *next = call->next;
        free(call);
        call = next;
    }
    
    pthread_mutex_destroy(&server->provider_mutex);
    pthread_mutex_destroy(&server->did_mutex);
    pthread_mutex_destroy(&server->route_mutex);
    pthread_mutex_destroy(&server->call_mutex);
    
    if (g_sip_server == server) {
        g_sip_server = NULL;
    }
    
    free(server);
}

int sip_server_start(sip_server_t *server) {
    if (!server) return -1;
    
    server->running = 1;
    
    // Start listen thread
    if (pthread_create(&server->listen_thread, NULL, sip_listen_thread, server) != 0) {
        LOG_ERROR("Failed to create listen thread");
        return -1;
    }
    
    // Start monitor thread
    if (pthread_create(&server->monitor_thread, NULL, monitor_thread, server) != 0) {
        LOG_ERROR("Failed to create monitor thread");
        return -1;
    }
    
    LOG_INFO("SIP server started");
    return 0;
}

void sip_server_stop(sip_server_t *server) {
    if (!server) return;
    
    server->running = 0;
    
    // Wait for threads to finish
    pthread_join(server->listen_thread, NULL);
    pthread_join(server->monitor_thread, NULL);
    
    LOG_INFO("SIP server stopped");
}

void sip_server_get_stats(sip_server_t *server, sip_stats_t *stats) {
    if (!server || !stats) return;
    
    stats->total_invites = server->stats.total_invites;
    stats->forwarded_calls = server->stats.forwarded_calls;
    stats->failed_calls = server->stats.failed_calls;
    stats->active = server->running;
}
#include "sip/sip_server.h"
#include <stddef.h>

// Declare as extern - DO NOT define here
// The actual definition is in main.c
extern sip_server_t *g_sip_server;
/**
 * Router Module Test Suite
 * 
 * Tests for the router functionality including routing decisions,
 * statistics, and error handling.
 */

#include <check.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>
#include "router/router.h"
#include "core/config.h"
#include "db/database.h"

// Test globals
static database_t *test_db = NULL;
static router_t *test_router = NULL;
static app_config_t *test_config = NULL;

/**
 * Test setup function - called before each test
 */
void setup(void) {
    // Load test configuration
    test_config = config_load("configs/test_config.json");
    ck_assert_ptr_nonnull(test_config);
    
    // Initialize test database
    test_db = db_init("test_router.db");
    ck_assert_ptr_nonnull(test_db);
    
    // Create router instance
    test_router = router_create(test_db, NULL, NULL);
    ck_assert_ptr_nonnull(test_router);
}

/**
 * Test teardown function - called after each test
 */
void teardown(void) {
    if (test_router) {
        router_destroy(test_router);
        test_router = NULL;
    }
    
    if (test_db) {
        db_close(test_db);
        test_db = NULL;
    }
    
    if (test_config) {
        config_free(test_config);
        test_config = NULL;
    }
}

/**
 * Test router statistics functionality
 */
START_TEST(test_router_statistics) {
    json_object *stats = NULL;
    
    // Get router statistics
    int result = router_get_stats(test_router, &stats);
    ck_assert_int_eq(result, 0);
    ck_assert_ptr_nonnull(stats);
    
    // Verify statistics structure
    ck_assert(json_object_is_type(stats, json_type_object));
    
    // Check for expected statistics fields
    json_object *active_calls = NULL;
    ck_assert(json_object_object_get_ex(stats, "active_calls", &active_calls));
    ck_assert(json_object_is_type(active_calls, json_type_int));
    
    json_object *total_calls = NULL;
    ck_assert(json_object_object_get_ex(stats, "total_calls", &total_calls));
    ck_assert(json_object_is_type(total_calls, json_type_int));
    
    // Clean up
    json_object_put(stats);
}
END_TEST

/**
 * Test basic routing functionality
 */
START_TEST(test_basic_routing) {
    route_request_t request = {0};
    
    // Set up test request
    request.ani = "15551234567";
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    // Perform routing
    int result = router_route_call(test_router, &request);
    
    // Should succeed or fail gracefully
    ck_assert(result == 0 || result == -1);
    
    // Clean up allocated route_type if routing succeeded
    if (result == 0 && request.route_type) {
        free(request.route_type);
    }
}
END_TEST

/**
 * Test routing with invalid parameters
 */
START_TEST(test_invalid_routing) {
    route_request_t request = {0};
    
    // Test with NULL ANI
    request.ani = NULL;
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    int result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail
    
    // Test with NULL DNIS
    request.ani = "15551234567";
    request.dnis = NULL;
    request.provider = "test_provider";
    request.route_type = NULL;
    
    result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail
}
END_TEST

/**
 * Test router with NULL database
 */
START_TEST(test_null_database_handling) {
    router_t *null_router = router_create(NULL, NULL, NULL);
    ck_assert_ptr_null(null_router); // Should fail to create
}
END_TEST

/**
 * Test route request validation
 */
START_TEST(test_route_validation) {
    route_request_t request = {0};
    
    // Test with empty strings
    request.ani = "";
    request.dnis = "";
    request.provider = "";
    request.route_type = NULL;
    
    int result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail with empty strings
    
    // Test with very long strings
    char long_ani[1000];
    memset(long_ani, 'x', sizeof(long_ani) - 1);
    long_ani[sizeof(long_ani) - 1] = '\0';
    
    request.ani = long_ani;
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    result = router_route_call(test_router, &request);
    // Should handle gracefully (either succeed or fail, but not crash)
    ck_assert(result == 0 || result == -1);
    
    if (result == 0 && request.route_type) {
        free(request.route_type);
    }
}
END_TEST

/**
 * Create test suite
 */
Suite *router_suite(void) {
    Suite *s = suite_create("Router");
    
    // Basic functionality test case
    TCase *tc_basic = tcase_create("Basic");
    tcase_add_checked_fixture(tc_basic, setup, teardown);
    tcase_add_test(tc_basic, test_router_statistics);
    tcase_add_test(tc_basic, test_basic_routing);
    suite_add_tcase(s, tc_basic);
    
    // Error handling test case
    TCase *tc_error = tcase_create("Error Handling");
    tcase_add_checked_fixture(tc_error, setup, teardown);
    tcase_add_test(tc_error, test_invalid_routing);
    tcase_add_test(tc_error, test_route_validation);
    suite_add_tcase(s, tc_error);
    
    // Edge cases test case
    TCase *tc_edge = tcase_create("Edge Cases");
    tcase_add_test(tc_edge, test_null_database_handling);
    suite_add_tcase(s, tc_edge);
    
    return s;
}

/**
 * Main test runner
 */
int main(void) {
    int number_failed = 0;
    
    // Create and run test suite
    Suite *s = router_suite();
    SRunner *sr = srunner_create(s);
    
    // Run tests with normal verbosity
    srunner_run_all(sr, CK_NORMAL);
    
    // Get test results
    number_failed = srunner_ntests_failed(sr);
    
    // Clean up test runner
    srunner_free(sr);
    
    // Return appropriate exit code
    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>
#include <pthread.h>
#include "utils/logger.h"

static FILE *log_file = NULL;
static pthread_mutex_t log_mutex = PTHREAD_MUTEX_INITIALIZER;

void logger_init(const char *filename) {
    pthread_mutex_lock(&log_mutex);
    if (log_file) {
        fclose(log_file);
    }
    
    if (filename) {
        log_file = fopen(filename, "a");
    }
    pthread_mutex_unlock(&log_mutex);
}

void logger_log(log_level_t level, const char *file, int line, const char *fmt, ...) {
    const char *level_str[] = {"DEBUG", "INFO", "WARN", "ERROR"};
    time_t now = time(NULL);
    struct tm *tm = localtime(&now);
    char timestamp[32];
    va_list args;
    
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", tm);
    
    pthread_mutex_lock(&log_mutex);
    
    FILE *output = log_file ? log_file : stderr;
    
    fprintf(output, "%s [%s] [%s:%d] ", timestamp, level_str[level], file, line);
    
    va_start(args, fmt);
    vfprintf(output, fmt, args);
    va_end(args);
    
    fprintf(output, "\n");
    fflush(output);
    
    pthread_mutex_unlock(&log_mutex);
}

void logger_close(void) {
    pthread_mutex_lock(&log_mutex);
    if (log_file) {
        fclose(log_file);
        log_file = NULL;
    }
    pthread_mutex_unlock(&log_mutex);
}
// src/validation/call_validator.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include "validation/call_validator.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

// Helper function to find validation record
static call_validation_record_t* find_validation_record(call_validator_t *validator, 
                                                        const char *call_id) {
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t *record = validator->active_validations;
    while (record) {
        if (strcmp(record->call_id, call_id) == 0) {
            pthread_mutex_unlock(&validator->validation_mutex);
            return record;
        }
        record = record->next;
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    return NULL;
}

// Helper function to create validation record
static call_validation_record_t* create_validation_record(const char *call_id,
                                                          const char *ani,
                                                          const char *dnis) {
    call_validation_record_t *record = calloc(1, sizeof(call_validation_record_t));
    if (!record) return NULL;
    
    strncpy(record->call_id, call_id, sizeof(record->call_id) - 1);
    strncpy(record->origin_ani, ani, sizeof(record->origin_ani) - 1);
    strncpy(record->origin_dnis, dnis, sizeof(record->origin_dnis) - 1);
    
    record->current_state = CALL_STATE_ORIGINATED;
    record->expected_state = CALL_STATE_RINGING;
    record->originated_at = time(NULL);
    record->state_timestamp = record->originated_at;
    record->validation_attempts = 0;
    
    // Generate UUID for tracking
    snprintf(record->call_uuid, sizeof(record->call_uuid), 
            "%ld-%s", time(NULL), call_id);
    
    return record;
}

// Validation thread function
static void* validation_thread_func(void *arg) {
    call_validator_t *validator = (call_validator_t*)arg;
    
    LOG_INFO("Call validation thread started");
    
    while (validator->running) {
        time_t now = time(NULL);
        
        pthread_mutex_lock(&validator->validation_mutex);
        
        call_validation_record_t **pp = &validator->active_validations;
        while (*pp) {
            call_validation_record_t *record = *pp;
            bool should_remove = false;
            
            // Check validation timeout (30 seconds without state change)
            if ((now - record->state_timestamp) > 30) {
                if (record->current_state == CALL_STATE_ORIGINATED) {
                    LOG_WARN("Call %s: No ringing confirmation after 30s - forcing hangup",
                            record->call_id);
                    
                    // Log security event
                    log_security_event(validator, "VALIDATION_TIMEOUT", "HIGH",
                                     record->call_id, 
                                     "Call did not progress to ringing state");
                    
                    // Force hangup to avoid charges
                    force_hangup_invalid_call(validator, record->call_id);
                    
                    record->current_state = CALL_STATE_FAILED;
                    validator->stats.failed_validations++;
                    should_remove = true;
                }
            }
            
            // Check for state mismatches
            if (record->current_state != record->expected_state && 
                record->validation_attempts > 3) {
                LOG_ERROR("Call %s: State mismatch detected - Expected: %d, Current: %d",
                         record->call_id, record->expected_state, record->current_state);
                
                log_security_event(validator, "STATE_MISMATCH", "CRITICAL",
                                 record->call_id,
                                 "Call state does not match expected progression");
                
                force_hangup_invalid_call(validator, record->call_id);
                validator->stats.diverted_calls++;
                should_remove = true;
            }
            
            // Perform periodic validation checks
            if ((now - record->last_validation) >= validator->validation_interval_ms / 1000) {
                record->validation_attempts++;
                record->last_validation = now;
                
                // Query destination server for call state
                char query[512];
                snprintf(query, sizeof(query),
                        "SELECT status FROM active_calls "
                        "WHERE call_id = '%s' AND destination_ip = '%s'",
                        record->call_id, record->destination_server_ip);
                
                db_result_t *result = db_query(validator->db, query);
                if (result && result->num_rows > 0) {
                    const char *remote_status = db_get_value(result, 0, 0);
                    
                    // Validate state consistency
                    if (strcmp(remote_status, "ringing") == 0 && 
                        record->current_state == CALL_STATE_ORIGINATED) {
                        record->current_state = CALL_STATE_RINGING;
                        record->expected_state = CALL_STATE_ANSWERED;
                        record->destination_validated = true;
                        LOG_INFO("Call %s: Validated ringing at destination", record->call_id);
                    } else if (strcmp(remote_status, "answered") == 0 &&
                             record->current_state == CALL_STATE_RINGING) {
                        record->current_state = CALL_STATE_ANSWERED;
                        record->expected_state = CALL_STATE_HUNG_UP;
                        record->answered_at = now;
                        LOG_INFO("Call %s: Validated answered at destination", record->call_id);
                    }
                    
                    db_free_result(result);
                } else {
                    LOG_WARN("Call %s: Cannot verify state with destination server",
                            record->call_id);
                }
            }
            
            // Remove completed or failed calls after 60 seconds
            if ((record->current_state == CALL_STATE_HUNG_UP ||
                 record->current_state == CALL_STATE_FAILED) &&
                (now - record->state_timestamp) > 60) {
                should_remove = true;
            }
            
            if (should_remove) {
                *pp = record->next;
                free(record);
            } else {
                pp = &record->next;
            }
        }
        
        pthread_mutex_unlock(&validator->validation_mutex);
        
        // Sleep for validation interval
        usleep(validator->validation_interval_ms * 1000);
    }
    
    LOG_INFO("Call validation thread stopped");
    return NULL;
}

// Public API implementation
call_validator_t* call_validator_create(database_t *db, router_t *router) {
    call_validator_t *validator = calloc(1, sizeof(call_validator_t));
    if (!validator) return NULL;
    
    validator->db = db;
    validator->router = router;
    validator->running = false;
    
    // Default configuration
    validator->validation_interval_ms = 5000;  // Check every 5 seconds
    validator->validation_timeout_ms = 30000;  // 30 second timeout
    validator->max_validation_attempts = 5;
    validator->strict_mode = true;
    
    pthread_mutex_init(&validator->validation_mutex, NULL);
    
    // Create validation tables if they don't exist
    const char *create_tables = 
        "CREATE TABLE IF NOT EXISTS call_validations ("
        "  id SERIAL PRIMARY KEY,"
        "  call_id VARCHAR(256) UNIQUE NOT NULL,"
        "  call_uuid VARCHAR(64),"
        "  origin_ani VARCHAR(64),"
        "  origin_dnis VARCHAR(64),"
        "  assigned_did VARCHAR(64),"
        "  current_state INTEGER,"
        "  validation_status VARCHAR(32),"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
        "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS validation_checkpoints ("
        "  id SERIAL PRIMARY KEY,"
        "  checkpoint_name VARCHAR(128),"
        "  route_id INTEGER,"
        "  call_id VARCHAR(256),"
        "  passed BOOLEAN,"
        "  failure_reason VARCHAR(256),"
        "  checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS security_events ("
        "  id SERIAL PRIMARY KEY,"
        "  event_type VARCHAR(64),"
        "  severity VARCHAR(32),"
        "  call_id VARCHAR(256),"
        "  source_ip VARCHAR(64),"
        "  details TEXT,"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");"
        "CREATE TABLE IF NOT EXISTS call_validation_rules ("
        "  id SERIAL PRIMARY KEY,"
        "  rule_name VARCHAR(128),"
        "  rule_type VARCHAR(64),"
        "  rule_condition TEXT,"
        "  action VARCHAR(64),"
        "  priority INTEGER DEFAULT 100,"
        "  enabled BOOLEAN DEFAULT true,"
        "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ");";
    
    db_query(db, create_tables);
    
    // Insert default validation rules
    const char *default_rules = 
        "INSERT INTO call_validation_rules (rule_name, rule_type, rule_condition, action, priority) "
        "VALUES "
        "('Check Origin Server', 'origin_validation', 'source_ip IN (SELECT host FROM providers WHERE role = ''origin'')', 'allow', 100),"
        "('Verify DID Ownership', 'did_validation', 'did IN (SELECT did FROM dids WHERE active = true)', 'allow', 90),"
        "('Rate Limit Check', 'rate_limit', 'calls_per_minute < 100', 'allow', 80),"
        "('Concurrent Call Limit', 'concurrent_limit', 'concurrent_calls < 500', 'allow', 70),"
        "('Blocked Number Check', 'blacklist', 'ani NOT IN (SELECT number FROM blocked_numbers)', 'allow', 60)"
        "ON CONFLICT DO NOTHING;";
    
    db_query(db, default_rules);
    
    LOG_INFO("Call validator created with interval=%dms, timeout=%dms",
            validator->validation_interval_ms, validator->validation_timeout_ms);
    
    return validator;
}

void call_validator_destroy(call_validator_t *validator) {
    if (!validator) return;
    
    call_validator_stop(validator);
    
    // Clean up active validations
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t *record = validator->active_validations;
    while (record) {
        call_validation_record_t *next = record->next;
        free(record);
        record = next;
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    pthread_mutex_destroy(&validator->validation_mutex);
    
    free(validator);
}

int call_validator_start(call_validator_t *validator) {
    if (!validator || validator->running) return -1;
    
    validator->running = true;
    
    if (pthread_create(&validator->validation_thread, NULL, 
                      validation_thread_func, validator) != 0) {
        LOG_ERROR("Failed to create validation thread");
        validator->running = false;
        return -1;
    }
    
    LOG_INFO("Call validator started");
    return 0;
}

void call_validator_stop(call_validator_t *validator) {
    if (!validator || !validator->running) return;
    
    validator->running = false;
    pthread_join(validator->validation_thread, NULL);
    
    LOG_INFO("Call validator stopped");
}

// Validate call initiation
validation_result_t validate_call_initiation(call_validator_t *validator,
                                            const char *call_id,
                                            const char *ani,
                                            const char *dnis,
                                            const char *source_ip) {
    if (!validator || !call_id || !ani || !dnis || !source_ip) {
        return VALIDATION_FAILED;
    }
    
    LOG_INFO("Validating call initiation: ID=%s, ANI=%s, DNIS=%s, Source=%s",
            call_id, ani, dnis, source_ip);
    
    // Check if source IP is authorized
    if (!verify_server_authorization(validator, source_ip, call_id)) {
        LOG_ERROR("Call %s: Unauthorized source IP %s", call_id, source_ip);
        log_security_event(validator, "UNAUTHORIZED_SOURCE", "CRITICAL",
                         call_id, "Unauthorized source IP attempted call");
        return VALIDATION_UNAUTHORIZED;
    }
    
    // Create validation record
    call_validation_record_t *record = create_validation_record(call_id, ani, dnis);
    if (!record) {
        LOG_ERROR("Failed to create validation record for call %s", call_id);
        return VALIDATION_FAILED;
    }
    
    strncpy(record->origin_server_ip, source_ip, sizeof(record->origin_server_ip) - 1);
    record->origin_validated = true;
    
    // Add to active validations
    pthread_mutex_lock(&validator->validation_mutex);
    record->next = validator->active_validations;
    validator->active_validations = record;
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Record in database
    char query[1024];
    snprintf(query, sizeof(query),
            "INSERT INTO call_validations (call_id, call_uuid, origin_ani, origin_dnis, "
            "current_state, validation_status) "
            "VALUES ('%s', '%s', '%s', '%s', %d, 'active')",
            call_id, record->call_uuid, ani, dnis, CALL_STATE_ORIGINATED);
    
    db_query(validator->db, query);
    
    // Record checkpoint
    record_validation_checkpoint(validator, "call_initiated", 0, call_id, true, NULL);
    
    validator->stats.total_validations++;
    
    return VALIDATION_SUCCESS;
}

// Validate call progress
validation_result_t validate_call_progress(call_validator_t *validator,
                                          const char *call_id,
                                          call_state_t new_state,
                                          const char *server_ip) {
    if (!validator || !call_id || !server_ip) {
        return VALIDATION_FAILED;
    }
    
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (!record) {
        LOG_ERROR("Call %s: No validation record found", call_id);
        return VALIDATION_FAILED;
    }
    
    // Verify state progression is valid
    bool valid_transition = false;
    
    switch (record->current_state) {
        case CALL_STATE_ORIGINATED:
            valid_transition = (new_state == CALL_STATE_RINGING);
            break;
        case CALL_STATE_RINGING:
            valid_transition = (new_state == CALL_STATE_ANSWERED || 
                              new_state == CALL_STATE_HUNG_UP);
            break;
        case CALL_STATE_ANSWERED:
            valid_transition = (new_state == CALL_STATE_HUNG_UP);
            break;
        default:
            valid_transition = false;
    }
    
    if (!valid_transition) {
        LOG_ERROR("Call %s: Invalid state transition from %d to %d",
                 call_id, record->current_state, new_state);
        
        log_security_event(validator, "INVALID_STATE_TRANSITION", "HIGH",
                         call_id, "Invalid call state progression detected");
        
        record_validation_checkpoint(validator, "state_transition", 0, call_id, 
                                   false, "Invalid state transition");
        
        return VALIDATION_MISMATCH;
    }
    
    // Update state
    pthread_mutex_lock(&validator->validation_mutex);
    record->current_state = new_state;
    record->state_timestamp = time(NULL);
    
    if (new_state == CALL_STATE_ANSWERED) {
        record->answered_at = record->state_timestamp;
    } else if (new_state == CALL_STATE_HUNG_UP) {
        record->ended_at = record->state_timestamp;
        if (record->answered_at > 0) {
            record->duration_ms = (record->ended_at - record->answered_at) * 1000;
        }
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Update database
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_validations SET current_state = %d, updated_at = CURRENT_TIMESTAMP "
            "WHERE call_id = '%s'",
            new_state, call_id);
    
    db_query(validator->db, query);
    
    // Record checkpoint
    char checkpoint_name[128];
    snprintf(checkpoint_name, sizeof(checkpoint_name), "state_%d", new_state);
    record_validation_checkpoint(validator, checkpoint_name, 0, call_id, true, NULL);
    
    LOG_INFO("Call %s: State updated to %d", call_id, new_state);
    
    return VALIDATION_SUCCESS;
}

// Validate call routing
validation_result_t validate_call_routing(call_validator_t *validator,
                                         const char *call_id,
                                         const char *expected_destination,
                                         const char *actual_destination) {
    if (!validator || !call_id || !expected_destination || !actual_destination) {
        return VALIDATION_FAILED;
    }
    
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (!record) {
        LOG_ERROR("Call %s: No validation record found", call_id);
        return VALIDATION_FAILED;
    }
    
    // Check if actual destination matches expected
    if (strcmp(expected_destination, actual_destination) != 0) {
        LOG_ERROR("Call %s: Route mismatch - Expected: %s, Actual: %s",
                 call_id, expected_destination, actual_destination);
        
        log_security_event(validator, "ROUTE_DIVERSION", "CRITICAL",
                         call_id, "Call diverted to unexpected destination");
        
        record_validation_checkpoint(validator, "route_validation", 0, call_id,
                                   false, "Destination mismatch");
        
        // Mark as diverted and force hangup
        pthread_mutex_lock(&validator->validation_mutex);
        record->current_state = CALL_STATE_DIVERTED;
        pthread_mutex_unlock(&validator->validation_mutex);
        
        force_hangup_invalid_call(validator, call_id);
        
        validator->stats.diverted_calls++;
        
        return VALIDATION_DIVERTED;
    }
    
    // Update validation record
    pthread_mutex_lock(&validator->validation_mutex);
    strncpy(record->destination_server_ip, actual_destination, 
           sizeof(record->destination_server_ip) - 1);
    record->route_validated = true;
    pthread_mutex_unlock(&validator->validation_mutex);
    
    record_validation_checkpoint(validator, "route_validation", 0, call_id,
                               true, NULL);
    
    LOG_INFO("Call %s: Route validated to %s", call_id, actual_destination);
    
    return VALIDATION_SUCCESS;
}

// Validate DID assignment
validation_result_t validate_did_assignment(call_validator_t *validator,
                                           const char *call_id,
                                           const char *did,
                                           const char *server_ip) {
    if (!validator || !call_id || !did || !server_ip) {
        return VALIDATION_FAILED;
    }
    
    // Check DID ownership and availability
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id, in_use, call_id FROM dids WHERE did = '%s' AND active = true",
            did);
    
    db_result_t *result = db_query(validator->db, query);
    if (!result || result->num_rows == 0) {
        LOG_ERROR("Call %s: DID %s not found or inactive", call_id, did);
        
        log_security_event(validator, "INVALID_DID", "HIGH",
                         call_id, "Attempted to use invalid or inactive DID");
        
        db_free_result(result);
        return VALIDATION_FAILED;
    }
    
    // Check if DID is already in use
    int in_use = atoi(db_get_value(result, 0, 1));
    const char *existing_call_id = db_get_value(result, 0, 2);
    
    if (in_use && existing_call_id && strcmp(existing_call_id, call_id) != 0) {
        LOG_ERROR("Call %s: DID %s already in use by call %s",
                 call_id, did, existing_call_id);
        
        log_security_event(validator, "DID_COLLISION", "HIGH",
                         call_id, "DID already assigned to another call");
        
        db_free_result(result);
        return VALIDATION_FAILED;
    }
    
    db_free_result(result);
    
    // Update validation record
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record) {
        pthread_mutex_lock(&validator->validation_mutex);
        strncpy(record->assigned_did, did, sizeof(record->assigned_did) - 1);
        record->did_ownership_verified = true;
        pthread_mutex_unlock(&validator->validation_mutex);
    }
    
    record_validation_checkpoint(validator, "did_assignment", 0, call_id,
                               true, NULL);
    
    LOG_INFO("Call %s: DID %s assignment validated", call_id, did);
    
    return VALIDATION_SUCCESS;
}

// Update call state
int update_call_state(call_validator_t *validator,
                     const char *call_id,
                     call_state_t new_state) {
    return validate_call_progress(validator, call_id, new_state, "127.0.0.1");
}

// Get call state
call_state_t get_call_state(call_validator_t *validator,
                           const char *call_id) {
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record) {
        return record->current_state;
    }
    return CALL_STATE_HUNG_UP;
}

// Verify server authorization
bool verify_server_authorization(call_validator_t *validator,
                                const char *server_ip,
                                const char *call_id) {
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id FROM providers WHERE host = '%s' AND active = true",
            server_ip);
    
    db_result_t *result = db_query(validator->db, query);
    bool authorized = (result && result->num_rows > 0);
    
    if (!authorized) {
        LOG_WARN("Server %s not authorized for call %s", server_ip, call_id);
    }
    
    if (result) db_free_result(result);
    return authorized;
}

// Verify route integrity
bool verify_route_integrity(call_validator_t *validator,
                           const char *call_id,
                           int origin_id,
                           int intermediate_id,
                           int final_id) {
    // Verify that the route exists and is active
    char query[512];
    snprintf(query, sizeof(query),
            "SELECT id FROM routes WHERE "
            "origin_provider_id = %d AND "
            "intermediate_provider_id = %d AND "
            "final_provider_id = %d AND "
            "active = true",
            origin_id, intermediate_id, final_id);
    
    db_result_t *result = db_query(validator->db, query);
    bool valid = (result && result->num_rows > 0);
    
    if (!valid) {
        LOG_ERROR("Call %s: Route integrity check failed for %d->%d->%d",
                 call_id, origin_id, intermediate_id, final_id);
    }
    
    if (result) db_free_result(result);
    return valid;
}

// Log security event
void log_security_event(call_validator_t *validator,
                       const char *event_type,
                       const char *severity,
                       const char *call_id,
                       const char *details) {
    char query[1024];
    char escaped_details[1024];
    
    // Escape single quotes in details
    const char *src = details;
    char *dst = escaped_details;
    while (*src && (dst - escaped_details) < 1022) {
        if (*src == '\'') {
            *dst++ = '\'';
            *dst++ = '\'';
        } else {
            *dst++ = *src;
        }
        src++;
    }
    *dst = '\0';
    
    snprintf(query, sizeof(query),
            "INSERT INTO security_events (event_type, severity, call_id, details) "
            "VALUES ('%s', '%s', '%s', '%s')",
            event_type, severity, call_id, escaped_details);
    
    db_query(validator->db, query);
    
    validator->stats.security_events++;
    
    LOG_WARN("SECURITY EVENT: Type=%s, Severity=%s, Call=%s, Details=%s",
            event_type, severity, call_id, details);
}

// Record validation checkpoint
void record_validation_checkpoint(call_validator_t *validator,
                                 const char *checkpoint_name,
                                 int route_id,
                                 const char *call_id,
                                 bool passed,
                                 const char *failure_reason) {
    char query[1024];
    
    if (failure_reason) {
        char escaped_reason[512];
        const char *src = failure_reason;
        char *dst = escaped_reason;
        while (*src && (dst - escaped_reason) < 510) {
            if (*src == '\'') {
                *dst++ = '\'';
                *dst++ = '\'';
            } else {
                *dst++ = *src;
            }
            src++;
        }
        *dst = '\0';
        
        snprintf(query, sizeof(query),
                "INSERT INTO validation_checkpoints "
                "(checkpoint_name, route_id, call_id, passed, failure_reason) "
                "VALUES ('%s', %d, '%s', %s, '%s')",
                checkpoint_name, route_id, call_id, 
                passed ? "true" : "false", escaped_reason);
    } else {
        snprintf(query, sizeof(query),
                "INSERT INTO validation_checkpoints "
                "(checkpoint_name, route_id, call_id, passed) "
                "VALUES ('%s', %d, '%s', %s)",
                checkpoint_name, route_id, call_id, 
                passed ? "true" : "false");
    }
    
    db_query(validator->db, query);
    
    LOG_DEBUG("Checkpoint %s for call %s: %s",
             checkpoint_name, call_id, passed ? "PASSED" : "FAILED");
}

// Get validation statistics
void get_validation_stats(call_validator_t *validator,
                         uint64_t *total,
                         uint64_t *successful,
                         uint64_t *failed,
                         uint64_t *diverted) {
    if (total) *total = validator->stats.total_validations;
    if (successful) *successful = validator->stats.successful_validations;
    if (failed) *failed = validator->stats.failed_validations;
    if (diverted) *diverted = validator->stats.diverted_calls;
}

// Clean up expired validations
void cleanup_expired_validations(call_validator_t *validator) {
    time_t now = time(NULL);
    time_t expiry_time = now - 3600; // 1 hour expiry
    
    pthread_mutex_lock(&validator->validation_mutex);
    
    call_validation_record_t **pp = &validator->active_validations;
    while (*pp) {
        call_validation_record_t *record = *pp;
        
        if (record->ended_at > 0 && record->ended_at < expiry_time) {
            *pp = record->next;
            
            // Update database
            char query[512];
            snprintf(query, sizeof(query),
                    "UPDATE call_validations SET validation_status = 'expired' "
                    "WHERE call_id = '%s'",
                    record->call_id);
            db_query(validator->db, query);
            
            free(record);
        } else {
            pp = &record->next;
        }
    }
    
    pthread_mutex_unlock(&validator->validation_mutex);
    
    // Clean up old database records
    char query[256];
    snprintf(query, sizeof(query),
            "DELETE FROM call_validations WHERE created_at < NOW() - INTERVAL '24 hours'");
    db_query(validator->db, query);
    
    snprintf(query, sizeof(query),
            "DELETE FROM validation_checkpoints WHERE checked_at < NOW() - INTERVAL '7 days'");
    db_query(validator->db, query);
    
    snprintf(query, sizeof(query),
            "DELETE FROM security_events WHERE created_at < NOW() - INTERVAL '30 days'");
    db_query(validator->db, query);
}

// Force hangup of invalid call
void force_hangup_invalid_call(call_validator_t *validator, const char *call_id) {
    LOG_WARN("Forcing hangup of invalid call: %s", call_id);
    
    // Send hangup command to FreeSWITCH
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "fs_cli -x 'uuid_kill %s VALIDATION_FAILED'", call_id);
    system(cmd);
    
    // Update call record
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_records SET status = 'failed', ended_at = CURRENT_TIMESTAMP, "
            "failure_reason = 'Validation failed' WHERE call_id = '%s'",
            call_id);
    db_query(validator->db, query);
    
    // Update validation record
    snprintf(query, sizeof(query),
            "UPDATE call_validations SET validation_status = 'failed', "
            "current_state = %d WHERE call_id = '%s'",
            CALL_STATE_FAILED, call_id);
    db_query(validator->db, query);
    
    // Release any assigned DID
    call_validation_record_t *record = find_validation_record(validator, call_id);
    if (record && strlen(record->assigned_did) > 0) {
        snprintf(query, sizeof(query),
                "UPDATE dids SET in_use = false, call_id = NULL, "
                "destination = NULL WHERE did = '%s'",
                record->assigned_did);
        db_query(validator->db, query);
    }
}
// state_sync_service.c - Simplified state synchronization
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "validation/call_validator.h"
#include "db/database.h"
#include "core/logging.h"

typedef struct {
    call_validator_t *validator;
    pthread_t sync_thread;
    bool running;
    int sync_interval_ms;
} state_sync_service_t;

// Synchronize call states (simplified version)
static void sync_call_states(state_sync_service_t *service) {
    database_t *db = service->validator->db;
    
    const char *query = 
        "INSERT INTO call_state_sync (call_id, server_id, reported_state, expected_state, state_matched) "
        "SELECT cr.call_id, cr.intermediate_provider_id, 'simulated', 'ringing', true "
        "FROM call_records cr "
        "WHERE cr.status = 'routing' AND cr.stage = 2 "
        "AND NOT EXISTS (SELECT 1 FROM call_state_sync css "
        "WHERE css.call_id = cr.call_id AND css.checked_at > NOW() - INTERVAL '10 seconds')";
    
    db_query(db, query);
}

static void* sync_thread_func(void *arg) {
    state_sync_service_t *service = (state_sync_service_t*)arg;
    
    LOG_INFO("State synchronization service started (simplified mode)");
    
    while (service->running) {
        sync_call_states(service);
        usleep(service->sync_interval_ms * 1000);
    }
    
    LOG_INFO("State synchronization service stopped");
    return NULL;
}

state_sync_service_t* state_sync_create(call_validator_t *validator) {
    state_sync_service_t *service = calloc(1, sizeof(state_sync_service_t));
    if (!service) return NULL;
    
    service->validator = validator;
    service->sync_interval_ms = 5000;
    service->running = false;
    
    return service;
}

int state_sync_start(state_sync_service_t *service) {
    if (!service || service->running) return -1;
    
    service->running = true;
    
    if (pthread_create(&service->sync_thread, NULL, sync_thread_func, service) != 0) {
        service->running = false;
        return -1;
    }
    
    return 0;
}

void state_sync_stop(state_sync_service_t *service) {
    if (!service || !service->running) return;
    
    service->running = false;
    pthread_join(service->sync_thread, NULL);
}

void state_sync_destroy(state_sync_service_t *service) {
    if (!service) return;
    state_sync_stop(service);
    free(service);
}
#ifndef API_HANDLERS_H
#define API_HANDLERS_H

#include <microhttpd.h>

int handle_api_request(struct MHD_Connection *connection, 
                      const char *url,
                      const char *method,
                      const char *upload_data,
                      size_t *upload_data_size);

#endif
#ifndef CLI_COMMANDS_H
#define CLI_COMMANDS_H

#include "cli.h"

int cli_execute_command(int argc, char *argv[]);

#endif
#ifndef CLI_H
#define CLI_H

#include <stdbool.h>

#define MAX_ARGS 32

typedef struct cli {
    bool running;
} cli_t;

cli_t* cli_create(void);
void cli_destroy(cli_t *cli);
void cli_run(cli_t *cli);
void cli_stop(cli_t *cli);
int cli_execute_command(int argc, char *argv[]);

//extern cli_t *g_cli;

#endif
#ifndef CALLS_CMD_H
#define CALLS_CMD_H

int cmd_calls(int argc, char *argv[]);
int cmd_calls_add(int argc, char *argv[]);
int cmd_calls_delete(int argc, char *argv[]);
int cmd_calls_list(int argc, char *argv[]);
int cmd_calls_show(int argc, char *argv[]);
int cmd_calls_test(int argc, char *argv[]);

#endif
#ifndef DID_CMD_H
#define DID_CMD_H

int cmd_did(int argc, char *argv[]);
int cmd_did_add(int argc, char *argv[]);
int cmd_did_delete(int argc, char *argv[]);
int cmd_did_list(int argc, char *argv[]);
int cmd_did_show(int argc, char *argv[]);
int cmd_did_test(int argc, char *argv[]);

#endif
#ifndef MODULE2_CMD_H
#define MODULE2_CMD_H

int cmd_module2(int argc, char *argv[]);
int cmd_module2_status(int argc, char *argv[]);
int cmd_module2_test(int argc, char *argv[]);
int cmd_module2_monitor(int argc, char *argv[]);
int cmd_module2_validate(int argc, char *argv[]);

#endif
#ifndef MONITOR_CMD_H
#define MONITOR_CMD_H

int cmd_monitor(int argc, char *argv[]);
int cmd_monitor_add(int argc, char *argv[]);
int cmd_monitor_delete(int argc, char *argv[]);
int cmd_monitor_list(int argc, char *argv[]);
int cmd_monitor_show(int argc, char *argv[]);
int cmd_monitor_test(int argc, char *argv[]);

#endif
// include/commands/provider_cmd.h - Fixed with reload function
#ifndef PROVIDER_CMD_H
#define PROVIDER_CMD_H

int cmd_provider(int argc, char *argv[]);
int cmd_provider_add(int argc, char *argv[]);
int cmd_provider_delete(int argc, char *argv[]);
int cmd_provider_list(int argc, char *argv[]);
int cmd_provider_show(int argc, char *argv[]);
int cmd_provider_test(int argc, char *argv[]);
int cmd_provider_reload(int argc, char *argv[]);  // Add missing declaration

#endif
#ifndef ROUTE_CMD_H
#define ROUTE_CMD_H

int cmd_route(int argc, char *argv[]);
int cmd_route_add(int argc, char *argv[]);
int cmd_route_delete(int argc, char *argv[]);
int cmd_route_list(int argc, char *argv[]);
int cmd_route_show(int argc, char *argv[]);
int cmd_route_test(int argc, char *argv[]);
int cmd_route_reload(int argc, char *argv[]);  // Added this

#endif
#ifndef SIP_CMD_H
#define SIP_CMD_H

int cmd_sip(int argc, char *argv[]);

#endif
#ifndef STATS_CMD_H
#define STATS_CMD_H

int cmd_stats(int argc, char *argv[]);
int cmd_stats_add(int argc, char *argv[]);
int cmd_stats_delete(int argc, char *argv[]);
int cmd_stats_list(int argc, char *argv[]);
int cmd_stats_show(int argc, char *argv[]);
int cmd_stats_test(int argc, char *argv[]);

#endif
// include/commands/validation_cmd.h
#ifndef VALIDATION_CMD_H
#define VALIDATION_CMD_H

int cmd_validation(int argc, char *argv[]);
int cmd_validation_status(int argc, char *argv[]);
int cmd_validation_stats(int argc, char *argv[]);
int cmd_validation_rules(int argc, char *argv[]);
int cmd_validation_events(int argc, char *argv[]);
int cmd_validation_test(int argc, char *argv[]);

#endif // VALIDATION_CMD_H
#ifndef CLI_H
#define CLI_H

#include "core/common.h"
#include "core/config.h"

// Forward declarations
typedef struct router router_t;
typedef struct freeswitch_handler freeswitch_handler_t;
typedef struct cli cli_t;

// CLI lifecycle
cli_t* cli_create(router_t *router, freeswitch_handler_t *fs_handler, app_config_t *config);
void cli_destroy(cli_t *cli);

// CLI operations
void cli_run(cli_t *cli);
void cli_stop(cli_t *cli);

// Command execution
int cli_execute_command(cli_t *cli, const char *command);

#endif // CLI_H
#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>
#include <errno.h>
#include <pthread.h>

// Error codes
#define ERR_SUCCESS 0
#define ERR_FAILURE -1
#define ERR_NOT_FOUND -2
#define ERR_TIMEOUT -3
#define ERR_INVALID_PARAM -4
#define ERR_NO_MEMORY -5

// Common macros
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

#endif
#ifndef CONFIG_H
#define CONFIG_H

#include <stdbool.h>

// FreeSWITCH configuration
typedef struct {
    char *host;
    int port;
    char *password;
    int max_connections;
    int event_threads;
} fs_config_t;

// Database configuration
typedef struct {
    char *path;
    int pool_size;
    int max_connections;
    bool wal_mode;
} db_config_t;

// Cache configuration
typedef struct {
    char *host;
    int port;
    int pool_size;
    int db_index;
    char *password;
    int timeout_ms;
} cache_config_t;

// HTTP Server configuration
typedef struct {
    char *listen_address;
    int port;
    int worker_threads;
    int max_connections;
} server_config_t;

// Router configuration
typedef struct {
    int max_routes;
    int max_providers;
    int route_cache_ttl;
    int stats_interval;
    bool enable_failover;
    int failover_timeout;
} router_config_t;

// Main application configuration
typedef struct {
    fs_config_t freeswitch;
    db_config_t database;
    cache_config_t cache;
    server_config_t server;
    router_config_t router;
    char *log_file;
    char *log_level;
} app_config_t;

// Functions
app_config_t* config_load(const char *filename);
void config_free(app_config_t *config);
void config_print(app_config_t *config);

#endif
#ifndef CORE_LOGGING_H
#define CORE_LOGGING_H

// Redirect to the actual logger header
#include "../utils/logger.h"

// Convenience macros
#define LOG_DEBUG(fmt, ...) logger_log(LOG_LEVEL_DEBUG, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
#define LOG_INFO(fmt, ...) logger_log(LOG_LEVEL_INFO, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
#define LOG_WARN(fmt, ...) logger_log(LOG_LEVEL_WARN, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
#define LOG_ERROR(fmt, ...) logger_log(LOG_LEVEL_ERROR, __FILE__, __LINE__, fmt, ##__VA_ARGS__)

#endif
#ifndef MODELS_H
#define MODELS_H

#include <stdbool.h>
#include <time.h>

// Constants
#define MAX_NAME_LEN 256
#define MAX_HOST_LEN 256
#define MAX_USERNAME_LEN 128
#define MAX_PASSWORD_LEN 128
#define MAX_PATTERN_LEN 256
#define MAX_DESCRIPTION_LEN 512
#define MAX_DID_LEN 50

// Provider model
typedef struct {
    int id;
    char name[MAX_NAME_LEN];
    char host[MAX_HOST_LEN];
    int port;
    char username[MAX_USERNAME_LEN];
    char password[MAX_PASSWORD_LEN];
    char transport[16];
    int capacity;
    int current_calls;
    bool active;
    int priority;
    time_t created_at;
    time_t updated_at;
    void *metadata;  // Changed from json_t to void*
} provider_t;

// Route model
typedef struct {
    int id;
    char pattern[MAX_PATTERN_LEN];
    int provider_id;
    int priority;
    char description[MAX_DESCRIPTION_LEN];
    bool active;
    time_t created_at;
} route_t;

// DID model
typedef struct {
    int id;
    char did_number[MAX_DID_LEN];
    int provider_id;
    bool active;
    time_t created_at;
} did_t;

// Call model
typedef struct {
    int id;
    char uuid[256];
    char ani[MAX_DID_LEN];
    char dnis[MAX_DID_LEN];
    char provider[MAX_NAME_LEN];
    int route_id;
    char status[50];
    time_t created_at;
    time_t answered_at;
    time_t ended_at;
    int duration;
} call_t;

// Statistics model
typedef struct {
    int provider_id;
    int total_calls;
    int successful_calls;
    int failed_calls;
    double avg_duration;
    time_t date;
} statistics_t;

// Model functions
provider_t* provider_create(void);
void provider_free(provider_t *provider);

route_t* route_create(void);
void route_free(route_t *route);

did_t* did_create(void);
void did_free(did_t *did);

call_t* call_create(void);
void call_free(call_t *call);

#endif
#ifndef SERVER_H
#define SERVER_H

#include <stdbool.h>
#include "router/router.h"

typedef struct server server_t;

server_t* server_create(int port, router_t *router);
void server_destroy(server_t *server);
int server_start(server_t *server);
void server_stop(server_t *server);
bool server_is_running(server_t *server);

#endif
#ifndef CACHE_H
#define CACHE_H

#include <stddef.h>
#include <stdbool.h>

typedef struct cache cache_t;

cache_t* cache_create(const char *host, int port, int pool_size);
void cache_destroy(cache_t *cache);
int cache_get(cache_t *cache, const char *key, char *value, size_t len);
int cache_set(cache_t *cache, const char *key, const char *value, int ttl);

#endif
#ifndef DATABASE_H
#define DATABASE_H

#include <sqlite3.h>
#include <stdbool.h>

// Forward declaration
typedef struct database database_t;

typedef struct db_result {
    int num_rows;
    int num_cols;
    char **data;
    char **columns;
} db_result_t;

typedef sqlite3_stmt db_stmt_t;

// Database functions
database_t* db_init(const char *db_path);
void db_close(database_t *db);
db_result_t* db_query(database_t *db, const char *query);
void db_free_result(db_result_t *result);
const char* db_get_value(db_result_t *result, int row, int col);

// Prepared statements
db_stmt_t* db_prepare(database_t *db, const char *sql);
int db_bind_string(db_stmt_t *stmt, int index, const char *value);
int db_bind_int(db_stmt_t *stmt, int index, int value);
int db_execute(db_stmt_t *stmt);
db_result_t* db_execute_query(db_stmt_t *stmt);
void db_finalize(db_stmt_t *stmt);

// Global database instance
database_t* get_database(void);

// Additional function for prepared statement queries
db_result_t* db_execute_query(db_stmt_t *stmt);

// Error codes
#define ERR_SUCCESS 0
#define ERR_FAILURE -1

#endif
// include/freeswitch/fs_xml_generator.h
#ifndef FS_XML_GENERATOR_H
#define FS_XML_GENERATOR_H

// Original functions
int fs_init_all_directories(void);
int fs_generate_main_config(void);
int fs_generate_sip_profiles(void);
int fs_generate_dialplan_contexts(void);
int fs_generate_autoload_configs(void);
int fs_generate_provider_config(const char *uuid, const char *name, 
                              const char *host, int port, const char *role,
                              int auth_type, const char *auth_data);
int fs_remove_provider_config(const char *uuid, const char *role);
int fs_regenerate_all_providers(void);
int fs_generate_route_dialplan(void);
int fs_generate_route_handler_lua(void);
int fs_reload_config(void);
int fs_generate_complete_config(void);

// Module 2 specific functions
int fs_generate_module2_route_dialplan(void);
int fs_generate_corrected_lua_handler(void);
int fs_remove_route_dialplan(const char *route_id);
int fs_clear_dialplan_cache(void);
int fs_restore_dialplans_from_cache(void);

#endif
#ifndef LOAD_BALANCER_H
#define LOAD_BALANCER_H

typedef struct load_balancer load_balancer_t;

load_balancer_t* lb_create(void);
void lb_destroy(load_balancer_t *lb);

#endif
#ifndef ROUTER_H
#define ROUTER_H

#include <stdint.h>
#include "db/database.h"

typedef struct router router_t;

typedef struct {
    char *call_id;
    char *ani;
    char *dnis;
    char *provider;
    char *gateway;      // Output parameter - gateway to use
    char *route_type;   // Output parameter - type of route
} route_request_t;

router_t* router_create(database_t *db, void *cache, void *fs_handler);
void router_destroy(router_t *router);
int router_route_call(router_t *router, route_request_t *request);
int router_get_stats(router_t *router, void *stats);

#endif
#ifndef ESL_HANDLER_H
#define ESL_HANDLER_H

#include "core/common.h"
#include "core/config.h"
#include "router/router.h"

#ifdef HAVE_ESL
#include <esl.h>

typedef struct esl_handler esl_handler_t;

// ESL handler management
esl_handler_t* esl_handler_create(const freeswitch_esl_config_t *config, router_t *router);
void esl_handler_destroy(esl_handler_t *handler);

// Connection management
int esl_handler_connect(esl_handler_t *handler);
void esl_handler_disconnect(esl_handler_t *handler);
bool esl_handler_is_connected(esl_handler_t *handler);

// Event handling
int esl_handler_start(esl_handler_t *handler);
void esl_handler_stop(esl_handler_t *handler);

// Command execution
int esl_handler_execute(esl_handler_t *handler, const char *command, char *response, size_t response_size);
int esl_handler_api(esl_handler_t *handler, const char *cmd, const char *args, char *response, size_t response_size);

#else
// Dummy implementations when ESL is not available
typedef struct esl_handler esl_handler_t;
typedef struct freeswitch_esl_config freeswitch_esl_config_t;  // Add this line to declare the type

static inline esl_handler_t* esl_handler_create(const freeswitch_esl_config_t *config, router_t *router) { 
    (void)config;
    (void)router;
    return NULL; 
}
static inline void esl_handler_destroy(esl_handler_t *handler) { 
    (void)handler;
}
static inline int esl_handler_connect(esl_handler_t *handler) { 
    (void)handler;
    return ERR_SUCCESS; 
}
static inline void esl_handler_disconnect(esl_handler_t *handler) { 
    (void)handler;
}
static inline bool esl_handler_is_connected(esl_handler_t *handler) { 
    (void)handler;
    return false; 
}
static inline int esl_handler_start(esl_handler_t *handler) { 
    (void)handler;
    return ERR_SUCCESS; 
}
static inline void esl_handler_stop(esl_handler_t *handler) { 
    (void)handler;
}
#endif

#endif // ESL_HANDLER_H
#ifndef FREESWITCH_HANDLER_H
#define FREESWITCH_HANDLER_H

#include <stdbool.h>

typedef struct freeswitch_handler freeswitch_handler_t;

typedef struct {
    int total_calls;
    int active_calls;
    int failed_calls;
    bool connected;
} fs_stats_t;

// Core functions
freeswitch_handler_t* freeswitch_handler_create(const char *host, int port, const char *password);
void freeswitch_handler_destroy(freeswitch_handler_t *handler);
int freeswitch_handler_connect(freeswitch_handler_t *handler);
int freeswitch_handler_execute(freeswitch_handler_t *handler, const char *command);
int freeswitch_handler_get_stats(freeswitch_handler_t *handler, fs_stats_t *stats);
bool freeswitch_handler_is_connected(freeswitch_handler_t *handler);

// Event loop functions
int freeswitch_handler_start_event_loop(freeswitch_handler_t *handler);
void freeswitch_handler_stop_event_loop(freeswitch_handler_t *handler);

#endif
#ifndef SIP_SERVER_H
#define SIP_SERVER_H
#include <stdint.h>
#include "router/router.h"
#include "db/database.h"

typedef struct sip_server sip_server_t;

typedef struct {
    uint64_t total_invites;
    uint64_t forwarded_calls;
    uint64_t failed_calls;
    int active;
} sip_stats_t;

// SIP server functions
sip_server_t* sip_server_create(router_t *router, database_t *db);
void sip_server_destroy(sip_server_t *server);
int sip_server_start(sip_server_t *server);
void sip_server_stop(sip_server_t *server);
void sip_server_get_stats(sip_server_t *server, sip_stats_t *stats);

#endif // SIP_SERVER_H
#ifndef UTILS_LOGGER_H
#define UTILS_LOGGER_H

#include <stdio.h>

typedef enum {
    LOG_LEVEL_DEBUG,
    LOG_LEVEL_INFO,
    LOG_LEVEL_WARN,
    LOG_LEVEL_ERROR
} log_level_t;

void logger_init(const char *filename);
void logger_log(log_level_t level, const char *file, int line, const char *fmt, ...);
void logger_close(void);

#endif
// include/validation/call_validator.h
#ifndef CALL_VALIDATOR_H
#define CALL_VALIDATOR_H

#include <stdbool.h>
#include <time.h>
#include <pthread.h>
#include "db/database.h"
#include "router/router.h"

// Call states as per PDF requirements
typedef enum {
    CALL_STATE_ORIGINATED = 1,    // Call initiated from origin
    CALL_STATE_RINGING = 2,       // Call ringing at destination
    CALL_STATE_ANSWERED = 3,       // Call answered at destination
    CALL_STATE_HUNG_UP = 4,        // Call ended
    CALL_STATE_FAILED = 5,         // Call failed validation
    CALL_STATE_DIVERTED = 6        // Call was diverted (security issue)
} call_state_t;

// Validation result codes
typedef enum {
    VALIDATION_SUCCESS = 0,
    VALIDATION_FAILED = -1,
    VALIDATION_TIMEOUT = -2,
    VALIDATION_DIVERTED = -3,
    VALIDATION_MISMATCH = -4,
    VALIDATION_UNAUTHORIZED = -5
} validation_result_t;

// Call validation record
typedef struct call_validation_record {
    char call_id[256];
    char call_uuid[64];
    char origin_ani[64];
    char origin_dnis[64];
    char assigned_did[64];
    
    // Server tracking
    int origin_server_id;
    int intermediate_server_id;
    int final_server_id;
    char origin_server_ip[64];
    char destination_server_ip[64];
    
    // State tracking
    call_state_t current_state;
    call_state_t expected_state;
    time_t state_timestamp;
    
    // Validation data
    bool origin_validated;
    bool destination_validated;
    bool route_validated;
    int validation_attempts;
    time_t last_validation;
    
    // Security checks
    bool ip_match_verified;
    bool did_ownership_verified;
    bool route_integrity_verified;
    
    // Statistics
    time_t originated_at;
    time_t answered_at;
    time_t ended_at;
    int duration_ms;
    
    struct call_validation_record *next;
} call_validation_record_t;

// Validation checkpoint structure
typedef struct validation_checkpoint {
    char checkpoint_name[128];
    int route_id;
    char call_id[256];
    bool passed;
    char failure_reason[256];
    time_t checked_at;
} validation_checkpoint_t;

// Security event structure
typedef struct security_event {
    char event_type[64];
    char severity[32];
    char call_id[256];
    char source_ip[64];
    char details[512];
    time_t created_at;
} security_event_t;

// Call validator structure
typedef struct call_validator {
    database_t *db;
    router_t *router;
    
    // Active validation records
    call_validation_record_t *active_validations;
    pthread_mutex_t validation_mutex;
    
    // Validation thread
    pthread_t validation_thread;
    bool running;
    
    // Configuration
    int validation_interval_ms;
    int validation_timeout_ms;
    int max_validation_attempts;
    bool strict_mode;
    
    // Statistics
    struct {
        uint64_t total_validations;
        uint64_t successful_validations;
        uint64_t failed_validations;
        uint64_t diverted_calls;
        uint64_t security_events;
    } stats;
} call_validator_t;

// Public API functions
call_validator_t* call_validator_create(database_t *db, router_t *router);
void call_validator_destroy(call_validator_t *validator);
int call_validator_start(call_validator_t *validator);
void call_validator_stop(call_validator_t *validator);

// Validation operations
validation_result_t validate_call_initiation(call_validator_t *validator,
                                            const char *call_id,
                                            const char *ani,
                                            const char *dnis,
                                            const char *source_ip);

validation_result_t validate_call_progress(call_validator_t *validator,
                                          const char *call_id,
                                          call_state_t new_state,
                                          const char *server_ip);

validation_result_t validate_call_routing(call_validator_t *validator,
                                         const char *call_id,
                                         const char *expected_destination,
                                         const char *actual_destination);

validation_result_t validate_did_assignment(call_validator_t *validator,
                                           const char *call_id,
                                           const char *did,
                                           const char *server_ip);

// State management
int update_call_state(call_validator_t *validator,
                     const char *call_id,
                     call_state_t new_state);

call_state_t get_call_state(call_validator_t *validator,
                           const char *call_id);

// Security operations
bool verify_server_authorization(call_validator_t *validator,
                                const char *server_ip,
                                const char *call_id);

bool verify_route_integrity(call_validator_t *validator,
                           const char *call_id,
                           int origin_id,
                           int intermediate_id,
                           int final_id);

void log_security_event(call_validator_t *validator,
                       const char *event_type,
                       const char *severity,
                       const char *call_id,
                       const char *details);

// Checkpoint operations
void record_validation_checkpoint(call_validator_t *validator,
                                 const char *checkpoint_name,
                                 int route_id,
                                 const char *call_id,
                                 bool passed,
                                 const char *failure_reason);

// Statistics and reporting
void get_validation_stats(call_validator_t *validator,
                         uint64_t *total,
                         uint64_t *successful,
                         uint64_t *failed,
                         uint64_t *diverted);

// Cleanup operations
void cleanup_expired_validations(call_validator_t *validator);
void force_hangup_invalid_call(call_validator_t *validator, const char *call_id);

#endif // CALL_VALIDATOR_H
#ifndef STATE_SYNC_SERVICE_H
#define STATE_SYNC_SERVICE_H

#include "validation/call_validator.h"

typedef struct state_sync_service state_sync_service_t;

state_sync_service_t* state_sync_create(call_validator_t *validator);
int state_sync_start(state_sync_service_t *service);
void state_sync_stop(state_sync_service_t *service);
void state_sync_destroy(state_sync_service_t *service);

#endif
// main.c - Complete Dynamic FreeSWITCH Router with Call Validation System
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/stat.h>
#include "cli/cli.h"
#include "db/database.h"
#include "core/server.h"
#include "router/router.h"
#include "sip/sip_server.h"
#include "sip/freeswitch_handler.h"
#include "core/config.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"
#include "validation/call_validator.h"

// Global instances
cli_t *g_cli = NULL;
static database_t *g_db = NULL;
static router_t *g_router = NULL;
static server_t *g_server = NULL;
sip_server_t *g_sip_server = NULL;
static freeswitch_handler_t *g_fs_handler = NULL;
call_validator_t *g_validator = NULL;  // Global validator instance
static bool running = true;

void signal_handler(int sig) {
    if (sig == SIGINT || sig == SIGTERM) {
        LOG_INFO("Shutting down...");
        running = false;
        if (g_cli) cli_stop(g_cli);
    }
}

static int ensure_freeswitch_running() {
    if (system("pgrep freeswitch > /dev/null 2>&1") != 0) {
        LOG_WARN("FreeSWITCH is not running, attempting to start...");
        if (system("freeswitch -nc -nonat") != 0) {
            LOG_ERROR("Failed to start FreeSWITCH");
            return -1;
        }
        sleep(5);
        if (system("pgrep freeswitch > /dev/null 2>&1") != 0) {
            LOG_ERROR("FreeSWITCH failed to start");
            return -1;
        }
    }
    LOG_INFO("FreeSWITCH is running");
    return 0;
}

static int initialize_freeswitch_config() {
    LOG_INFO("Initializing FreeSWITCH configuration...");
    
    if (fs_init_all_directories() != 0) {
        LOG_ERROR("Failed to initialize directories");
        return -1;
    }
    
    if (fs_generate_main_config() != 0) {
        LOG_ERROR("Failed to generate main config");
        return -1;
    }
    
    if (fs_generate_sip_profiles() != 0) {
        LOG_ERROR("Failed to generate SIP profiles");
        return -1;
    }
    
    if (fs_generate_dialplan_contexts() != 0) {
        LOG_ERROR("Failed to generate dialplan contexts");
        return -1;
    }
    
    if (fs_generate_autoload_configs() != 0) {
        LOG_ERROR("Failed to generate autoload configs");
        return -1;
    }
    
    LOG_INFO("FreeSWITCH base configuration initialized");
    return 0;
}

static int sync_freeswitch_with_database() {
    if (!g_db) return -1;
    
    LOG_INFO("Synchronizing FreeSWITCH with database...");
    LOG_INFO("Generating provider configurations...");
    fs_regenerate_all_providers();
    LOG_INFO("Generating route dialplans...");
    fs_generate_route_dialplan();
    LOG_INFO("Reloading FreeSWITCH...");
    fs_reload_config();
    LOG_INFO("FreeSWITCH synchronized with database");
    return 0;
}

static void print_startup_banner() {
    printf("\n");
    printf("╔════════════════════════════════════════════════════════════╗\n");
    printf("║     FreeSWITCH Dynamic Call Router v3.0                   ║\n");
    printf("║     S1 → S2 → S3 → S2 → S4 Call Flow                      ║\n");
    printf("║     With Call Validation System                           ║\n");
    printf("╚════════════════════════════════════════════════════════════╝\n");
    printf("\n");
}

// Monitor thread for validation system
static void* validation_monitor_thread(void *arg) {
    (void)arg;
    
    LOG_INFO("Validation monitor thread started");
    
    while (running) {
        if (g_validator) {
            // Clean up expired validations every 5 minutes
            cleanup_expired_validations(g_validator);
        }
        
        sleep(300); // 5 minutes
    }
    
    LOG_INFO("Validation monitor thread stopped");
    return NULL;
}

int main(int argc, char *argv[]) {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    print_startup_banner();
    
    logger_init("logs/router.log");
    LOG_INFO("FreeSWITCH Dynamic Router with Validation starting...");
    
    app_config_t *config = config_load("configs/config.json");
    if (!config) {
        LOG_WARN("No config file found, using defaults");
        config = config_load(NULL);
    }
    
    LOG_INFO("Connecting to PostgreSQL database...");
    g_db = db_init(NULL);
    if (!g_db) {
        LOG_ERROR("Failed to connect to database");
        config_free(config);
        return 1;
    }
    LOG_INFO("Database connected successfully");
    
    // Initialize router
    g_router = router_create(g_db, NULL, NULL);
    if (!g_router) {
        LOG_ERROR("Failed to create router");
        db_close(g_db);
        config_free(config);
        return 1;
    }
    LOG_INFO("Router initialized");
    
    // Initialize call validation system
    LOG_INFO("Initializing call validation system...");
    g_validator = call_validator_create(g_db, g_router);
    if (!g_validator) {
        LOG_ERROR("Failed to create call validator");
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        return 1;
    }
    
    if (call_validator_start(g_validator) != 0) {
        LOG_ERROR("Failed to start call validator");
        call_validator_destroy(g_validator);
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        return 1;
    }
    LOG_INFO("Call validation system started");
    
    // Start validation monitor thread
    pthread_t monitor_thread;
    pthread_create(&monitor_thread, NULL, validation_monitor_thread, NULL);
    
    if (argc > 1 && strcmp(argv[1], "-d") != 0 && strcmp(argv[1], "--daemon") != 0) {
        int ret = cli_execute_command(argc - 1, &argv[1]);
        
        // Cleanup
        call_validator_stop(g_validator);
        call_validator_destroy(g_validator);
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        logger_close();
        return ret;
    }
    
    bool daemon_mode = false;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-d") == 0 || strcmp(argv[i], "--daemon") == 0) {
            daemon_mode = true;
            break;
        }
    }
    
    if (daemon_mode || argc == 1) {
        if (ensure_freeswitch_running() != 0) {
            LOG_ERROR("FreeSWITCH is required but not available");
            call_validator_stop(g_validator);
            call_validator_destroy(g_validator);
            router_destroy(g_router);
            db_close(g_db);
            config_free(config);
            return 1;
        }
        
        if (initialize_freeswitch_config() != 0) {
            LOG_ERROR("Failed to initialize FreeSWITCH configuration");
            call_validator_stop(g_validator);
            call_validator_destroy(g_validator);
            router_destroy(g_router);
            db_close(g_db);
            config_free(config);
            return 1;
        }
        
        if (sync_freeswitch_with_database() != 0) {
            LOG_ERROR("Failed to sync FreeSWITCH with database");
        }
    }
    
    if (daemon_mode) {
        LOG_INFO("Starting in daemon mode");
        printf("Running in daemon mode (background)\n");
        printf("Call validation system is active\n");
        
        g_server = server_create(config->server.port, g_router);
        if (g_server) {
            server_start(g_server);
            LOG_INFO("HTTP API server started on port %d", config->server.port);
        }
        
        // Create SIP server with validation
        g_sip_server = sip_server_create(g_router, g_db);
        if (g_sip_server) {
            sip_server_start(g_sip_server);
            LOG_INFO("SIP server started with validation support");
        }
        
        while (running) {
            sleep(1);
        }
    } else {
        printf("Starting interactive CLI...\n");
        printf("Type 'help' for available commands\n");
        printf("Call validation system is active\n\n");
        
        g_cli = cli_create();
        if (g_cli) {
            cli_run(g_cli);
            cli_destroy(g_cli);
        }
    }
    
    LOG_INFO("Shutting down...");
    
    // Stop validation monitor
    running = false;
    pthread_join(monitor_thread, NULL);
    
    // Stop and destroy validation system
    if (g_validator) {
        LOG_INFO("Stopping call validation system...");
        call_validator_stop(g_validator);
        call_validator_destroy(g_validator);
    }
    
    if (g_sip_server) {
        sip_server_stop(g_sip_server);
        sip_server_destroy(g_sip_server);
    }
    
    if (g_server) {
        server_stop(g_server);
        server_destroy(g_server);
    }
    
    if (g_router) {
        router_destroy(g_router);
    }
    
    if (g_db) {
        db_close(g_db);
    }
    
    config_free(config);
    logger_close();
    
    printf("Shutdown complete\n");
    return 0;
}
// Add this to your main.c after the call_validator initialization

#include "validation/state_sync_service.h"

// Add to global variables section
static state_sync_service_t *g_state_sync = NULL;

// Add to main() after call_validator_start(g_validator)
if (g_validator) {
    // Initialize state synchronization service
    g_state_sync = state_sync_create(g_validator);
    if (g_state_sync) {
        if (state_sync_start(g_state_sync) == 0) {
            LOG_INFO("State synchronization service started");
        } else {
            LOG_ERROR("Failed to start state synchronization service");
        }
    }
}

// Add to cleanup section before call_validator_destroy(g_validator)
if (g_state_sync) {
    state_sync_stop(g_state_sync);
    state_sync_destroy(g_state_sync);
    g_state_sync = NULL;
}
