// database_pg.c - Complete PostgreSQL 12 implementation with dynamic queries
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
    int reconnect_attempts;
    int max_reconnect_attempts;
};

// Global database instance
static database_t *g_database = NULL;

// Helper function to escape strings for SQL
static char* escape_string(PGconn *conn, const char *str) {
    if (!str) return strdup("NULL");
    
    size_t len = strlen(str);
    char *escaped = malloc(2 * len + 1);
    PQescapeStringConn(conn, escaped, str, len, NULL);
    return escaped;
}

// Convert PGresult to db_result_t
static db_result_t* pg_to_db_result(PGresult *pg_res) {
    if (!pg_res) return NULL;
    
    ExecStatusType status = PQresultStatus(pg_res);
    if (status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK) {
        LOG_ERROR("Query failed: %s", PQerrorMessage(g_database->conn));
        PQclear(pg_res);
        return NULL;
    }
    
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

// Reconnect to database if connection lost
static int db_reconnect(database_t *db) {
    if (!db) return -1;
    
    if (PQstatus(db->conn) == CONNECTION_OK) {
        return 0;
    }
    
    LOG_WARN("Database connection lost, attempting to reconnect...");
    
    for (int i = 0; i < db->max_reconnect_attempts; i++) {
        PQreset(db->conn);
        
        if (PQstatus(db->conn) == CONNECTION_OK) {
            LOG_INFO("Database reconnected successfully");
            return 0;
        }
        
        LOG_WARN("Reconnect attempt %d/%d failed", i+1, db->max_reconnect_attempts);
        usleep(1000000); // Wait 1 second before retry
    }
    
    LOG_ERROR("Failed to reconnect to database after %d attempts", db->max_reconnect_attempts);
    return -1;
}

database_t* db_init(const char *connection_string) {
    if (g_database) return g_database;
    
    database_t *db = calloc(1, sizeof(database_t));
    if (!db) return NULL;
    
    // Use environment variable or provided connection string
    const char *conn_str = connection_string;
    if (!conn_str) {
        conn_str = getenv("ROUTER_DB_CONNECTION");
        if (!conn_str) {
            conn_str = "host=localhost dbname=router_db user=router password=router123 connect_timeout=10";
        }
    }
    
    db->connection_string = strdup(conn_str);
    db->max_reconnect_attempts = 3;
    db->reconnect_attempts = 0;
    
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
    
    // Enable autocommit
    PGresult *res = PQexec(db->conn, "SET autocommit TO on");
    PQclear(res);
    
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

db_result_t* db_query(database_t *db, const char *query) {
    if (!db || !query) return NULL;
    
    pthread_mutex_lock(&db->mutex);
    
    // Check connection and reconnect if needed
    if (db_reconnect(db) != 0) {
        pthread_mutex_unlock(&db->mutex);
        return NULL;
    }
    
    PGresult *res = PQexec(db->conn, query);
    db_result_t *result = pg_to_db_result(res);
    
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

// Prepared statement implementation
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

db_stmt_t* db_prepare(database_t *db, const char *sql) {
    if (!db || !sql) return NULL;
    
    pg_stmt_t *stmt = calloc(1, sizeof(pg_stmt_t));
    stmt->db = db;
    stmt->sql = strdup(sql);
    stmt->param_capacity = 10;
    stmt->params = calloc(stmt->param_capacity, sizeof(char*));
    stmt->param_lengths = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_formats = calloc(stmt->param_capacity, sizeof(int));
    stmt->param_types = calloc(stmt->param_capacity, sizeof(Oid));
    
    return (db_stmt_t*)stmt;
}

int db_bind_string(db_stmt_t *stmt, int index, const char *value) {
    if (!stmt) return -1;
    
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

// Convert SQL placeholders from ? to $1, $2, etc.
static char* convert_sql_placeholders(const char *sql) {
    char *converted = malloc(strlen(sql) * 2);
    char *dest = converted;
    const char *src = sql;
    int param_num = 1;
    
    while (*src) {
        if (*src == '?') {
            dest += sprintf(dest, "$%d", param_num++);
        } else {
            *dest++ = *src;
        }
        src++;
    }
    *dest = '\0';
    
    return converted;
}

int db_execute(db_stmt_t *stmt) {
    if (!stmt) return -1;
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Check connection
    if (db_reconnect(pg_stmt->db) != 0) {
        pthread_mutex_unlock(&pg_stmt->db->mutex);
        return -1;
    }
    
    char *pg_sql = convert_sql_placeholders(pg_stmt->sql);
    
    PGresult *res = PQexecParams(pg_stmt->db->conn,
                                 pg_sql,
                                 pg_stmt->param_count,
                                 pg_stmt->param_types,
                                 (const char * const *)pg_stmt->params,
                                 pg_stmt->param_lengths,
                                 pg_stmt->param_formats,
                                 0);
    
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
    
    pg_stmt_t *pg_stmt = (pg_stmt_t*)stmt;
    
    pthread_mutex_lock(&pg_stmt->db->mutex);
    
    // Check connection
    if (db_reconnect(pg_stmt->db) != 0) {
        pthread_mutex_unlock(&pg_stmt->db->mutex);
        return NULL;
    }
    
    char *pg_sql = convert_sql_placeholders(pg_stmt->sql);
    
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
