// database_pg.c - Fixed PostgreSQL database implementation with proper boolean handling
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <libpq-fe.h>
#include "db/database.h"
#include "core/logging.h"

struct database {
    PGconn *conn;
    pthread_mutex_t mutex;
    char *connection_string;
};

// Global database instance
static database_t *g_database = NULL;

// Convert PGresult to db_result_t
static db_result_t* pg_to_db_result(PGresult *pg_res) {
    if (!pg_res) return NULL;
    
    int num_rows = PQntuples(pg_res);
    int num_cols = PQnfields(pg_res);
    
    if (num_rows == 0 || num_cols == 0) {
        PQclear(pg_res);
        return NULL;
    }
    
    db_result_t *result = calloc(1, sizeof(db_result_t));
    if (!result) {
        PQclear(pg_res);
        return NULL;
    }
    
    result->num_rows = num_rows;
    result->num_cols = num_cols;
    result->data = calloc(num_rows * num_cols, sizeof(char*));
    result->columns = calloc(num_cols, sizeof(char*));
    
    // Copy column names
    for (int col = 0; col < num_cols; col++) {
        result->columns[col] = strdup(PQfname(pg_res, col));
    }
    
    // Copy data
    for (int row = 0; row < num_rows; row++) {
        for (int col = 0; col < num_cols; col++) {
            int idx = row * num_cols + col;
            if (PQgetisnull(pg_res, row, col)) {
                result->data[idx] = strdup("");
            } else {
                result->data[idx] = strdup(PQgetvalue(pg_res, row, col));
            }
        }
    }
    
    PQclear(pg_res);
    return result;
}

database_t* db_init(const char *connection_string) {
    if (g_database) return g_database;
    
    database_t *db = calloc(1, sizeof(database_t));
    if (!db) return NULL;
    
    // Use environment variable or default connection string
    const char *conn_str = connection_string;
    if (!conn_str) {
        conn_str = getenv("ROUTER_DB_CONNECTION");
        if (!conn_str) {
            conn_str = "host=localhost dbname=router_db user=router password=router123";
        }
    }
    
    db->connection_string = strdup(conn_str);
    db->conn = PQconnectdb(conn_str);
    
    if (PQstatus(db->conn) != CONNECTION_OK) {
        LOG_ERROR("Failed to connect to PostgreSQL: %s", PQerrorMessage(db->conn));
        PQfinish(db->conn);
        free(db->connection_string);
        free(db);
        return NULL;
    }
    
    pthread_mutex_init(&db->mutex, NULL);
    
    // Set client encoding
    PQsetClientEncoding(db->conn, "UTF8");
    
    // Create tables if they don't exist
    const char *schema_check = "SELECT 1 FROM information_schema.tables WHERE table_name = 'providers'";
    PGresult *res = PQexec(db->conn, schema_check);
    
    if (PQntuples(res) == 0) {
        PQclear(res);
        LOG_INFO("Creating database schema...");
        
        // Load and execute schema
        FILE *fp = fopen("scripts/schema_pg.sql", "r");
        if (fp) {
            fseek(fp, 0, SEEK_END);
            long size = ftell(fp);
            fseek(fp, 0, SEEK_SET);
            
            char *schema = malloc(size + 1);
            fread(schema, 1, size, fp);
            schema[size] = '\0';
            fclose(fp);
            
            res = PQexec(db->conn, schema);
            if (PQresultStatus(res) != PGRES_COMMAND_OK) {
                LOG_ERROR("Failed to create schema: %s", PQerrorMessage(db->conn));
            } else {
                LOG_INFO("Database schema created successfully");
            }
            
            PQclear(res);
            free(schema);
        }
    } else {
        PQclear(res);
    }
    
    g_database = db;
    LOG_INFO("Connected to PostgreSQL database");
    
    return db;
}

void db_close(database_t *db) {
    if (!db) return;
    
    pthread_mutex_lock(&db->mutex);
    
    if (db->conn) {
        PQfinish(db->conn);
    }
    
    pthread_mutex_unlock(&db->mutex);
    pthread_mutex_destroy(&db->mutex);
    
    free(db->connection_string);
    
    if (g_database == db) {
        g_database = NULL;
    }
    
    free(db);
}

// Fix SQL queries with boolean values
static char* fix_boolean_query(const char *query) {
    char *fixed = strdup(query);
    char *pos;
    
    // Replace "= 1" with "= true" and "= 0" with "= false" for boolean columns
    // This is a simple implementation - in production, use proper SQL parsing
    
    // Common boolean column patterns
    const char *bool_patterns[] = {
        "active = 1", "active = true",
        "active = 0", "active = false",
        "in_use = 1", "in_use = true", 
        "in_use = 0", "in_use = false",
        NULL, NULL
    };
    
    for (int i = 0; bool_patterns[i]; i += 2) {
        while ((pos = strstr(fixed, bool_patterns[i])) != NULL) {
            size_t before_len = pos - fixed;
            size_t pattern_len = strlen(bool_patterns[i]);
            size_t replace_len = strlen(bool_patterns[i + 1]);
            size_t after_len = strlen(pos + pattern_len);
            
            char *new_query = malloc(before_len + replace_len + after_len + 1);
            memcpy(new_query, fixed, before_len);
            memcpy(new_query + before_len, bool_patterns[i + 1], replace_len);
            memcpy(new_query + before_len + replace_len, pos + pattern_len, after_len + 1);
            
            free(fixed);
            fixed = new_query;
        }
    }
    
    return fixed;
}

db_result_t* db_query(database_t *db, const char *query) {
    if (!db || !query) return NULL;
    
    pthread_mutex_lock(&db->mutex);
    
    // Check connection
    if (PQstatus(db->conn) != CONNECTION_OK) {
        LOG_WARN("Database connection lost, reconnecting...");
        PQreset(db->conn);
    }
    
    // Fix boolean values in query
    char *fixed_query = fix_boolean_query(query);
    
    PGresult *res = PQexec(db->conn, fixed_query);
    
    if (PQresultStatus(res) != PGRES_TUPLES_OK && 
        PQresultStatus(res) != PGRES_COMMAND_OK) {
        LOG_ERROR("Query failed: %s", PQerrorMessage(db->conn));
        PQclear(res);
        free(fixed_query);
        pthread_mutex_unlock(&db->mutex);
        return NULL;
    }
    
    db_result_t *result = pg_to_db_result(res);
    
    free(fixed_query);
    pthread_mutex_unlock(&db->mutex);
    
    return result;
}

void db_free_result(db_result_t *result) {
    if (!result) return;
    
    if (result->data) {
        for (int i = 0; i < result->num_rows * result->num_cols; i++) {
            free(result->data[i]);
        }
        free(result->data);
    }
    
    if (result->columns) {
        for (int i = 0; i < result->num_cols; i++) {
            free(result->columns[i]);
        }
        free(result->columns);
    }
    
    free(result);
}

const char* db_get_value(db_result_t *result, int row, int col) {
    if (!result || !result->data) return "";
    if (row >= result->num_rows || col >= result->num_cols) return "";
    
    return result->data[row * result->num_cols + col];
}

db_stmt_t* db_prepare(database_t *db, const char *sql) {
    if (!db || !sql) return NULL;
    
    pthread_mutex_lock(&db->mutex);
    
    // PostgreSQL doesn't have persistent prepared statements like SQLite
    // We'll store the SQL and parameters in a custom structure
    typedef struct {
        database_t *db;
        char *sql;
        char **params;
        int *param_lengths;
        int *param_formats;
        Oid *param_types;
        int param_count;
        int param_capacity;
    } pg_stmt_t;
    
    pg_stmt_t *stmt = calloc(1, sizeof(pg_stmt_t));
    stmt->db = db;
    stmt->sql = strdup(sql);
    stmt->param_capacity = 10;
    stmt->params = calloc(stmt->param_capacity, sizeof(char*));
    stmt->param_lengths = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_formats = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_types = calloc(stmt->param_capacity, sizeof(Oid));
    
    pthread_mutex_unlock(&db->mutex);
    
    return (db_stmt_t*)stmt;
}

int db_bind_string(db_stmt_t *stmt, int index, const char *value) {
    if (!stmt) return -1;
    
    typedef struct {
        database_t *db;
        char *sql;
        char **params;
        int *param_lengths;
        int *param_formats;
        Oid *param_types;
        int param_count;
        int param_capacity;
    } pg_stmt_t;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    if (index > pg_stmt->param_capacity) {
        pg_stmt->param_capacity = index + 10;
        pg_stmt->params = realloc(pg_stmt->params, pg_stmt->param_capacity * sizeof(char*));
        pg_stmt->param_lengths = realloc(pg_stmt->param_lengths, pg_stmt->param_capacity * sizeof(int));
        pg_stmt->param_formats = realloc(pg_stmt->param_formats, pg_stmt->param_capacity * sizeof(int));
        pg_stmt->param_types = realloc(pg_stmt->param_types, pg_stmt->param_capacity * sizeof(Oid));
    }
    
    if (pg_stmt->params[index-1]) {
        free(pg_stmt->params[index-1]);
    }
    
    if (value) {
        pg_stmt->params[index-1] = strdup(value);
        pg_stmt->param_lengths[index-1] = strlen(value);
    } else {
        pg_stmt->params[index-1] = NULL;
        pg_stmt->param_lengths[index-1] = 0;
    }
    
    pg_stmt->param_formats[index-1] = 0; // text format
    pg_stmt->param_types[index-1] = 0; // let server deduce type
    
    if (index > pg_stmt->param_count) {
        pg_stmt->param_count = index;
    }
    
    return 0;
}

int db_bind_int(db_stmt_t *stmt, int index, int value) {
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%d", value);
    return db_bind_string(stmt, index, buffer);
}

// Helper to convert SQL with proper boolean values
static char* convert_sql_booleans(const char *sql) {
    char *converted = strdup(sql);
    
    // Check if SQL contains boolean column inserts
    if (strstr(sql, "active) VALUES") || strstr(sql, "in_use) VALUES")) {
        // Find the VALUES clause
        char *values_pos = strstr(converted, "VALUES");
        if (values_pos) {
            // Look for ", 1)" or ", 0)" patterns and replace with ", true)" or ", false)"
            char *pos = values_pos;
            while ((pos = strstr(pos, ", 1)")) != NULL) {
                // Check if this is likely a boolean (preceded by $N or ,)
                if (pos > converted && (*(pos-1) == ',' || *(pos-1) == ' ')) {
                    memcpy(pos, ", true)", 7);
                    pos += 7;
                } else {
                    pos += 4;
                }
            }
            
            pos = values_pos;
            while ((pos = strstr(pos, ", 0)")) != NULL) {
                if (pos > converted && (*(pos-1) == ',' || *(pos-1) == ' ')) {
                    memcpy(pos, ", false)", 8);
                    pos += 8;
                } else {
                    pos += 4;
                }
            }
        }
    }
    
    return converted;
}

int db_execute(db_stmt_t *stmt) {
    if (!stmt) return -1;
    
    typedef struct {
        database_t *db;
        char *sql;
        char **params;
        int *param_lengths;
        int *param_formats;
        Oid *param_types;
        int param_count;
        int param_capacity;
    } pg_stmt_t;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Convert SQL from SQLite style (?) to PostgreSQL style ($1, $2, etc.)
    char *pg_sql = convert_sql_booleans(pg_stmt->sql);
    char *pos = pg_sql;
    int param_num = 1;
    
    while ((pos = strchr(pos, '?')) != NULL) {
        char param_str[16];
        snprintf(param_str, sizeof(param_str), "$%d", param_num++);
        
        // Replace ? with $N
        size_t before_len = pos - pg_sql;
        size_t after_len = strlen(pos + 1);
        char *new_sql = malloc(before_len + strlen(param_str) + after_len + 1);
        
        memcpy(new_sql, pg_sql, before_len);
        memcpy(new_sql + before_len, param_str, strlen(param_str));
        memcpy(new_sql + before_len + strlen(param_str), pos + 1, after_len + 1);
        
        free(pg_sql);
        pg_sql = new_sql;
        pos = pg_sql + before_len + strlen(param_str);
    }
    
    // Special handling for boolean values in INSERT statements
    if (strstr(pg_sql, "active) VALUES") && strstr(pg_sql, ", 1)")) {
        char *temp = pg_sql;
        pg_sql = malloc(strlen(temp) + 20);
        strcpy(pg_sql, temp);
        
        // Replace ", 1)" with ", true)"
        char *bool_pos = strstr(pg_sql, ", 1)");
        if (bool_pos) {
            strcpy(bool_pos, ", true)");
        }
        
        free(temp);
    }
    
    PGresult *res = PQexecParams(pg_stmt->db->conn,
                                 pg_sql,
                                 pg_stmt->param_count,
                                 pg_stmt->param_types,
                                 (const char * const *)pg_stmt->params,
                                 pg_stmt->param_lengths,
                                 pg_stmt->param_formats,
                                 0); // text result format
    
    free(pg_sql);
    
    ExecStatusType status = PQresultStatus(res);
    int result = (status == PGRES_COMMAND_OK || status == PGRES_TUPLES_OK) ? 0 : -1;
    
    if (result < 0) {
        LOG_ERROR("Execute failed: %s", PQerrorMessage(pg_stmt->db->conn));
    }
    
    PQclear(res);
    pthread_mutex_unlock(&pg_stmt->db->mutex);
    
    return result;
}

db_result_t* db_execute_query(db_stmt_t *stmt) {
    if (!stmt) return NULL;
    
    typedef struct {
        database_t *db;
        char *sql;
        char **params;
        int *param_lengths;
        int *param_formats;
        Oid *param_types;
        int param_count;
        int param_capacity;
    } pg_stmt_t;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Convert SQL from SQLite style to PostgreSQL style
    char *pg_sql = strdup(pg_stmt->sql);
    char *pos = pg_sql;
    int param_num = 1;
    
    while ((pos = strchr(pos, '?')) != NULL) {
        char param_str[16];
        snprintf(param_str, sizeof(param_str), "$%d", param_num++);
        
        size_t before_len = pos - pg_sql;
        size_t after_len = strlen(pos + 1);
        char *new_sql = malloc(before_len + strlen(param_str) + after_len + 1);
        
        memcpy(new_sql, pg_sql, before_len);
        memcpy(new_sql + before_len, param_str, strlen(param_str));
        memcpy(new_sql + before_len + strlen(param_str), pos + 1, after_len + 1);
        
        free(pg_sql);
        pg_sql = new_sql;
        pos = pg_sql + before_len + strlen(param_str);
    }
    
    PGresult *res = PQexecParams(pg_stmt->db->conn,
                                 pg_sql,
                                 pg_stmt->param_count,
                                 pg_stmt->param_types,
                                 (const char * const *)pg_stmt->params,
                                 pg_stmt->param_lengths,
                                 pg_stmt->param_formats,
                                 0);
    
    free(pg_sql);
    
    db_result_t *result = pg_to_db_result(res);
    
    pthread_mutex_unlock(&pg_stmt->db->mutex);
    
    return result;
}

void db_finalize(db_stmt_t *stmt) {
    if (!stmt) return;
    
    typedef struct {
        database_t *db;
        char *sql;
        char **params;
        int *param_lengths;
        int *param_formats;
        Oid *param_types;
        int param_count;
        int param_capacity;
    } pg_stmt_t;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    free(pg_stmt->sql);
    
    for (int i = 0; i < pg_stmt->param_count; i++) {
        if (pg_stmt->params[i]) {
            free(pg_stmt->params[i]);
        }
    }
    
    free(pg_stmt->params);
    free(pg_stmt->param_lengths);
    free(pg_stmt->param_formats);
    free(pg_stmt->param_types);
    free(pg_stmt);
}

database_t* get_database(void) {
    return g_database;
}
