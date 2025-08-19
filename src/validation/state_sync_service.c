// state_sync_service.c - Simplified state synchronization
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "validation/call_validator.h"
#include "db/database.h"
#include "core/logging.h"

typedef struct {
    call_validator_t *validator;
    pthread_t sync_thread;
    bool running;
    int sync_interval_ms;
} state_sync_service_t;

// Synchronize call states (simplified version)
static void sync_call_states(state_sync_service_t *service) {
    database_t *db = service->validator->db;
    
    const char *query = 
        "INSERT INTO call_state_sync (call_id, server_id, reported_state, expected_state, state_matched) "
        "SELECT cr.call_id, cr.intermediate_provider_id, 'simulated', 'ringing', true "
        "FROM call_records cr "
        "WHERE cr.status = 'routing' AND cr.stage = 2 "
        "AND NOT EXISTS (SELECT 1 FROM call_state_sync css "
        "WHERE css.call_id = cr.call_id AND css.checked_at > NOW() - INTERVAL '10 seconds')";
    
    db_query(db, query);
}

static void* sync_thread_func(void *arg) {
    state_sync_service_t *service = (state_sync_service_t*)arg;
    
    LOG_INFO("State synchronization service started (simplified mode)");
    
    while (service->running) {
        sync_call_states(service);
        usleep(service->sync_interval_ms * 1000);
    }
    
    LOG_INFO("State synchronization service stopped");
    return NULL;
}

state_sync_service_t* state_sync_create(call_validator_t *validator) {
    state_sync_service_t *service = calloc(1, sizeof(state_sync_service_t));
    if (!service) return NULL;
    
    service->validator = validator;
    service->sync_interval_ms = 5000;
    service->running = false;
    
    return service;
}

int state_sync_start(state_sync_service_t *service) {
    if (!service || service->running) return -1;
    
    service->running = true;
    
    if (pthread_create(&service->sync_thread, NULL, sync_thread_func, service) != 0) {
        service->running = false;
        return -1;
    }
    
    return 0;
}

void state_sync_stop(state_sync_service_t *service) {
    if (!service || !service->running) return;
    
    service->running = false;
    pthread_join(service->sync_thread, NULL);
}

void state_sync_destroy(state_sync_service_t *service) {
    if (!service) return;
    state_sync_stop(service);
    free(service);
}
