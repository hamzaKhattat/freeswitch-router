#include <stdlib.h>
#include "core/logging.h"

typedef struct load_balancer {
    int dummy;
} load_balancer_t;

load_balancer_t* lb_create(void) {
    return calloc(1, sizeof(load_balancer_t));
}

void lb_destroy(load_balancer_t *lb) {
    free(lb);
}
