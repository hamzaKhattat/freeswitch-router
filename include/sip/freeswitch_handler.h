#ifndef FREESWITCH_HANDLER_H
#define FREESWITCH_HANDLER_H

#include <stdbool.h>

typedef struct freeswitch_handler freeswitch_handler_t;

typedef struct {
    int total_calls;
    int active_calls;
    int failed_calls;
    bool connected;
} fs_stats_t;

// Core functions
freeswitch_handler_t* freeswitch_handler_create(const char *host, int port, const char *password);
void freeswitch_handler_destroy(freeswitch_handler_t *handler);
int freeswitch_handler_connect(freeswitch_handler_t *handler);
int freeswitch_handler_execute(freeswitch_handler_t *handler, const char *command);
int freeswitch_handler_get_stats(freeswitch_handler_t *handler, fs_stats_t *stats);
bool freeswitch_handler_is_connected(freeswitch_handler_t *handler);

// Event loop functions
int freeswitch_handler_start_event_loop(freeswitch_handler_t *handler);
void freeswitch_handler_stop_event_loop(freeswitch_handler_t *handler);

#endif
