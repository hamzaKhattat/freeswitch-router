// Add this to your main.c after the call_validator initialization

#include "validation/state_sync_service.h"

// Add to global variables section
static state_sync_service_t *g_state_sync = NULL;

// Add to main() after call_validator_start(g_validator)
if (g_validator) {
    // Initialize state synchronization service
    g_state_sync = state_sync_create(g_validator);
    if (g_state_sync) {
        if (state_sync_start(g_state_sync) == 0) {
            LOG_INFO("State synchronization service started");
        } else {
            LOG_ERROR("Failed to start state synchronization service");
        }
    }
}

// Add to cleanup section before call_validator_destroy(g_validator)
if (g_state_sync) {
    state_sync_stop(g_state_sync);
    state_sync_destroy(g_state_sync);
    g_state_sync = NULL;
}
