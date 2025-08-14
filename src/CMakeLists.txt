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
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic")
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")

# Options
option(WITH_FREESWITCH "Enable FreeSWITCH ESL support" ON)
option(WITH_REDIS "Enable Redis caching support" ON)
option(WITH_MONITORING "Enable monitoring endpoints" ON)
option(BUILD_TESTS "Build test suite" ON)

# Find packages
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# Find libraries using pkg-config
pkg_check_modules(JANSSON REQUIRED jansson)
pkg_check_modules(LIBPQ REQUIRED libpq)
pkg_check_modules(LIBEVENT REQUIRED libevent)
pkg_check_modules(LIBCURL REQUIRED libcurl)

# Find optional libraries
if(WITH_REDIS)
    pkg_check_modules(HIREDIS hiredis)
    if(NOT HIREDIS_FOUND)
        message(WARNING "hiredis not found, Redis support disabled")
        set(WITH_REDIS OFF)
    endif()
endif()

# Find FreeSWITCH ESL
if(WITH_FREESWITCH)
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
        set(WITH_FREESWITCH OFF)
    endif()
endif()

# Find readline for CLI
find_package(PkgConfig)
pkg_check_modules(READLINE readline)

# Configure file
configure_file(
    "${PROJECT_SOURCE_DIR}/src/core/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
)

# Include directories
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_BINARY_DIR}
    ${JANSSON_INCLUDE_DIRS}
    ${LIBPQ_INCLUDE_DIRS}
    ${LIBEVENT_INCLUDE_DIRS}
    ${LIBCURL_INCLUDE_DIRS}
)

if(WITH_REDIS)
    include_directories(${HIREDIS_INCLUDE_DIRS})
endif()

if(WITH_FREESWITCH)
    include_directories(${ESL_INCLUDE_DIR})
endif()

if(READLINE_FOUND)
    include_directories(${READLINE_INCLUDE_DIRS})
endif()

# Source files
set(CORE_SOURCES
    src/core/config.c
    src/core/server.c
    src/core/models.c
    src/core/cli.c
    src/utils/logger.c
)

set(DB_SOURCES
    src/db/database.c
    src/db/cache.c
)

set(ROUTER_SOURCES
    src/router/router.c
)

set(SIP_SOURCES
    src/sip/freeswitch_handler.c
)

# Main executable
add_executable(${PROJECT_NAME}
    src/main.c
    ${CORE_SOURCES}
    ${DB_SOURCES}
    ${ROUTER_SOURCES}
    ${SIP_SOURCES}
)

# Link libraries
target_link_libraries(${PROJECT_NAME}
    ${JANSSON_LIBRARIES}
    ${LIBPQ_LIBRARIES}
    ${LIBEVENT_LIBRARIES}
    ${LIBCURL_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
    m
)

if(WITH_REDIS)
    target_link_libraries(${PROJECT_NAME} ${HIREDIS_LIBRARIES})
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_REDIS=1)
endif()

if(WITH_FREESWITCH)
    target_link_libraries(${PROJECT_NAME} ${ESL_LIBRARY})
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_ESL=1)
endif()

if(READLINE_FOUND)
    target_link_libraries(${PROJECT_NAME} ${READLINE_LIBRARIES})
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_READLINE=1)
endif()

# Compile flags
target_compile_options(${PROJECT_NAME} PRIVATE
    ${JANSSON_CFLAGS_OTHER}
    ${LIBPQ_CFLAGS_OTHER}
    ${LIBEVENT_CFLAGS_OTHER}
    ${LIBCURL_CFLAGS_OTHER}
)

if(WITH_REDIS)
    target_compile_options(${PROJECT_NAME} PRIVATE ${HIREDIS_CFLAGS_OTHER})
endif()

# Tests
if(BUILD_TESTS)
    enable_testing()
    
    # Find Check testing framework
    pkg_check_modules(CHECK check)
    
    if(CHECK_FOUND)
        add_executable(test_runner
            src/tests/test_router.c
            ${CORE_SOURCES}
            ${DB_SOURCES}
            ${ROUTER_SOURCES}
            ${SIP_SOURCES}
        )
        
        target_link_libraries(test_runner
            ${CHECK_LIBRARIES}
            ${JANSSON_LIBRARIES}
            ${LIBPQ_LIBRARIES}
            ${LIBEVENT_LIBRARIES}
            ${LIBCURL_LIBRARIES}
            ${CMAKE_THREAD_LIBS_INIT}
            m
        )
        
        if(WITH_REDIS)
            target_link_libraries(test_runner ${HIREDIS_LIBRARIES})
        endif()
        
        if(WITH_FREESWITCH)
            target_link_libraries(test_runner ${ESL_LIBRARY})
        endif()
        
        add_test(NAME router_tests COMMAND test_runner)
    else()
        message(WARNING "Check testing framework not found, tests disabled")
    endif()
endif()

# Installation
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

install(DIRECTORY configs/
    DESTINATION conf
    FILES_MATCHING PATTERN "*.json" PATTERN "*.xml"
)

install(DIRECTORY scripts/
    DESTINATION scripts
    FILES_MATCHING PATTERN "*.sql" PATTERN "*.sh"
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE
)

install(FILES README.md LICENSE
    DESTINATION share/doc/${PROJECT_NAME}
)

# CPack configuration
set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "FreeSWITCH Production Call Router")
set(CPACK_PACKAGE_VENDOR "FreeSWITCH Router Team")
set(CPACK_PACKAGE_CONTACT "support@freeswitch-router.org")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libjansson4, libpq5, libevent-2.1, libcurl4, libhiredis0.14")
set(CPACK_RPM_PACKAGE_REQUIRES "jansson, postgresql-libs, libevent, libcurl, hiredis")

include(CPack)

# Summary
message(STATUS "")
message(STATUS "FreeSWITCH Router Configuration Summary")
message(STATUS "=======================================")
message(STATUS "Version:          ${PROJECT_VERSION}")
message(STATUS "Build type:       ${CMAKE_BUILD_TYPE}")
message(STATUS "Install prefix:   ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")
message(STATUS "Features:")
message(STATUS "  FreeSWITCH ESL: ${WITH_FREESWITCH}")
message(STATUS "  Redis support:  ${WITH_REDIS}")
message(STATUS "  Monitoring:     ${WITH_MONITORING}")
message(STATUS "  Tests:          ${BUILD_TESTS}")
message(STATUS "  Readline CLI:   ${READLINE_FOUND}")
message(STATUS "")
message(STATUS "Compiler flags:   ${CMAKE_C_FLAGS}")
message(STATUS "")
