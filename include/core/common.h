#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>
#include <errno.h>
#include <pthread.h>

// Error codes
#define ERR_SUCCESS 0
#define ERR_FAILURE -1
#define ERR_NOT_FOUND -2
#define ERR_TIMEOUT -3
#define ERR_INVALID_PARAM -4
#define ERR_NO_MEMORY -5

// Common macros
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

#endif
