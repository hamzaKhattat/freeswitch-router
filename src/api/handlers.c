#include <microhttpd.h>
#include <string.h>
#include "core/logging.h"

int handle_api_request(struct MHD_Connection *connection, 
                      const char *url,
                      const char *method,
                      const char *upload_data,
                      size_t *upload_data_size) {
    
    // Suppress unused parameter warnings
    (void)url;
    (void)method;
    (void)upload_data;
    (void)upload_data_size;
    
    const char *response = "{\"status\":\"ok\"}";
    
    struct MHD_Response *mhd_response = MHD_create_response_from_buffer(
        strlen(response), (void*)response, MHD_RESPMEM_PERSISTENT);
    
    int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
    MHD_destroy_response(mhd_response);
    
    return ret;
}
