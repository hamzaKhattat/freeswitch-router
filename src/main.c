// main.c - Complete Dynamic FreeSWITCH Router with Call Validation System
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/stat.h>
#include "cli/cli.h"
#include "db/database.h"
#include "core/server.h"
#include "router/router.h"
#include "sip/sip_server.h"
#include "sip/freeswitch_handler.h"
#include "core/config.h"
#include "core/logging.h"
#include "freeswitch/fs_xml_generator.h"
#include "validation/call_validator.h"

// Global instances
cli_t *g_cli = NULL;
static database_t *g_db = NULL;
static router_t *g_router = NULL;
static server_t *g_server = NULL;
sip_server_t *g_sip_server = NULL;
static freeswitch_handler_t *g_fs_handler = NULL;
call_validator_t *g_validator = NULL;  // Global validator instance
static bool running = true;

void signal_handler(int sig) {
    if (sig == SIGINT || sig == SIGTERM) {
        LOG_INFO("Shutting down...");
        running = false;
        if (g_cli) cli_stop(g_cli);
    }
}

static int ensure_freeswitch_running() {
    if (system("pgrep freeswitch > /dev/null 2>&1") != 0) {
        LOG_WARN("FreeSWITCH is not running, attempting to start...");
        if (system("freeswitch -nc -nonat") != 0) {
            LOG_ERROR("Failed to start FreeSWITCH");
            return -1;
        }
        sleep(5);
        if (system("pgrep freeswitch > /dev/null 2>&1") != 0) {
            LOG_ERROR("FreeSWITCH failed to start");
            return -1;
        }
    }
    LOG_INFO("FreeSWITCH is running");
    return 0;
}

static int initialize_freeswitch_config() {
    LOG_INFO("Initializing FreeSWITCH configuration...");
    
    if (fs_init_all_directories() != 0) {
        LOG_ERROR("Failed to initialize directories");
        return -1;
    }
    
    if (fs_generate_main_config() != 0) {
        LOG_ERROR("Failed to generate main config");
        return -1;
    }
    
    if (fs_generate_sip_profiles() != 0) {
        LOG_ERROR("Failed to generate SIP profiles");
        return -1;
    }
    
    if (fs_generate_dialplan_contexts() != 0) {
        LOG_ERROR("Failed to generate dialplan contexts");
        return -1;
    }
    
    if (fs_generate_autoload_configs() != 0) {
        LOG_ERROR("Failed to generate autoload configs");
        return -1;
    }
    
    LOG_INFO("FreeSWITCH base configuration initialized");
    return 0;
}

static int sync_freeswitch_with_database() {
    if (!g_db) return -1;
    
    LOG_INFO("Synchronizing FreeSWITCH with database...");
    LOG_INFO("Generating provider configurations...");
    fs_regenerate_all_providers();
    LOG_INFO("Generating route dialplans...");
    fs_generate_route_dialplan();
    LOG_INFO("Reloading FreeSWITCH...");
    fs_reload_config();
    LOG_INFO("FreeSWITCH synchronized with database");
    return 0;
}

static void print_startup_banner() {
    printf("\n");
    printf("╔════════════════════════════════════════════════════════════╗\n");
    printf("║     FreeSWITCH Dynamic Call Router v3.0                   ║\n");
    printf("║     S1 → S2 → S3 → S2 → S4 Call Flow                      ║\n");
    printf("║     With Call Validation System                           ║\n");
    printf("╚════════════════════════════════════════════════════════════╝\n");
    printf("\n");
}

// Monitor thread for validation system
static void* validation_monitor_thread(void *arg) {
    (void)arg;
    
    LOG_INFO("Validation monitor thread started");
    
    while (running) {
        if (g_validator) {
            // Clean up expired validations every 5 minutes
            cleanup_expired_validations(g_validator);
        }
        
        sleep(300); // 5 minutes
    }
    
    LOG_INFO("Validation monitor thread stopped");
    return NULL;
}

int main(int argc, char *argv[]) {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    print_startup_banner();
    
    logger_init("logs/router.log");
    LOG_INFO("FreeSWITCH Dynamic Router with Validation starting...");
    
    app_config_t *config = config_load("configs/config.json");
    if (!config) {
        LOG_WARN("No config file found, using defaults");
        config = config_load(NULL);
    }
    
    LOG_INFO("Connecting to PostgreSQL database...");
    g_db = db_init(NULL);
    if (!g_db) {
        LOG_ERROR("Failed to connect to database");
        config_free(config);
        return 1;
    }
    LOG_INFO("Database connected successfully");
    
    // Initialize router
    g_router = router_create(g_db, NULL, NULL);
    if (!g_router) {
        LOG_ERROR("Failed to create router");
        db_close(g_db);
        config_free(config);
        return 1;
    }
    LOG_INFO("Router initialized");
    
    // Initialize call validation system
    LOG_INFO("Initializing call validation system...");
    g_validator = call_validator_create(g_db, g_router);
    if (!g_validator) {
        LOG_ERROR("Failed to create call validator");
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        return 1;
    }
    
    if (call_validator_start(g_validator) != 0) {
        LOG_ERROR("Failed to start call validator");
        call_validator_destroy(g_validator);
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        return 1;
    }
    LOG_INFO("Call validation system started");
    
    // Start validation monitor thread
    pthread_t monitor_thread;
    pthread_create(&monitor_thread, NULL, validation_monitor_thread, NULL);
    
    if (argc > 1 && strcmp(argv[1], "-d") != 0 && strcmp(argv[1], "--daemon") != 0) {
        int ret = cli_execute_command(argc - 1, &argv[1]);
        
        // Cleanup
        call_validator_stop(g_validator);
        call_validator_destroy(g_validator);
        router_destroy(g_router);
        db_close(g_db);
        config_free(config);
        logger_close();
        return ret;
    }
    
    bool daemon_mode = false;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-d") == 0 || strcmp(argv[i], "--daemon") == 0) {
            daemon_mode = true;
            break;
        }
    }
    
    if (daemon_mode || argc == 1) {
        if (ensure_freeswitch_running() != 0) {
            LOG_ERROR("FreeSWITCH is required but not available");
            call_validator_stop(g_validator);
            call_validator_destroy(g_validator);
            router_destroy(g_router);
            db_close(g_db);
            config_free(config);
            return 1;
        }
        
        if (initialize_freeswitch_config() != 0) {
            LOG_ERROR("Failed to initialize FreeSWITCH configuration");
            call_validator_stop(g_validator);
            call_validator_destroy(g_validator);
            router_destroy(g_router);
            db_close(g_db);
            config_free(config);
            return 1;
        }
        
        if (sync_freeswitch_with_database() != 0) {
            LOG_ERROR("Failed to sync FreeSWITCH with database");
        }
    }
    
    if (daemon_mode) {
        LOG_INFO("Starting in daemon mode");
        printf("Running in daemon mode (background)\n");
        printf("Call validation system is active\n");
        
        g_server = server_create(config->server.port, g_router);
        if (g_server) {
            server_start(g_server);
            LOG_INFO("HTTP API server started on port %d", config->server.port);
        }
        
        // Create SIP server with validation
        g_sip_server = sip_server_create(g_router, g_db);
        if (g_sip_server) {
            sip_server_start(g_sip_server);
            LOG_INFO("SIP server started with validation support");
        }
        
        while (running) {
            sleep(1);
        }
    } else {
        printf("Starting interactive CLI...\n");
        printf("Type 'help' for available commands\n");
        printf("Call validation system is active\n\n");
        
        g_cli = cli_create();
        if (g_cli) {
            cli_run(g_cli);
            cli_destroy(g_cli);
        }
    }
    
    LOG_INFO("Shutting down...");
    
    // Stop validation monitor
    running = false;
    pthread_join(monitor_thread, NULL);
    
    // Stop and destroy validation system
    if (g_validator) {
        LOG_INFO("Stopping call validation system...");
        call_validator_stop(g_validator);
        call_validator_destroy(g_validator);
    }
    
    if (g_sip_server) {
        sip_server_stop(g_sip_server);
        sip_server_destroy(g_sip_server);
    }
    
    if (g_server) {
        server_stop(g_server);
        server_destroy(g_server);
    }
    
    if (g_router) {
        router_destroy(g_router);
    }
    
    if (g_db) {
        db_close(g_db);
    }
    
    config_free(config);
    logger_close();
    
    printf("Shutdown complete\n");
    return 0;
}
