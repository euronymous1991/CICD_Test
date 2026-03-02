# cmake/version.cmake
# Runs at every cmake configure step.
# Queries git for the current commit hash and dirty status,
# then generates build/generated/version_git.h from the template.

option(ENABLE_GIT_VERSION_METADATA "Embed git hash/dirty state in version header" ON)

find_package(Git QUIET)

set(GIT_HASH "unknown")
set(GIT_DIRTY "0")

if(ENABLE_GIT_VERSION_METADATA AND GIT_FOUND AND NOT DEFINED ENV{GITHUB_ACTIONS})
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --is-inside-work-tree
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        RESULT_VARIABLE GIT_WORKTREE_RESULT
        OUTPUT_VARIABLE GIT_WORKTREE
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )

    if(GIT_WORKTREE_RESULT EQUAL 0 AND GIT_WORKTREE STREQUAL "true")
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            RESULT_VARIABLE GIT_HASH_RESULT
            OUTPUT_VARIABLE GIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )

        if(NOT GIT_HASH_RESULT EQUAL 0 OR GIT_HASH STREQUAL "")
            set(GIT_HASH "unknown")
        endif()

        execute_process(
            COMMAND ${GIT_EXECUTABLE} status --porcelain
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            RESULT_VARIABLE GIT_STATUS_RESULT
            OUTPUT_VARIABLE GIT_DIRTY_CHECK
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )

        if(GIT_STATUS_RESULT EQUAL 0 AND NOT GIT_DIRTY_CHECK STREQUAL "")
            set(GIT_DIRTY "1")
        endif()
    endif()
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
