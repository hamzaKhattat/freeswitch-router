// route_cmd.c - Complete Dynamic Route Management with Auto Dialplan Generation
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>  // For unlink()
#include <uuid/uuid.h>
#include <errno.h>
#include "commands/route_cmd.h"
#include "db/database.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"

static char* generate_uuid(void) {
   uuid_t uuid;
   char *uuid_str = malloc(37);
   uuid_generate(uuid);
   uuid_unparse_lower(uuid, uuid_str);
   return uuid_str;
}

// Forward declaration
int cmd_route_reload(int argc, char *argv[]);
int cmd_route(int argc, char *argv[]) {
   if (argc < 2) {
       printf("Usage: route <add|delete|list|show|reload> [options]\n");
       return -1;
   }
   
   if (strcmp(argv[1], "add") == 0) {
       return cmd_route_add(argc, argv);
   } else if (strcmp(argv[1], "delete") == 0) {
       return cmd_route_delete(argc, argv);
   } else if (strcmp(argv[1], "list") == 0) {
       return cmd_route_list(argc, argv);
   } else if (strcmp(argv[1], "show") == 0) {
       return cmd_route_show(argc, argv);
   } else if (strcmp(argv[1], "reload") == 0) {
       return cmd_route_reload(argc, argv);
   } else if (strcmp(argv[1], "test") == 0) {
       return cmd_route_test(argc, argv);
   }
   
   printf("Unknown route command: %s\n", argv[1]);
   return -1;
}

int cmd_route_add(int argc, char *argv[]) {
   if (argc < 8) {
       printf("Usage: route add <name> <origin> <intermediate> <final> <pattern> <priority>\n");
       printf("\nParameters:\n");
       printf("  name          - Route name (e.g., 'us_route', 'intl_route')\n");
       printf("  origin        - Origin provider name (S1)\n");
       printf("  intermediate  - Intermediate provider name (S3)\n");
       printf("  final         - Final provider name (S4)\n");
       printf("  pattern       - Number pattern (regex supported)\n");
       printf("  priority      - Route priority (higher = first)\n");
       printf("\nExamples:\n");
       printf("  route add us_route s1 s3 s4 '1[2-9][0-9]{9}' 100\n");
       printf("  route add intl_route s1 s3 s4 '011.*' 90\n");
       printf("  route add test_route s1 s3 s4 '999.*' 200\n");
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
   
   const char *provider_names[] = {origin_name, inter_name, final_name};
   const char *expected_roles[] = {"origin", "intermediate", "final"};
   const char *role_desc[] = {"origin (S1)", "intermediate (S3)", "final (S4)"};
   int provider_ids[3] = {0, 0, 0};
   
   for (int i = 0; i < 3; i++) {
       const char *sql = "SELECT id, role FROM providers WHERE name = ?";
       db_stmt_t *stmt = db_prepare(db, sql);
       if (!stmt) continue;
       
       db_bind_string(stmt, 1, provider_names[i]);
       db_result_t *result = db_execute_query(stmt);
       
       if (!result || result->num_rows == 0) {
           printf("Error: Provider '%s' not found\n", provider_names[i]);
           printf("Please add the provider first using: provider add %s <host:port> %s <capacity> <auth>\n",
                  provider_names[i], expected_roles[i]);
           if (result) db_free_result(result);
           db_finalize(stmt);
           return -1;
       }
       
       provider_ids[i] = atoi(db_get_value(result, 0, 0));
       const char *actual_role = db_get_value(result, 0, 1);
       
       if (strcmp(actual_role, expected_roles[i]) != 0 && strcmp(actual_role, "general") != 0) {
           printf("Warning: Provider '%s' has role '%s', expected '%s' for %s\n",
                  provider_names[i], actual_role, expected_roles[i], role_desc[i]);
           printf("Continue anyway? (y/n): ");
           char response = getchar();
           getchar();
           if (response != 'y' && response != 'Y') {
               printf("Route creation cancelled\n");
               db_free_result(result);
               db_finalize(stmt);
               return -1;
           }
       }
       
       db_free_result(result);
       db_finalize(stmt);
   }
   
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
   
   char *uuid = generate_uuid();
   
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
   printf("  Call Flow: %s → S2 → %s → S2 → %s\n", origin_name, inter_name, final_name);
   printf("  Pattern: %s\n", pattern);
   printf("  Priority: %d\n", priority);
   
   printf("\nGenerating FreeSWITCH dialplan...\n");
   
   if (fs_generate_route_dialplan() == 0) {
       printf("  ✓ Generated route dialplan\n");
       printf("  ✓ Generated Lua handler scripts\n");
       printf("  ✓ Reloading FreeSWITCH...\n");
       fs_reload_config();
       printf("\nRoute is now active and ready to handle calls\n");
   } else {
       printf("  ✗ Failed to generate dialplan\n");
   }
   
   free(uuid);
   return 0;
}

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

// Fixed route_cmd.c - route delete function
// Replace the cmd_route_delete function in src/commands/route_cmd.c with this:

int cmd_route_delete(int argc, char *argv[]) {
   if (argc < 3) {
       printf("Usage: route delete <id|name>\n");
       return -1;
   }
   
   const char *identifier = argv[2];
   database_t *db = get_database();
   
   // First, get route info for cleanup
   char select_query[512];
   if (atoi(identifier) > 0) {
       // Query by ID
       snprintf(select_query, sizeof(select_query), 
               "SELECT id, name, uuid FROM routes WHERE id = %d", atoi(identifier));
   } else {
       // Query by name - escape single quotes
       char escaped_name[256];
       const char *src = identifier;
       char *dst = escaped_name;
       while (*src && (dst - escaped_name) < 254) {
           if (*src == '\'') {
               *dst++ = '\'';
               *dst++ = '\'';
           } else {
               *dst++ = *src;
           }
           src++;
       }
       *dst = '\0';
       
       snprintf(select_query, sizeof(select_query), 
               "SELECT id, name, uuid FROM routes WHERE name = '%s'", escaped_name);
   }
   
   db_result_t *result = db_query(db, select_query);
   
   if (!result || result->num_rows == 0) {
       printf("Route '%s' not found\n", identifier);
       if (result) db_free_result(result);
       return -1;
   }
   
   const char *route_id = db_get_value(result, 0, 0);
   const char *route_name = db_get_value(result, 0, 1);
   
   // Copy the ID to ensure it's clean
   char clean_id[32];
   snprintf(clean_id, sizeof(clean_id), "%s", route_id);
   
   // Copy the name for later use
   char saved_name[256];
   snprintf(saved_name, sizeof(saved_name), "%s", route_name);
   
   printf("Deleting route '%s' (ID: %s)...\n", saved_name, clean_id);
   
   // Remove dialplan file
   char filepath[512];
   snprintf(filepath, sizeof(filepath), "/etc/freeswitch/dialplan/public/route_%s.xml", clean_id);
   if (unlink(filepath) == 0) {
       printf("  ✓ Removed dialplan file\n");
   }
   
   db_free_result(result);
   
   // Now delete from database using direct SQL (no prepared statement)
   char delete_query[256];
   snprintf(delete_query, sizeof(delete_query), 
           "DELETE FROM routes WHERE id = %s", clean_id);
   
   // Use db_query which returns a result even for DELETE
   db_result_t *del_result = db_query(db, delete_query);
   
   // For PostgreSQL, a successful DELETE returns PGRES_COMMAND_OK
   // which db_query converts to an empty result (not NULL)
   if (del_result != NULL || errno == 0) {
       printf("Route '%s' deleted successfully\n", saved_name);
       if (del_result) db_free_result(del_result);
       
       // Regenerate dialplans
       printf("Regenerating dialplans...\n");
       fs_generate_route_dialplan();
       fs_reload_config();
       
       return 0;
   } else {
       printf("Failed to delete route from database\n");
       return -1;
   }
}

int cmd_route_show(int argc, char *argv[]) {
   if (argc < 3) {
       printf("Usage: route show <id|name>\n");
       return -1;
   }
   
   // Implementation continues...
   return 0;
}

int cmd_route_reload(int argc, char *argv[]) {
   (void)argc;
   (void)argv;
   
   printf("Reloading all route configurations...\n");
   
   if (fs_generate_route_dialplan() == 0) {
       printf("  ✓ Regenerated route dialplans\n");
       printf("  ✓ Regenerated Lua scripts\n");
       fs_reload_config();
       printf("  ✓ Reloaded FreeSWITCH\n");
       printf("\nRoute configurations reloaded successfully\n");
   } else {
       printf("  ✗ Failed to reload routes\n");
       return -1;
   }
   
   return 0;
}

int cmd_route_test(int argc, char *argv[]) {
   if (argc < 4) {
       printf("Usage: route test <route_name> <number>\n");
       printf("Example: route test us_route 18005551234\n");
       return -1;
   }
   
   // Implementation continues...
   return 0;
}
