#ifndef LOAD_BALANCER_H
#define LOAD_BALANCER_H

typedef struct load_balancer load_balancer_t;

load_balancer_t* lb_create(void);
void lb_destroy(load_balancer_t *lb);

#endif
