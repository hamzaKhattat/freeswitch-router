#ifndef STATE_SYNC_SERVICE_H
#define STATE_SYNC_SERVICE_H

#include "validation/call_validator.h"

typedef struct state_sync_service state_sync_service_t;

state_sync_service_t* state_sync_create(call_validator_t *validator);
int state_sync_start(state_sync_service_t *service);
void state_sync_stop(state_sync_service_t *service);
void state_sync_destroy(state_sync_service_t *service);

#endif
