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

int cli_execute_command(int argc, char *argv[]) {
    if (argc == 0) return 0;
    
    if (strcmp(argv[0], "help") == 0) {
        printf("Available commands:\n");
        printf("  provider    Manage providers\n");
        printf("  route       Manage routes (S1→S2→S3→S2→S4)\n");
        printf("  did         Manage DIDs\n");
        printf("  monitor     Monitor system\n");
        printf("  stats       Show statistics\n");
        printf("  calls       Manage calls\n");
        printf("  sip         SIP server status\n");
        return 0;
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
    
    printf("Unknown command: %s\n", argv[0]);
    return -1;
}
