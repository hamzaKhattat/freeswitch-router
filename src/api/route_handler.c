#include <microhttpd.h>
#include <json-c/json.h>
#include <string.h>
#include "db/database.h"
#include "core/logging.h"

int handle_route_request(struct MHD_Connection *connection, const char *data) {
    struct json_object *request, *response;
    struct json_object *ani_obj, *dnis_obj, *provider_obj;
    const char *ani = NULL, *dnis = NULL, *provider = NULL;
    
    request = json_tokener_parse(data);
    if (!request) {
        return MHD_HTTP_BAD_REQUEST;
    }
    
    // Get JSON objects first, then extract strings
    if (json_object_object_get_ex(request, "ani", &ani_obj)) {
        ani = json_object_get_string(ani_obj);
    }
    if (json_object_object_get_ex(request, "dnis", &dnis_obj)) {
        dnis = json_object_get_string(dnis_obj);
    }
    if (json_object_object_get_ex(request, "provider", &provider_obj)) {
        provider = json_object_get_string(provider_obj);
    }
    
    // Log the request
    LOG_INFO("Route request: ANI=%s, DNIS=%s, Provider=%s", 
             ani ? ani : "null", 
             dnis ? dnis : "null", 
             provider ? provider : "null");
    
    // Query database for route
    database_t *db = get_database();
    const char *sql = "SELECT p.name FROM routes r "
                     "JOIN providers p ON r.provider_id = p.id "
                     "WHERE ? REGEXP r.pattern "
                     "ORDER BY r.priority LIMIT 1";
    
    db_stmt_t *stmt = db_prepare(db, sql);
    db_bind_string(stmt, 1, dnis);
    
    db_result_t *result = db_execute_query(stmt);
    
    response = json_object_new_object();
    
    if (result && result->num_rows > 0) {
        const char *gateway = db_get_value(result, 0, 0);
        json_object_object_add(response, "gateway", json_object_new_string(gateway));
        json_object_object_add(response, "type", json_object_new_string("route"));
        json_object_object_add(response, "ani", json_object_new_string(ani ? ani : ""));
        json_object_object_add(response, "dnis", json_object_new_string(dnis ? dnis : ""));
    } else {
        json_object_object_add(response, "error", json_object_new_string("No route found"));
    }
    
    const char *response_str = json_object_to_json_string(response);
    
    struct MHD_Response *mhd_response = MHD_create_response_from_buffer(
        strlen(response_str), (void *)response_str, MHD_RESPMEM_MUST_COPY);
    
    MHD_add_response_header(mhd_response, "Content-Type", "application/json");
    
    int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
    
    MHD_destroy_response(mhd_response);
    json_object_put(response);
    json_object_put(request);
    if (result) db_free_result(result);
    db_finalize(stmt);
    
    return ret;
}
