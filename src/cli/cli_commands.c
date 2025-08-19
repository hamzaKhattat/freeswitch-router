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
