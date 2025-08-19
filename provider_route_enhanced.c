// provider_route_enhanced.c - Enhanced commands to show UUID and config files

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <uuid/uuid.h>
#include "commands/provider_cmd.h"
#include "commands/route_cmd.h"
#include "db/database.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

// Enhanced provider list command showing UUID and config files
int cmd_provider_list_enhanced(int argc, char *argv[]) {
    (void)argc;
    
    // Check for verbose flag
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
        "SELECT name, uuid, host, port, role, auth_type, capacity, "
        "current_calls, active, config_file_path, profile_name, "
        "validation_status, last_validated_at "
        "FROM providers ORDER BY role, name";
    
    db_result_t *result = db_query(db, sql);
    if (!result || result->num_rows == 0) {
        printf("No providers found\n");
        if (result) db_free_result(result);
        return 0;
    }
    
    if (!verbose) {
        // Standard view with UUID
        printf("\n%-20s %-12s %-36s %-20s %-6s %-10s %-8s %-8s %-8s\n", 
               "Name", "Role", "UUID", "Host", "Port", "Auth", "Capacity", "Calls", "Status");
        printf("%-20s %-12s %-36s %-20s %-6s %-10s %-8s %-8s %-8s\n", 
               "--------------------", "------------", "------------------------------------",
               "--------------------", "------", "----------", "--------", "--------", "--------");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("%-20s %-12s %-36s %-20s %-6s %-10s %-8s %-8s %-8s\n", 
                   db_get_value(result, i, 0),  // name
                   db_get_value(result, i, 4),  // role
                   db_get_value(result, i, 1),  // uuid
                   db_get_value(result, i, 2),  // host
                   db_get_value(result, i, 3),  // port
                   db_get_value(result, i, 5),  // auth_type
                   db_get_value(result, i, 6),  // capacity
                   db_get_value(result, i, 7),  // current_calls
                   strcmp(db_get_value(result, i, 8), "t") == 0 ? "Active" : "Inactive");
        }
    } else {
        // Verbose view with config files and validation status
        printf("\nProviders (Verbose Mode)\n");
        printf("========================\n\n");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("Provider: %s\n", db_get_value(result, i, 0));
            printf("  UUID:              %s\n", db_get_value(result, i, 1));
            printf("  Role:              %s\n", db_get_value(result, i, 4));
            printf("  Host:Port:         %s:%s\n", db_get_value(result, i, 2), db_get_value(result, i, 3));
            printf("  Auth Type:         %s\n", db_get_value(result, i, 5));
            printf("  Capacity/Current:  %s/%s\n", db_get_value(result, i, 6), db_get_value(result, i, 7));
            printf("  Status:            %s\n", strcmp(db_get_value(result, i, 8), "t") == 0 ? "Active" : "Inactive");
            printf("  Profile:           %s\n", db_get_value(result, i, 10));
            printf("  Config File:       %s\n", db_get_value(result, i, 9));
            printf("  Validation Status: %s\n", db_get_value(result, i, 11));
            
            const char *last_validated = db_get_value(result, i, 12);
            if (last_validated && strlen(last_validated) > 0) {
                printf("  Last Validated:    %s\n", last_validated);
            }
            
            // Check if config file exists
            if (access(db_get_value(result, i, 9), F_OK) == 0) {
                printf("  Config File Status: ✓ Exists\n");
            } else {
                printf("  Config File Status: ✗ Missing\n");
            }
            
            printf("\n");
        }
    }
    
    printf("\nTotal providers: %d\n", result->num_rows);
    
    // Show validation statistics
    const char *stats_sql = 
        "SELECT COUNT(*) as total, "
        "SUM(CASE WHEN validation_status = 'success' THEN 1 ELSE 0 END) as validated, "
        "SUM(CASE WHEN active = true THEN 1 ELSE 0 END) as active "
        "FROM providers";
    
    db_result_t *stats = db_query(db, stats_sql);
    if (stats && stats->num_rows > 0) {
        printf("Validation Status: %s/%s validated, %s active\n",
               db_get_value(stats, 0, 1),
               db_get_value(stats, 0, 0),
               db_get_value(stats, 0, 2));
        db_free_result(stats);
    }
    
    db_free_result(result);
    
    if (!verbose) {
        printf("\nUse 'provider list -v' for detailed view with config files\n");
    }
    
    return 0;
}

// Enhanced route list command showing dialplan files
int cmd_route_list_enhanced(int argc, char *argv[]) {
    (void)argc;
    
    // Check for verbose flag
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
        "SELECT r.id, r.name, r.uuid, "
        "p1.name as origin, p1.uuid as origin_uuid, "
        "p2.name as intermediate, p2.uuid as inter_uuid, "
        "p3.name as final, p3.uuid as final_uuid, "
        "r.pattern, r.priority, r.active, "
        "r.dialplan_file_path, r.validation_enabled, r.validation_threshold "
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
    
    if (!verbose) {
        // Standard view
        printf("\nRoutes (S1 → S2 → S3 → S2 → S4 flow)\n");
        printf("=====================================\n");
        printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s %-10s\n", 
               "ID", "Name", "Origin", "Intermediate", "Final", "Pattern", "Priority", "Status", "Validation");
        printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s %-10s\n", 
               "-----", "--------------------", "------------", "------------", 
               "------------", "-------------------------", "--------", "--------", "----------");
        
        for (int i = 0; i < result->num_rows; i++) {
            const char *id = db_get_value(result, i, 0);
            const char *name = db_get_value(result, i, 1);
            const char *origin = db_get_value(result, i, 3);
            const char *inter = db_get_value(result, i, 5);
            const char *final = db_get_value(result, i, 7);
            const char *pattern = db_get_value(result, i, 9);
            const char *priority = db_get_value(result, i, 10);
            int active = strcmp(db_get_value(result, i, 11), "t") == 0;
            int validation = strcmp(db_get_value(result, i, 13), "t") == 0;
            
            char pattern_display[26];
            if (strlen(pattern) > 25) {
                strncpy(pattern_display, pattern, 22);
                strcpy(pattern_display + 22, "...");
            } else {
                strcpy(pattern_display, pattern);
            }
            
            printf("%-5s %-20s %-12s %-12s %-12s %-25s %-8s %-8s %-10s\n",
                   id, name, 
                   origin ? origin : "-",
                   inter ? inter : "-",
                   final ? final : "-",
                   pattern_display, priority,
                   active ? "Active" : "Inactive",
                   validation ? "Enabled" : "Disabled");
        }
    } else {
        // Verbose view with UUIDs and dialplan files
        printf("\nRoutes (Verbose Mode with Full Details)\n");
        printf("========================================\n\n");
        
        for (int i = 0; i < result->num_rows; i++) {
            printf("Route ID %s: %s\n", db_get_value(result, i, 0), db_get_value(result, i, 1));
            printf("  Route UUID:        %s\n", db_get_value(result, i, 2) ? db_get_value(result, i, 2) : "Not set");
            printf("  Pattern:           %s\n", db_get_value(result, i, 9));
            printf("  Priority:          %s\n", db_get_value(result, i, 10));
            printf("  Status:            %s\n", strcmp(db_get_value(result, i, 11), "t") == 0 ? "Active" : "Inactive");
            printf("  Validation:        %s (Threshold: %s)\n", 
                   strcmp(db_get_value(result, i, 13), "t") == 0 ? "Enabled" : "Disabled",
                   db_get_value(result, i, 14));
            printf("\n");
            
            printf("  Provider Chain:\n");
            printf("    Origin (S1):     %s [UUID: %s]\n", 
                   db_get_value(result, i, 3) ? db_get_value(result, i, 3) : "Not set",
                   db_get_value(result, i, 4) ? db_get_value(result, i, 4) : "N/A");
            printf("    Intermediate(S3): %s [UUID: %s]\n", 
                   db_get_value(result, i, 5) ? db_get_value(result, i, 5) : "Not set",
                   db_get_value(result, i, 6) ? db_get_value(result, i, 6) : "N/A");
            printf("    Final (S4):      %s [UUID: %s]\n", 
                   db_get_value(result, i, 7) ? db_get_value(result, i, 7) : "Not set",
                   db_get_value(result, i, 8) ? db_get_value(result, i, 8) : "N/A");
            printf("\n");
            
            const char *dialplan_file = db_get_value(result, i, 12);
            printf("  Dialplan File:     %s\n", dialplan_file ? dialplan_file : "Not generated");
            
            // Check if dialplan file exists
            if (dialplan_file && strlen(dialplan_file) > 0) {
                if (access(dialplan_file, F_OK) == 0) {
                    printf("  Dialplan Status:   ✓ File exists\n");
                    
                    // Get file size
                    FILE *fp = fopen(dialplan_file, "r");
                    if (fp) {
                        fseek(fp, 0, SEEK_END);
                        long size = ftell(fp);
                        fclose(fp);
                        printf("  File Size:         %ld bytes\n", size);
                    }
                } else {
                    printf("  Dialplan Status:   ✗ File missing - run 'route reload' to regenerate\n");
                }
            }
            
            // Show validation statistics for this route
            char stats_query[512];
            snprintf(stats_query, sizeof(stats_query),
                    "SELECT COUNT(*) as total, "
                    "SUM(CASE WHEN passed THEN 1 ELSE 0 END) as passed "
                    "FROM validation_checkpoints "
                    "WHERE route_id = %s AND checked_at > NOW() - INTERVAL '24 hours'",
                    db_get_value(result, i, 0));
            
            db_result_t *stats = db_query(db, stats_query);
            if (stats && stats->num_rows > 0 && atoi(db_get_value(stats, 0, 0)) > 0) {
                printf("  Validation (24h):  %s/%s checkpoints passed\n",
                       db_get_value(stats, 0, 1),
                       db_get_value(stats, 0, 0));
                db_free_result(stats);
            }
            
            printf("\n" "  " "─────────────────────────────────────────────\n");
        }
    }
    
    printf("\nTotal routes: %d\n", result->num_rows);
    
    // Show validation summary
    const char *val_sql = 
        "SELECT COUNT(DISTINCT route_id) as routes_validated, "
        "COUNT(*) as total_validations, "
        "AVG(CASE WHEN passed THEN 100 ELSE 0 END) as success_rate "
        "FROM validation_checkpoints "
        "WHERE checked_at > NOW() - INTERVAL '1 hour'";
    
    db_result_t *val_stats = db_query(db, val_sql);
    if (val_stats && val_stats->num_rows > 0) {
        printf("Validation (1h): %s routes validated, %s total checks, %.1f%% success rate\n",
               db_get_value(val_stats, 0, 0),
               db_get_value(val_stats, 0, 1),
               atof(db_get_value(val_stats, 0, 2)));
        db_free_result(val_stats);
    }
    
    db_free_result(result);
    
    if (!verbose) {
        printf("\nUse 'route list -v' for detailed view with UUIDs and dialplan files\n");
    }
    
    return 0;
}

// Override the standard commands
int cmd_provider_list(int argc, char *argv[]) {
    return cmd_provider_list_enhanced(argc, argv);
}

int cmd_route_list(int argc, char *argv[]) {
    return cmd_route_list_enhanced(argc, argv);
}

// Add validation status command
int cmd_validation_status(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    if (!db) {
        printf("Database not initialized\n");
        return -1;
    }
    
    printf("\nValidation System Status\n");
    printf("========================\n\n");
    
    // Show active validation rules
    const char *rules_sql = 
        "SELECT rule_name, rule_type, enabled, priority "
        "FROM call_validation_rules "
        "ORDER BY priority DESC";
    
    db_result_t *rules = db_query(db, rules_sql);
    if (rules && rules->num_rows > 0) {
        printf("Active Validation Rules:\n");
        printf("%-30s %-20s %-10s %-10s\n", "Rule Name", "Type", "Enabled", "Priority");
        printf("%-30s %-20s %-10s %-10s\n", 
               "------------------------------", "--------------------", "----------", "----------");
        
        for (int i = 0; i < rules->num_rows; i++) {
            printf("%-30s %-20s %-10s %-10s\n",
                   db_get_value(rules, i, 0),
                   db_get_value(rules, i, 1),
                   strcmp(db_get_value(rules, i, 2), "t") == 0 ? "Yes" : "No",
                   db_get_value(rules, i, 3));
        }
        db_free_result(rules);
    }
    
    printf("\n");
    
    // Show recent security events
    const char *events_sql = 
        "SELECT event_type, severity, COUNT(*) as count "
        "FROM security_events "
        "WHERE created_at > NOW() - INTERVAL '1 hour' "
        "GROUP BY event_type, severity "
        "ORDER BY count DESC "
        "LIMIT 10";
    
    db_result_t *events = db_query(db, events_sql);
    if (events && events->num_rows > 0) {
        printf("Recent Security Events (1 hour):\n");
        printf("%-30s %-15s %-10s\n", "Event Type", "Severity", "Count");
        printf("%-30s %-15s %-10s\n", 
               "------------------------------", "---------------", "----------");
        
        for (int i = 0; i < events->num_rows; i++) {
            printf("%-30s %-15s %-10s\n",
                   db_get_value(events, i, 0),
                   db_get_value(events, i, 1),
                   db_get_value(events, i, 2));
        }
        db_free_result(events);
    } else {
        printf("No security events in the last hour\n");
    }
    
    printf("\n");
    
    // Show validation checkpoint summary
    const char *checkpoint_sql = 
        "SELECT checkpoint_name, "
        "COUNT(*) as total, "
        "SUM(CASE WHEN passed THEN 1 ELSE 0 END) as passed, "
        "AVG(CASE WHEN passed THEN 100 ELSE 0 END) as success_rate "
        "FROM validation_checkpoints "
        "WHERE checked_at > NOW() - INTERVAL '1 hour' "
        "GROUP BY checkpoint_name "
        "ORDER BY total DESC";
    
    db_result_t *checkpoints = db_query(db, checkpoint_sql);
    if (checkpoints && checkpoints->num_rows > 0) {
        printf("Validation Checkpoints (1 hour):\n");
        printf("%-30s %-10s %-10s %-15s\n", "Checkpoint", "Total", "Passed", "Success Rate");
        printf("%-30s %-10s %-10s %-15s\n", 
               "------------------------------", "----------", "----------", "---------------");
        
        for (int i = 0; i < checkpoints->num_rows; i++) {
            printf("%-30s %-10s %-10s %6.1f%%\n",
                   db_get_value(checkpoints, i, 0),
                   db_get_value(checkpoints, i, 1),
                   db_get_value(checkpoints, i, 2),
                   atof(db_get_value(checkpoints, i, 3)));
        }
        db_free_result(checkpoints);
    }
    
    return 0;
}
