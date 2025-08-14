#include <stdio.h>
#include <string.h>
#include <time.h>

char* get_timestamp(void) {
    static char buffer[32];
    time_t now = time(NULL);
    struct tm *tm = localtime(&now);
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", tm);
    return buffer;
}
