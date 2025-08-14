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
