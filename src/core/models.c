#include "core/logging.h"
#include <stdlib.h>
#include <string.h>
#include "core/models.h"

// Provider functions
provider_t* provider_create(void) {
    provider_t *provider = calloc(1, sizeof(provider_t));
    if (!provider) return NULL;
    
    // Set defaults
    provider->port = 5060;
    provider->capacity = 100;
    provider->active = true;
    provider->priority = 100;
    strcpy(provider->transport, "udp");
    
    return provider;
}

void provider_free(provider_t *provider) {
    if (!provider) return;
    
    // Free metadata if allocated
    if (provider->metadata) {
        free(provider->metadata);
    }
    
    free(provider);
}

// Route functions
route_t* route_create(void) {
    route_t *route = calloc(1, sizeof(route_t));
    if (!route) return NULL;
    
    route->active = true;
    route->priority = 100;
    
    return route;
}

void route_free(route_t *route) {
    if (!route) return;
    free(route);
}

// DID functions
did_t* did_create(void) {
    did_t *did = calloc(1, sizeof(did_t));
    if (!did) return NULL;
    
    did->active = true;
    
    return did;
}

void did_free(did_t *did) {
    if (!did) return;
    free(did);
}

// Call functions
call_t* call_create(void) {
    call_t *call = calloc(1, sizeof(call_t));
    if (!call) return NULL;
    
    strcpy(call->status, "active");
    call->created_at = time(NULL);
    
    return call;
}

void call_free(call_t *call) {
    if (!call) return;
    free(call);
}
