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
