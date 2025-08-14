#ifndef MODELS_H
#define MODELS_H

#include <stdbool.h>
#include <time.h>

// Constants
#define MAX_NAME_LEN 256
#define MAX_HOST_LEN 256
#define MAX_USERNAME_LEN 128
#define MAX_PASSWORD_LEN 128
#define MAX_PATTERN_LEN 256
#define MAX_DESCRIPTION_LEN 512
#define MAX_DID_LEN 50

// Provider model
typedef struct {
    int id;
    char name[MAX_NAME_LEN];
    char host[MAX_HOST_LEN];
    int port;
    char username[MAX_USERNAME_LEN];
    char password[MAX_PASSWORD_LEN];
    char transport[16];
    int capacity;
    int current_calls;
    bool active;
    int priority;
    time_t created_at;
    time_t updated_at;
    void *metadata;  // Changed from json_t to void*
} provider_t;

// Route model
typedef struct {
    int id;
    char pattern[MAX_PATTERN_LEN];
    int provider_id;
    int priority;
    char description[MAX_DESCRIPTION_LEN];
    bool active;
    time_t created_at;
} route_t;

// DID model
typedef struct {
    int id;
    char did_number[MAX_DID_LEN];
    int provider_id;
    bool active;
    time_t created_at;
} did_t;

// Call model
typedef struct {
    int id;
    char uuid[256];
    char ani[MAX_DID_LEN];
    char dnis[MAX_DID_LEN];
    char provider[MAX_NAME_LEN];
    int route_id;
    char status[50];
    time_t created_at;
    time_t answered_at;
    time_t ended_at;
    int duration;
} call_t;

// Statistics model
typedef struct {
    int provider_id;
    int total_calls;
    int successful_calls;
    int failed_calls;
    double avg_duration;
    time_t date;
} statistics_t;

// Model functions
provider_t* provider_create(void);
void provider_free(provider_t *provider);

route_t* route_create(void);
void route_free(route_t *route);

did_t* did_create(void);
void did_free(did_t *did);

call_t* call_create(void);
void call_free(call_t *call);

#endif
