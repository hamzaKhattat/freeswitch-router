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
