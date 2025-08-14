CC = gcc
CFLAGS = -Wall -O2 -g -pthread -I./include -I/usr/include/postgresql
LDFLAGS = -lpq -lpthread -lreadline -lm -luuid -ljson-c -lmicrohttpd

# ESL configuration
ESL_PATH = /usr/local/src/freeswitch/libs/esl
ESL_LIB = $(ESL_PATH)/libesl.a
ESL_INC = -I$(ESL_PATH)/src/include

# Check if ESL exists
HAS_ESL := $(shell test -f $(ESL_LIB) && echo yes || echo no)

ifeq ($(HAS_ESL),yes)
    CFLAGS += $(ESL_INC) -DHAS_ESL
    EXTRA_LIBS = $(ESL_LIB)
    EXTRA_SRC = src/freeswitch/fs_router_api.c
else
    EXTRA_LIBS =
    EXTRA_SRC =
endif

# Main source files (no duplicates, no tests)
SOURCES = src/main.c \
    src/api/handlers.c \
    src/api/route_handler.c \
    src/cli/cli.c \
    src/cli/cli_commands.c \
    src/commands/calls_cmd.c \
    src/commands/did_cmd.c \
    src/commands/monitor_cmd.c \
    src/commands/monitor_fix.c \
    src/commands/provider_cmd.c \
    src/commands/provider_mgmt.c \
    src/commands/route_cmd.c \
    src/commands/sip_cmd.c \
    src/commands/stats_cmd.c \
    src/core/config.c \
    src/core/models.c \
    src/core/server.c \
    src/core/utils.c \
    src/db/cache.c \
    src/db/database_pg.c \
    src/router/load_balancer.c \
    src/router/router.c \
    src/sip/freeswitch_handler.c \
    src/sip/sip_server_dynamic.c \
    src/sip/sip_server_global.c \
    src/freeswitch/freeswitch_integration.c \
    src/freeswitch/fs_xml_generator.c \
    src/utils/logger.c \
    $(EXTRA_SRC)

OBJECTS = $(SOURCES:.c=.o)

all: router

router: $(OBJECTS)
	$(CC) $(OBJECTS) -o router $(EXTRA_LIBS) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) router
	find src -name "*.o" -delete

install: router
	mkdir -p /opt/freeswitch-router/bin
	cp router /opt/freeswitch-router/bin/
	chmod +x /opt/freeswitch-router/bin/router
	ln -sf /opt/freeswitch-router/bin/router /usr/local/bin/router

.PHONY: all clean install
