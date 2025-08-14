#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "commands/did_cmd.h"
#include "db/database.h"
#include "core/logging.h"

int cmd_did(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: did <add|delete|list|release>\n");
        return -1;
    }
    
    if (strcmp(argv[1], "add") == 0) {
        return cmd_did_add(argc, argv);
    } else if (strcmp(argv[1], "delete") == 0) {
        return cmd_did_delete(argc, argv);
    } else if (strcmp(argv[1], "list") == 0) {
        return cmd_did_list(argc, argv);
    } else if (strcmp(argv[1], "release") == 0) {
        return cmd_did_delete(argc, argv);
    }
    
    printf("Unknown did command: %s\n", argv[1]);
    return -1;
}

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
    
    // Add DID
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

int cmd_did_list(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    database_t *db = get_database();
    const char *sql = "SELECT d.did, d.country, d.in_use, d.destination, p.name "
                     "FROM dids d LEFT JOIN providers p ON d.provider_id = p.id "
                     "WHERE d.active = true ORDER BY d.country, d.did";
    
    db_result_t *result = db_query(db, sql);
    if (!result || result->num_rows == 0) {
        printf("No DIDs configured\n");
        if (result) db_free_result(result);
        return 0;
    }
    
    printf("\nDID Pool Management\n");
    printf("===================\n");
    printf("%-20s %-10s %-10s %-20s %-15s\n", 
           "DID", "Country", "Status", "Destination", "Provider");
    printf("%-20s %-10s %-10s %-20s %-15s\n", 
           "--------------------", "----------", "----------", 
           "--------------------", "---------------");
    
    int total = 0, in_use = 0;
    for (int i = 0; i < result->num_rows; i++) {
        int is_in_use = atoi(db_get_value(result, i, 2));
        const char *destination = db_get_value(result, i, 3);
        const char *provider = db_get_value(result, i, 4);
        
        printf("%-20s %-10s %-10s %-20s %-15s\n",
               db_get_value(result, i, 0), // did
               db_get_value(result, i, 1), // country
               is_in_use ? "IN USE" : "Available",
               destination ? destination : "-",
               provider ? provider : "-");
        
        total++;
        if (is_in_use) in_use++;
    }
    
    printf("\nTotal DIDs: %d (In Use: %d, Available: %d)\n", 
           total, in_use, total - in_use);
    
    db_free_result(result);
    return 0;
}

int cmd_did_delete(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: did delete <number>\n");
        return -1;
    }
    
    const char *number = argv[2];
    
    database_t *db = get_database();
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

int cmd_did_show(int argc, char *argv[]) {
    return cmd_did_list(argc, argv);
}

int cmd_did_test(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    return 0;
}
