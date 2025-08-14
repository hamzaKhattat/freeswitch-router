cmake_minimum_required(VERSION 3.10)
project(freeswitch_router VERSION 3.0.0 LANGUAGES C)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")

# Find packages
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# Find libraries
pkg_check_modules(JANSSON REQUIRED jansson)
pkg_check_modules(LIBPQ REQUIRED libpq)
pkg_check_modules(LIBEVENT REQUIRED libevent)

# Optional: Find hiredis
pkg_check_modules(HIREDIS hiredis)

# Optional: Find ESL
find_path(ESL_INCLUDE_DIR esl.h
    PATHS /usr/local/include /usr/include
    PATH_SUFFIXES esl
)
find_library(ESL_LIBRARY esl
    PATHS /usr/local/lib /usr/lib
)

if(ESL_INCLUDE_DIR AND ESL_LIBRARY)
    message(STATUS "ESL library found: ${ESL_LIBRARY}")
    set(HAVE_ESL 1)
else()
    message(WARNING "ESL library not found, FreeSWITCH support disabled")
endif()

# Include directories
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${JANSSON_INCLUDE_DIRS}
    ${LIBPQ_INCLUDE_DIRS}
    ${LIBEVENT_INCLUDE_DIRS}
)

if(HIREDIS_FOUND)
    include_directories(${HIREDIS_INCLUDE_DIRS})
endif()

if(HAVE_ESL)
    include_directories(${ESL_INCLUDE_DIR})
endif()

# Source files
set(SOURCES
    src/main.c
    src/core/config.c
    src/core/server.c
    src/core/models.c
    src/core/cli.c
    src/db/database.c
    src/db/cache.c
    src/router/router.c
    src/sip/freeswitch_handler.c
    src/utils/logger.c
)

# Main executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${PROJECT_NAME}
    ${JANSSON_LIBRARIES}
    ${LIBPQ_LIBRARIES}
    ${LIBEVENT_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
    m
    readline
)

if(HIREDIS_FOUND)
    target_link_libraries(${PROJECT_NAME} ${HIREDIS_LIBRARIES})
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_REDIS=1)
endif()

if(HAVE_ESL)
    target_link_libraries(${PROJECT_NAME} ${ESL_LIBRARY})
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_ESL=1)
endif()

# Installation
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(DIRECTORY configs/ DESTINATION conf)
install(DIRECTORY scripts/ DESTINATION scripts)
