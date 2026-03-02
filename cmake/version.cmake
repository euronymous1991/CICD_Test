# cmake/version.cmake
# Runs at every cmake configure step.
# Queries git for the current commit hash and dirty status,
# then generates build/generated/version_git.h from the template.

find_package(Git QUIET)

if(GIT_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} status --porcelain
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_DIRTY_CHECK
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
else()
    set(GIT_HASH "unknown")
    set(GIT_DIRTY_CHECK "")
endif()

if(GIT_DIRTY_CHECK STREQUAL "")
    set(GIT_DIRTY "0")
else()
    set(GIT_DIRTY "1")
endif()

string(TIMESTAMP BUILD_DATE "%Y-%m-%d")
string(TIMESTAMP BUILD_TIME "%H:%M:%S")

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/generated)

configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/version_git.h.in
    ${CMAKE_BINARY_DIR}/generated/version_git.h
    @ONLY
)

message(STATUS "Version: ${GIT_HASH} dirty=${GIT_DIRTY} built ${BUILD_DATE} ${BUILD_TIME}")