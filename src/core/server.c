#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <microhttpd.h>
#include "core/server.h"
#include "core/logging.h"
#include "router/router.h"
#include "api/handlers.h"

struct server {
    struct MHD_Daemon *daemon;
    router_t *router;
    int port;
    bool running;
};

server_t* server_create(int port, router_t *router) {
    server_t *server = calloc(1, sizeof(server_t));
    if (!server) return NULL;
    
    server->port = port;
    server->router = router;
    server->running = false;
    
    return server;
}

void server_destroy(server_t *server) {
    if (server) {
        server_stop(server);
        free(server);
    }
}

// Updated to use enum MHD_Result
static enum MHD_Result handle_request(void *cls,
                                     struct MHD_Connection *connection,
                                     const char *url,
                                     const char *method,
                                     const char *version,
                                     const char *upload_data,
                                     size_t *upload_data_size,
                                     void **con_cls) {
    
    (void)cls;
    (void)version;
    (void)con_cls;
    
    int ret = handle_api_request(connection, url, method, upload_data, upload_data_size);
    
    // Convert int to enum MHD_Result
    return (ret == MHD_HTTP_OK || ret == MHD_YES) ? MHD_YES : MHD_NO;
}

int server_start(server_t *server) {
    server->daemon = MHD_start_daemon(
        MHD_USE_SELECT_INTERNALLY | MHD_USE_EPOLL_LINUX_ONLY,
        server->port,
        NULL, NULL,
        &handle_request, server,
        MHD_OPTION_THREAD_POOL_SIZE, (unsigned int)8,
        MHD_OPTION_CONNECTION_LIMIT, (unsigned int)1000,
        MHD_OPTION_CONNECTION_TIMEOUT, (unsigned int)30,
        MHD_OPTION_END);
    
    if (!server->daemon) {
        LOG_ERROR("Failed to start HTTP server on port %d", server->port);
        return -1;
    }
    
    server->running = true;
    LOG_INFO("HTTP server started on 0.0.0.0:%d", server->port);
    return 0;
}

void server_stop(server_t *server) {
    if (server && server->daemon) {
        MHD_stop_daemon(server->daemon);
        server->daemon = NULL;
        server->running = false;
    }
}

bool server_is_running(server_t *server) {
    return server && server->running;
}
