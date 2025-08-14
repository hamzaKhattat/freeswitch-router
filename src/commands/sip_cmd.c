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
