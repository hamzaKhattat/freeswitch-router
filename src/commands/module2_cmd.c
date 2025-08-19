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
