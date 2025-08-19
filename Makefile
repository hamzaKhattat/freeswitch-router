# Module 2 Complete Makefile

CC = gcc
CFLAGS = -Wall -Wextra -g -I./include -I/usr/include/postgresql -pthread
LDFLAGS = -lpq -lpthread -lreadline -ljson-c -lmicrohttpd -luuid -lcurl

# Directories
BUILD_DIR = build
SRC_DIR = src

# Create build directories
$(shell mkdir -p $(BUILD_DIR)/api $(BUILD_DIR)/cli $(BUILD_DIR)/commands \
                 $(BUILD_DIR)/core $(BUILD_DIR)/db $(BUILD_DIR)/router \
                 $(BUILD_DIR)/sip $(BUILD_DIR)/utils $(BUILD_DIR)/validation \
                 $(BUILD_DIR)/freeswitch)
OBJS = $(BUILD_DIR)/main.o \
       $(BUILD_DIR)/core/config.o \
       $(BUILD_DIR)/core/models.o \
       $(BUILD_DIR)/core/server.o \
       $(BUILD_DIR)/core/utils.o \
       $(BUILD_DIR)/db/cache.o \
       $(BUILD_DIR)/db/database_pg.o \
       $(BUILD_DIR)/router/router.o \
       $(BUILD_DIR)/router/load_balancer.o \
       $(BUILD_DIR)/cli/cli.o \
       $(BUILD_DIR)/cli/cli_commands.o \
       $(BUILD_DIR)/commands/provider_cmd.o \
       $(BUILD_DIR)/commands/route_cmd.o \
       $(BUILD_DIR)/commands/did_cmd.o \
       $(BUILD_DIR)/commands/monitor_cmd.o \
       $(BUILD_DIR)/commands/stats_cmd.o \
       $(BUILD_DIR)/commands/calls_cmd.o \
       $(BUILD_DIR)/commands/sip_cmd.o \
       $(BUILD_DIR)/commands/validation_cmd.o \
       $(BUILD_DIR)/commands/module2_cmd.o \
       $(BUILD_DIR)/sip/sip_server_dynamic.o \
       $(BUILD_DIR)/sip/sip_server_global.o \
       $(BUILD_DIR)/sip/freeswitch_handler.o \
       $(BUILD_DIR)/api/handlers.o \
       $(BUILD_DIR)/api/route_handler.o \
       $(BUILD_DIR)/freeswitch/fs_xml_generator.o \
       $(BUILD_DIR)/freeswitch/fs_generate_module2_dialplan.o \
       $(BUILD_DIR)/validation/call_validator.o \
       $(BUILD_DIR)/utils/logger.o
# Target
TARGET = router

all: $(TARGET)

# Pattern rules
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -c $< -o $@

# Main target
$(TARGET): $(OBJS)
	@echo "Linking $(TARGET)..."
	@$(CC) $(OBJS) -o $@ $(LDFLAGS)
	@echo "✓ Build successful"

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

install: $(TARGET)
	install -m 755 $(TARGET) /usr/local/bin/fs-router

.PHONY: all clean install
