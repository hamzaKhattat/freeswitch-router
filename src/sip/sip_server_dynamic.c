// sip_server_dynamic.c - Complete rewrite with full database integration
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <limits.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <errno.h>
#include <stdbool.h>
#include "sip/sip_server.h"
#include "router/router.h"
#include "db/database.h"
#include "core/logging.h"

#define SIP_PORT 5060
#define BUFFER_SIZE 65536

// Provider structure from database
typedef struct provider {
    int id;
    char uuid[64];
    char name[256];
    char host[256];
    int port;
    char auth_type[32];
    char auth_data[512];
    char transport[16];
    int capacity;
    char role[32];  // 'origin', 'intermediate', 'final', 'general'
    int current_calls;
    bool active;
    time_t last_updated;
    struct provider *next;
} provider_t;

// DID structure from database
typedef struct did {
    int id;
    char did[64];
    char country[32];
    int provider_id;
    bool in_use;
    char destination[64];
    char call_id[256];
    char original_ani[64];
    time_t allocated_at;
    bool active;
    struct did *next;
} did_t;

// Call state tracking
typedef struct call_state {
    char call_id[256];
    char original_ani[64];
    char original_dnis[64];
    char assigned_did[64];
    int origin_provider_id;
    int intermediate_provider_id;
    int final_provider_id;
    int stage;  // 1=origin->intermediate, 2=intermediate->final
    time_t created_at;
    struct call_state *next;
} call_state_t;

// Route structure from database
typedef struct route {
    int id;
    char uuid[64];
    char name[256];
    char pattern[256];
    int origin_provider_id;
    int intermediate_provider_id;
    int final_provider_id;
    int priority;
    bool active;
    struct route *next;
} route_t;

// Main SIP server structure
struct sip_server {
    // Network
    int socket_fd;
    struct sockaddr_in server_addr;
    pthread_t listen_thread;
    
    // Database
    database_t *db;
    
    // Providers linked list
    provider_t *providers;
    pthread_mutex_t provider_mutex;
    
    // DIDs linked list
    did_t *dids;
    pthread_mutex_t did_mutex;
    
    // Routes linked list
    route_t *routes;
    pthread_mutex_t route_mutex;
    
    // Active calls
    call_state_t *active_calls;
    pthread_mutex_t call_mutex;
    
    // Router reference
    router_t *router;
    
    // Statistics
    struct {
        uint64_t total_invites;
        uint64_t forwarded_calls;
        uint64_t failed_calls;
    } stats;
    
    int running;
    pthread_t monitor_thread;
};

// Global server instance
extern sip_server_t *g_sip_server; // Defined in main.c

// Free provider list
static void free_providers(provider_t *providers) {
    while (providers) {
        provider_t *next = providers->next;
        free(providers);
        providers = next;
    }
}

// Free DID list
static void free_dids(did_t *dids) {
    while (dids) {
        did_t *next = dids->next;
        free(dids);
        dids = next;
    }
}

// Free route list
static void free_routes(route_t *routes) {
    while (routes) {
        route_t *next = routes->next;
        free(routes);
        routes = next;
    }
}

// Load providers from database
static int load_providers_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, uuid, name, host, port, auth_type, auth_data, transport, "
        "capacity, role, current_calls, active "
        "FROM providers WHERE active = true ORDER BY role, name";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load providers from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->provider_mutex);
    
    // Free old provider list
    free_providers(server->providers);
    server->providers = NULL;
    provider_t **pp = &server->providers;
    
    for (int i = 0; i < result->num_rows; i++) {
        provider_t *provider = calloc(1, sizeof(provider_t));
        
        provider->id = atoi(db_get_value(result, i, 0));
        strncpy(provider->uuid, db_get_value(result, i, 1), sizeof(provider->uuid) - 1);
        strncpy(provider->name, db_get_value(result, i, 2), sizeof(provider->name) - 1);
        strncpy(provider->host, db_get_value(result, i, 3), sizeof(provider->host) - 1);
        provider->port = atoi(db_get_value(result, i, 4));
        strncpy(provider->auth_type, db_get_value(result, i, 5), sizeof(provider->auth_type) - 1);
        strncpy(provider->auth_data, db_get_value(result, i, 6), sizeof(provider->auth_data) - 1);
        strncpy(provider->transport, db_get_value(result, i, 7), sizeof(provider->transport) - 1);
        provider->capacity = atoi(db_get_value(result, i, 8));
        strncpy(provider->role, db_get_value(result, i, 9), sizeof(provider->role) - 1);
        provider->current_calls = atoi(db_get_value(result, i, 10));
        provider->active = strcmp(db_get_value(result, i, 11), "t") == 0;
        provider->last_updated = time(NULL);
        
        // Add to linked list
        *pp = provider;
        pp = &provider->next;
        
        LOG_INFO("Loaded provider: %s (UUID: %s, Role: %s, Host: %s:%d)", 
                provider->name, provider->uuid, provider->role, provider->host, provider->port);
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d providers from database", result->num_rows);
    return 0;
}

// Load DIDs from database
static int load_dids_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, did, country, provider_id, in_use, destination, "
        "call_id, original_ani, allocated_at, active "
        "FROM dids WHERE active = true ORDER BY did";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load DIDs from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->did_mutex);
    
    // Free old DID list
    free_dids(server->dids);
    server->dids = NULL;
    did_t **pp = &server->dids;
    
    for (int i = 0; i < result->num_rows; i++) {
        did_t *did = calloc(1, sizeof(did_t));
        
        did->id = atoi(db_get_value(result, i, 0));
        strncpy(did->did, db_get_value(result, i, 1), sizeof(did->did) - 1);
        strncpy(did->country, db_get_value(result, i, 2), sizeof(did->country) - 1);
        
        const char *provider_id_str = db_get_value(result, i, 3);
        did->provider_id = (provider_id_str && strlen(provider_id_str) > 0) ? atoi(provider_id_str) : 0;
        
        did->in_use = strcmp(db_get_value(result, i, 4), "t") == 0;
        
        const char *dest = db_get_value(result, i, 5);
        if (dest && strlen(dest) > 0) {
            strncpy(did->destination, dest, sizeof(did->destination) - 1);
        }
        
        const char *cid = db_get_value(result, i, 6);
        if (cid && strlen(cid) > 0) {
            strncpy(did->call_id, cid, sizeof(did->call_id) - 1);
        }
        
        const char *ani = db_get_value(result, i, 7);
        if (ani && strlen(ani) > 0) {
            strncpy(did->original_ani, ani, sizeof(did->original_ani) - 1);
        }
        
        did->active = strcmp(db_get_value(result, i, 9), "t") == 0;
        
        // Add to linked list
        *pp = did;
        pp = &did->next;
    }
    
    pthread_mutex_unlock(&server->did_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d DIDs from database", result->num_rows);
    return 0;
}

// Load routes from database
static int load_routes_from_db(sip_server_t *server) {
    const char *query = 
        "SELECT id, uuid, name, pattern, origin_provider_id, "
        "intermediate_provider_id, final_provider_id, priority, active "
        "FROM routes WHERE active = true ORDER BY priority DESC, name";
    
    db_result_t *result = db_query(server->db, query);
    if (!result) {
        LOG_ERROR("Failed to load routes from database");
        return -1;
    }
    
    pthread_mutex_lock(&server->route_mutex);
    
    // Free old route list
    free_routes(server->routes);
    server->routes = NULL;
    route_t **pp = &server->routes;
    
    for (int i = 0; i < result->num_rows; i++) {
        route_t *route = calloc(1, sizeof(route_t));
        
        route->id = atoi(db_get_value(result, i, 0));
        strncpy(route->uuid, db_get_value(result, i, 1), sizeof(route->uuid) - 1);
        strncpy(route->name, db_get_value(result, i, 2), sizeof(route->name) - 1);
        strncpy(route->pattern, db_get_value(result, i, 3), sizeof(route->pattern) - 1);
        
        const char *origin_id = db_get_value(result, i, 4);
        route->origin_provider_id = (origin_id && strlen(origin_id) > 0) ? atoi(origin_id) : 0;
        
        const char *inter_id = db_get_value(result, i, 5);
        route->intermediate_provider_id = (inter_id && strlen(inter_id) > 0) ? atoi(inter_id) : 0;
        
        const char *final_id = db_get_value(result, i, 6);
        route->final_provider_id = (final_id && strlen(final_id) > 0) ? atoi(final_id) : 0;
        
        route->priority = atoi(db_get_value(result, i, 7));
        route->active = strcmp(db_get_value(result, i, 8), "t") == 0;
        
        // Add to linked list
        *pp = route;
        pp = &route->next;
        
        LOG_INFO("Loaded route: %s (Pattern: %s, Priority: %d)", 
                route->name, route->pattern, route->priority);
    }
    
    pthread_mutex_unlock(&server->route_mutex);
    
    db_free_result(result);
    
    LOG_INFO("Loaded %d routes from database", result->num_rows);
    return 0;
}

// Find provider by ID
static provider_t* find_provider_by_id(sip_server_t *server, int id) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    while (provider) {
        if (provider->id == id) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return NULL;
}

// Find provider by IP
static provider_t* find_provider_by_ip(sip_server_t *server, const char *ip) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    while (provider) {
        // Check direct host match
        if (strcmp(provider->host, ip) == 0) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        
        // Check if IP is in auth_data for IP auth
        if (strcmp(provider->auth_type, "ip") == 0 && 
            strstr(provider->auth_data, ip) != NULL) {
            pthread_mutex_unlock(&server->provider_mutex);
            return provider;
        }
        
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return NULL;
}

// Find provider by role
static provider_t* find_provider_by_role(sip_server_t *server, const char *role) {
    pthread_mutex_lock(&server->provider_mutex);
    
    provider_t *provider = server->providers;
    provider_t *selected = NULL;
    int min_calls = INT_MAX;
    
    // Find the provider with the specified role that has the least current calls
    while (provider) {
        if (strcmp(provider->role, role) == 0 && provider->active) {
            if (provider->current_calls < min_calls && 
                provider->current_calls < provider->capacity) {
                selected = provider;
                min_calls = provider->current_calls;
            }
        }
        provider = provider->next;
    }
    
    pthread_mutex_unlock(&server->provider_mutex);
    return selected;
}

// Allocate DID from pool
static did_t* allocate_did(sip_server_t *server, const char *ani, const char *dnis, const char *call_id) {
    pthread_mutex_lock(&server->did_mutex);
    
    did_t *did = server->dids;
    did_t *selected = NULL;
    
    while (did) {
        if (!did->in_use && did->active) {
            selected = did;
            break;
        }
        did = did->next;
    }
    
    if (selected) {
        // Update DID in memory
        selected->in_use = true;
        selected->allocated_at = time(NULL);
        strncpy(selected->destination, dnis, sizeof(selected->destination) - 1);
        strncpy(selected->original_ani, ani, sizeof(selected->original_ani) - 1);
        strncpy(selected->call_id, call_id, sizeof(selected->call_id) - 1);
        
        // Update database
        char query[1024];
        snprintf(query, sizeof(query),
                "UPDATE dids SET in_use = true, destination = '%s', "
                "original_ani = '%s', call_id = '%s', allocated_at = CURRENT_TIMESTAMP "
                "WHERE id = %d",
                dnis, ani, call_id, selected->id);
        
        db_query(server->db, query);
        
        LOG_INFO("Allocated DID %s for call %s (ANI: %s, DNIS: %s)", 
                selected->did, call_id, ani, dnis);
    }
    
    pthread_mutex_unlock(&server->did_mutex);
    return selected;
}

// Release DID back to pool
static void release_did(sip_server_t *server, const char *did_number) {
    pthread_mutex_lock(&server->did_mutex);
    
    did_t *did = server->dids;
    while (did) {
        if (strcmp(did->did, did_number) == 0) {
            // Update DID in memory
            did->in_use = false;
            memset(did->destination, 0, sizeof(did->destination));
            memset(did->original_ani, 0, sizeof(did->original_ani));
            memset(did->call_id, 0, sizeof(did->call_id));
            did->allocated_at = 0;
            
            // Update database
            char query[512];
            snprintf(query, sizeof(query),
                    "UPDATE dids SET in_use = false, destination = NULL, "
                    "original_ani = NULL, call_id = NULL, allocated_at = NULL "
                    "WHERE id = %d",
                    did->id);
            
            db_query(server->db, query);
            
            LOG_INFO("Released DID %s", did_number);
            break;
        }
        did = did->next;
    }
    
    pthread_mutex_unlock(&server->did_mutex);
}

// Create call record in database
static void create_call_record(sip_server_t *server, const char *call_id, 
                              const char *ani, const char *dnis, const char *did,
                              int origin_id, int inter_id, int final_id) {
    char query[1024];
    snprintf(query, sizeof(query),
            "INSERT INTO call_records (call_id, original_ani, original_dnis, assigned_did, "
            "origin_provider_id, intermediate_provider_id, final_provider_id, status, stage) "
            "VALUES ('%s', '%s', '%s', '%s', %d, %d, %d, 'routing', 1)",
            call_id, ani, dnis, did, origin_id, inter_id, final_id);
    
    db_query(server->db, query);
}

// Update call record stage
static void update_call_record_stage(sip_server_t *server, const char *call_id, int stage) {
    char query[512];
    snprintf(query, sizeof(query),
            "UPDATE call_records SET stage = %d, updated_at = CURRENT_TIMESTAMP "
            "WHERE call_id = '%s'",
            stage, call_id);
    
    db_query(server->db, query);
}

// Extract SIP header value
static char* extract_sip_header(const char *message, const char *header) {
    static char value[256];
    char search[128];
    
    snprintf(search, sizeof(search), "%s:", header);
    const char *pos = strstr(message, search);
    if (!pos) return NULL;
    
    pos += strlen(search);
    while (*pos == ' ') pos++;
    
    const char *end = strchr(pos, '\r');
    if (!end) end = strchr(pos, '\n');
    if (!end) return NULL;
    
    size_t len = end - pos;
    if (len >= sizeof(value)) len = sizeof(value) - 1;
    
    memcpy(value, pos, len);
    value[len] = '\0';
    
    return value;
}

// Extract call ID from SIP message
static char* extract_call_id(const char *message) {
    return extract_sip_header(message, "Call-ID");
}

// Get source IP from socket address
static char* get_source_ip(struct sockaddr_in *addr) {
    static char ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &addr->sin_addr, ip, sizeof(ip));
    return ip;
}

// Create SIP response
static char* create_sip_response(int code, const char *reason, const char *call_id) {
    static char response[1024];
    
    snprintf(response, sizeof(response),
            "SIP/2.0 %d %s\r\n"
            "Via: SIP/2.0/UDP %s:%d\r\n"
            "Call-ID: %s\r\n"
            "Content-Length: 0\r\n"
            "\r\n",
            code, reason, "10.0.0.2", SIP_PORT, call_id ? call_id : "unknown");
    
    return response;
}

// Handle SIP INVITE
static void handle_sip_invite(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    char *source_ip = get_source_ip(from_addr);
    char *call_id = extract_call_id(message);
    char *from = extract_sip_header(message, "From");
    char *to = extract_sip_header(message, "To");
    
    LOG_INFO("INVITE from %s: From=%s, To=%s, Call-ID=%s", source_ip, from, to, call_id);
    
    // Find source provider by IP
    provider_t *source_provider = find_provider_by_ip(server, source_ip);
    if (!source_provider) {
        LOG_WARN("Unknown source IP: %s", source_ip);
        
        // Send 403 Forbidden
        char *response = create_sip_response(403, "Forbidden", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.failed_calls++;
        return;
    }
    
    LOG_INFO("Call from provider: %s (ID: %d, Role: %s, UUID: %s)", 
            source_provider->name, source_provider->id, source_provider->role, source_provider->uuid);
    
    // Route based on provider role from database
    if (strcmp(source_provider->role, "origin") == 0) {
        // Origin -> Intermediate flow (S1 -> S2 -> S3)
        
        // Find intermediate provider
        provider_t *intermediate = find_provider_by_role(server, "intermediate");
        if (!intermediate) {
            LOG_ERROR("No intermediate provider available");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Find final provider for complete route
        provider_t *final = find_provider_by_role(server, "final");
        if (!final) {
            LOG_ERROR("No final provider available");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Allocate DID
        did_t *did = allocate_did(server, from, to, call_id);
        if (!did) {
            LOG_ERROR("No available DID");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Create call state
        call_state_t *call = calloc(1, sizeof(call_state_t));
        strncpy(call->call_id, call_id, sizeof(call->call_id) - 1);
        strncpy(call->original_ani, from, sizeof(call->original_ani) - 1);
        strncpy(call->original_dnis, to, sizeof(call->original_dnis) - 1);
        strncpy(call->assigned_did, did->did, sizeof(call->assigned_did) - 1);
        call->origin_provider_id = source_provider->id;
        call->intermediate_provider_id = intermediate->id;
        call->final_provider_id = final->id;
        call->stage = 1;
        call->created_at = time(NULL);
        
        pthread_mutex_lock(&server->call_mutex);
        call->next = server->active_calls;
        server->active_calls = call;
        pthread_mutex_unlock(&server->call_mutex);
        
        // Create call record in database
        create_call_record(server, call_id, from, to, did->did,
                          source_provider->id, intermediate->id, final->id);
        
        // Update provider call counts
        source_provider->current_calls++;
        intermediate->current_calls++;
        
        LOG_INFO("Routing S1->S3: %s -> %s (DID: %s)", 
                source_provider->name, intermediate->name, did->did);
        
        // Send 100 Trying
        char *response = create_sip_response(100, "Trying", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        // In production, would forward actual INVITE to intermediate
        // For now, send 302 redirect
        response = create_sip_response(302, "Moved Temporarily", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.forwarded_calls++;
        
    } else if (strcmp(source_provider->role, "intermediate") == 0) {
        // Intermediate -> Final flow (S3 -> S2 -> S4)
        
        // Find the call state
        pthread_mutex_lock(&server->call_mutex);
        call_state_t *call = server->active_calls;
        call_state_t *found_call = NULL;
        
        while (call) {
            if (strcmp(call->call_id, call_id) == 0) {
                found_call = call;
                break;
            }
            call = call->next;
        }
        pthread_mutex_unlock(&server->call_mutex);
        
        if (!found_call) {
            LOG_ERROR("Call state not found for call_id: %s", call_id);
            char *response = create_sip_response(404, "Not Found", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            return;
        }
        
        // Find final provider
        provider_t *final = find_provider_by_id(server, found_call->final_provider_id);
        if (!final) {
            LOG_ERROR("Final provider not found");
            char *response = create_sip_response(503, "Service Unavailable", call_id);
            sendto(server->socket_fd, response, strlen(response), 0,
                   (struct sockaddr*)from_addr, sizeof(*from_addr));
            server->stats.failed_calls++;
            return;
        }
        
        // Update call stage
        found_call->stage = 2;
        update_call_record_stage(server, call_id, 2);
        
        // Release DID
        release_did(server, found_call->assigned_did);
        
        LOG_INFO("Routing S3->S4: %s -> %s (Restored ANI: %s, DNIS: %s)", 
                source_provider->name, final->name, 
                found_call->original_ani, found_call->original_dnis);
        
        // Send response
        char *response = create_sip_response(302, "Moved Temporarily", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
        
        server->stats.forwarded_calls++;
    } else {
        LOG_WARN("Provider role '%s' not handled for routing", source_provider->role);
        char *response = create_sip_response(501, "Not Implemented", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
    }
    
    server->stats.total_invites++;
}

// Handle SIP OPTIONS
static void handle_sip_options(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    (void)server;  // Unused
    char *call_id = extract_call_id(message);
    
    // Send 200 OK
    char *response = create_sip_response(200, "OK", call_id);
    sendto(server->socket_fd, response, strlen(response), 0,
           (struct sockaddr*)from_addr, sizeof(*from_addr));
}

// Process SIP message
static void process_sip_message(sip_server_t *server, const char *message, struct sockaddr_in *from_addr) {
    // Extract method
    char method[32];
    if (sscanf(message, "%31s", method) != 1) {
        return;
    }
    
    if (strcmp(method, "INVITE") == 0) {
        handle_sip_invite(server, message, from_addr);
    } else if (strcmp(method, "OPTIONS") == 0) {
        handle_sip_options(server, message, from_addr);
    } else if (strcmp(method, "REGISTER") == 0) {
        // Send 200 OK for REGISTER
        char *call_id = extract_call_id(message);
        char *response = create_sip_response(200, "OK", call_id);
        sendto(server->socket_fd, response, strlen(response), 0,
               (struct sockaddr*)from_addr, sizeof(*from_addr));
    }
}

// Listen thread
static void* sip_listen_thread(void *arg) {
    sip_server_t *server = (sip_server_t*)arg;
    char buffer[BUFFER_SIZE];
    struct sockaddr_in from_addr;
    socklen_t addr_len = sizeof(from_addr);
    
    LOG_INFO("SIP server listening on port %d", SIP_PORT);
    
    while (server->running) {
        ssize_t len = recvfrom(server->socket_fd, buffer, sizeof(buffer) - 1, 0,
                              (struct sockaddr*)&from_addr, &addr_len);
        
        if (len > 0) {
            buffer[len] = '\0';
            process_sip_message(server, buffer, &from_addr);
        } else if (len < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
            LOG_ERROR("recvfrom error: %s", strerror(errno));
        }
    }
    
    return NULL;
}

// Monitor thread for maintenance
static void* monitor_thread(void *arg) {
    sip_server_t *server = (sip_server_t*)arg;
    
    while (server->running) {
        // Reload data from database every 30 seconds
        load_providers_from_db(server);
        load_dids_from_db(server);
        load_routes_from_db(server);
        
        // Clean up stale DIDs (allocated > 5 minutes ago)
        time_t now = time(NULL);
        pthread_mutex_lock(&server->did_mutex);
        
        did_t *did = server->dids;
        while (did) {
            if (did->in_use && did->allocated_at > 0 && 
                (now - did->allocated_at) > 300) {
                LOG_WARN("Releasing stale DID: %s", did->did);
                release_did(server, did->did);
            }
            did = did->next;
        }
        
        pthread_mutex_unlock(&server->did_mutex);
        
        // Clean up old call states (older than 1 hour)
        pthread_mutex_lock(&server->call_mutex);
        call_state_t **pp = &server->active_calls;
        while (*pp) {
            call_state_t *call = *pp;
            if ((now - call->created_at) > 3600) {
                *pp = call->next;
                
                // Update database
                char query[256];
                snprintf(query, sizeof(query),
                        "UPDATE call_records SET status = 'timeout', ended_at = CURRENT_TIMESTAMP "
                        "WHERE call_id = '%s'",
                        call->call_id);
                db_query(server->db, query);
                
                free(call);
            } else {
                pp = &call->next;
            }
        }
        pthread_mutex_unlock(&server->call_mutex);
        
        sleep(30);
    }
    
    return NULL;
}

// Public functions
sip_server_t* sip_server_create(router_t *router, database_t *db) {
    sip_server_t *server = calloc(1, sizeof(sip_server_t));
    if (!server) return NULL;
    
    server->router = router;
    server->db = db;
    
    // Initialize mutexes
    pthread_mutex_init(&server->provider_mutex, NULL);
    pthread_mutex_init(&server->did_mutex, NULL);
    pthread_mutex_init(&server->route_mutex, NULL);
    pthread_mutex_init(&server->call_mutex, NULL);
    
    // Create UDP socket
    server->socket_fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (server->socket_fd < 0) {
        LOG_ERROR("Failed to create socket: %s", strerror(errno));
        free(server);
        return NULL;
    }
    
    // Set socket options
    int reuse = 1;
    setsockopt(server->socket_fd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    setsockopt(server->socket_fd, SOL_SOCKET, SO_REUSEPORT, &reuse, sizeof(reuse));
    
    // Set non-blocking timeout
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    setsockopt(server->socket_fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    
    // Bind to port
    server->server_addr.sin_family = AF_INET;
    server->server_addr.sin_addr.s_addr = INADDR_ANY;
    server->server_addr.sin_port = htons(SIP_PORT);
    
    if (bind(server->socket_fd, (struct sockaddr*)&server->server_addr, 
             sizeof(server->server_addr)) < 0) {
        LOG_ERROR("Failed to bind to port %d: %s", SIP_PORT, strerror(errno));
        close(server->socket_fd);
        free(server);
        return NULL;
    }
    
    // Load initial data from database
    load_providers_from_db(server);
    load_dids_from_db(server);
    load_routes_from_db(server);
    
    g_sip_server = server;
    
    LOG_INFO("SIP server created on port %d", SIP_PORT);
    return server;
}

void sip_server_destroy(sip_server_t *server) {
    if (!server) return;
    
    sip_server_stop(server);
    
    if (server->socket_fd >= 0) {
        close(server->socket_fd);
    }
    
    // Clean up all linked lists
    pthread_mutex_lock(&server->provider_mutex);
    free_providers(server->providers);
    pthread_mutex_unlock(&server->provider_mutex);
    
    pthread_mutex_lock(&server->did_mutex);
    free_dids(server->dids);
    pthread_mutex_unlock(&server->did_mutex);
    
    pthread_mutex_lock(&server->route_mutex);
    free_routes(server->routes);
    pthread_mutex_unlock(&server->route_mutex);
    
    // Clean up call states
    call_state_t *call = server->active_calls;
    while (call) {
        call_state_t *next = call->next;
        free(call);
        call = next;
    }
    
    pthread_mutex_destroy(&server->provider_mutex);
    pthread_mutex_destroy(&server->did_mutex);
    pthread_mutex_destroy(&server->route_mutex);
    pthread_mutex_destroy(&server->call_mutex);
    
    if (g_sip_server == server) {
        g_sip_server = NULL;
    }
    
    free(server);
}

int sip_server_start(sip_server_t *server) {
    if (!server) return -1;
    
    server->running = 1;
    
    // Start listen thread
    if (pthread_create(&server->listen_thread, NULL, sip_listen_thread, server) != 0) {
        LOG_ERROR("Failed to create listen thread");
        return -1;
    }
    
    // Start monitor thread
    if (pthread_create(&server->monitor_thread, NULL, monitor_thread, server) != 0) {
        LOG_ERROR("Failed to create monitor thread");
        return -1;
    }
    
    LOG_INFO("SIP server started");
    return 0;
}

void sip_server_stop(sip_server_t *server) {
    if (!server) return;
    
    server->running = 0;
    
    // Wait for threads to finish
    pthread_join(server->listen_thread, NULL);
    pthread_join(server->monitor_thread, NULL);
    
    LOG_INFO("SIP server stopped");
}

void sip_server_get_stats(sip_server_t *server, sip_stats_t *stats) {
    if (!server || !stats) return;
    
    stats->total_invites = server->stats.total_invites;
    stats->forwarded_calls = server->stats.forwarded_calls;
    stats->failed_calls = server->stats.failed_calls;
    stats->active = server->running;
}
