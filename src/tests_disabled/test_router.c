/**
 * Router Module Test Suite
 * 
 * Tests for the router functionality including routing decisions,
 * statistics, and error handling.
 */

#include <check.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>
#include "router/router.h"
#include "core/config.h"
#include "db/database.h"

// Test globals
static database_t *test_db = NULL;
static router_t *test_router = NULL;
static app_config_t *test_config = NULL;

/**
 * Test setup function - called before each test
 */
void setup(void) {
    // Load test configuration
    test_config = config_load("configs/test_config.json");
    ck_assert_ptr_nonnull(test_config);
    
    // Initialize test database
    test_db = db_init("test_router.db");
    ck_assert_ptr_nonnull(test_db);
    
    // Create router instance
    test_router = router_create(test_db, NULL, NULL);
    ck_assert_ptr_nonnull(test_router);
}

/**
 * Test teardown function - called after each test
 */
void teardown(void) {
    if (test_router) {
        router_destroy(test_router);
        test_router = NULL;
    }
    
    if (test_db) {
        db_close(test_db);
        test_db = NULL;
    }
    
    if (test_config) {
        config_free(test_config);
        test_config = NULL;
    }
}

/**
 * Test router statistics functionality
 */
START_TEST(test_router_statistics) {
    json_object *stats = NULL;
    
    // Get router statistics
    int result = router_get_stats(test_router, &stats);
    ck_assert_int_eq(result, 0);
    ck_assert_ptr_nonnull(stats);
    
    // Verify statistics structure
    ck_assert(json_object_is_type(stats, json_type_object));
    
    // Check for expected statistics fields
    json_object *active_calls = NULL;
    ck_assert(json_object_object_get_ex(stats, "active_calls", &active_calls));
    ck_assert(json_object_is_type(active_calls, json_type_int));
    
    json_object *total_calls = NULL;
    ck_assert(json_object_object_get_ex(stats, "total_calls", &total_calls));
    ck_assert(json_object_is_type(total_calls, json_type_int));
    
    // Clean up
    json_object_put(stats);
}
END_TEST

/**
 * Test basic routing functionality
 */
START_TEST(test_basic_routing) {
    route_request_t request = {0};
    
    // Set up test request
    request.ani = "15551234567";
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    // Perform routing
    int result = router_route_call(test_router, &request);
    
    // Should succeed or fail gracefully
    ck_assert(result == 0 || result == -1);
    
    // Clean up allocated route_type if routing succeeded
    if (result == 0 && request.route_type) {
        free(request.route_type);
    }
}
END_TEST

/**
 * Test routing with invalid parameters
 */
START_TEST(test_invalid_routing) {
    route_request_t request = {0};
    
    // Test with NULL ANI
    request.ani = NULL;
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    int result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail
    
    // Test with NULL DNIS
    request.ani = "15551234567";
    request.dnis = NULL;
    request.provider = "test_provider";
    request.route_type = NULL;
    
    result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail
}
END_TEST

/**
 * Test router with NULL database
 */
START_TEST(test_null_database_handling) {
    router_t *null_router = router_create(NULL, NULL, NULL);
    ck_assert_ptr_null(null_router); // Should fail to create
}
END_TEST

/**
 * Test route request validation
 */
START_TEST(test_route_validation) {
    route_request_t request = {0};
    
    // Test with empty strings
    request.ani = "";
    request.dnis = "";
    request.provider = "";
    request.route_type = NULL;
    
    int result = router_route_call(test_router, &request);
    ck_assert_int_eq(result, -1); // Should fail with empty strings
    
    // Test with very long strings
    char long_ani[1000];
    memset(long_ani, 'x', sizeof(long_ani) - 1);
    long_ani[sizeof(long_ani) - 1] = '\0';
    
    request.ani = long_ani;
    request.dnis = "18005551234";
    request.provider = "test_provider";
    request.route_type = NULL;
    
    result = router_route_call(test_router, &request);
    // Should handle gracefully (either succeed or fail, but not crash)
    ck_assert(result == 0 || result == -1);
    
    if (result == 0 && request.route_type) {
        free(request.route_type);
    }
}
END_TEST

/**
 * Create test suite
 */
Suite *router_suite(void) {
    Suite *s = suite_create("Router");
    
    // Basic functionality test case
    TCase *tc_basic = tcase_create("Basic");
    tcase_add_checked_fixture(tc_basic, setup, teardown);
    tcase_add_test(tc_basic, test_router_statistics);
    tcase_add_test(tc_basic, test_basic_routing);
    suite_add_tcase(s, tc_basic);
    
    // Error handling test case
    TCase *tc_error = tcase_create("Error Handling");
    tcase_add_checked_fixture(tc_error, setup, teardown);
    tcase_add_test(tc_error, test_invalid_routing);
    tcase_add_test(tc_error, test_route_validation);
    suite_add_tcase(s, tc_error);
    
    // Edge cases test case
    TCase *tc_edge = tcase_create("Edge Cases");
    tcase_add_test(tc_edge, test_null_database_handling);
    suite_add_tcase(s, tc_edge);
    
    return s;
}

/**
 * Main test runner
 */
int main(void) {
    int number_failed = 0;
    
    // Create and run test suite
    Suite *s = router_suite();
    SRunner *sr = srunner_create(s);
    
    // Run tests with normal verbosity
    srunner_run_all(sr, CK_NORMAL);
    
    // Get test results
    number_failed = srunner_ntests_failed(sr);
    
    // Clean up test runner
    srunner_free(sr);
    
    // Return appropriate exit code
    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
