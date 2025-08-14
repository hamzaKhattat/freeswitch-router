#ifndef API_HANDLERS_H
#define API_HANDLERS_H

#include <microhttpd.h>

int handle_api_request(struct MHD_Connection *connection, 
                      const char *url,
                      const char *method,
                      const char *upload_data,
                      size_t *upload_data_size);

#endif
