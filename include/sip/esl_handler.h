#ifndef ESL_HANDLER_H
#define ESL_HANDLER_H

#include "core/common.h"
#include "core/config.h"
#include "router/router.h"

#ifdef HAVE_ESL
#include <esl.h>

typedef struct esl_handler esl_handler_t;

// ESL handler management
esl_handler_t* esl_handler_create(const freeswitch_esl_config_t *config, router_t *router);
void esl_handler_destroy(esl_handler_t *handler);

// Connection management
int esl_handler_connect(esl_handler_t *handler);
void esl_handler_disconnect(esl_handler_t *handler);
bool esl_handler_is_connected(esl_handler_t *handler);

// Event handling
int esl_handler_start(esl_handler_t *handler);
void esl_handler_stop(esl_handler_t *handler);

// Command execution
int esl_handler_execute(esl_handler_t *handler, const char *command, char *response, size_t response_size);
int esl_handler_api(esl_handler_t *handler, const char *cmd, const char *args, char *response, size_t response_size);

#else
// Dummy implementations when ESL is not available
typedef struct esl_handler esl_handler_t;
typedef struct freeswitch_esl_config freeswitch_esl_config_t;  // Add this line to declare the type

static inline esl_handler_t* esl_handler_create(const freeswitch_esl_config_t *config, router_t *router) { 
    (void)config;
    (void)router;
    return NULL; 
}
static inline void esl_handler_destroy(esl_handler_t *handler) { 
    (void)handler;
}
static inline int esl_handler_connect(esl_handler_t *handler) { 
    (void)handler;
    return ERR_SUCCESS; 
}
static inline void esl_handler_disconnect(esl_handler_t *handler) { 
    (void)handler;
}
static inline bool esl_handler_is_connected(esl_handler_t *handler) { 
    (void)handler;
    return false; 
}
static inline int esl_handler_start(esl_handler_t *handler) { 
    (void)handler;
    return ERR_SUCCESS; 
}
static inline void esl_handler_stop(esl_handler_t *handler) { 
    (void)handler;
}
#endif

#endif // ESL_HANDLER_H
