#ifndef CACHE_H
#define CACHE_H

#include <stddef.h>
#include <stdbool.h>

typedef struct cache cache_t;

cache_t* cache_create(const char *host, int port, int pool_size);
void cache_destroy(cache_t *cache);
int cache_get(cache_t *cache, const char *key, char *value, size_t len);
int cache_set(cache_t *cache, const char *key, const char *value, int ttl);

#endif
