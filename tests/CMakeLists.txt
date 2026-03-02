# tests/CMakeLists.txt
# Unit test build — runs on host PC using GCC, NOT arm-none-eabi-gcc.
# Included only when CMAKE_CROSSCOMPILING is FALSE (no toolchain file passed).

cmake_minimum_required(VERSION 3.20)

# Download Unity test framework
include(FetchContent)
FetchContent_Declare(
    unity
    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
    GIT_TAG        v2.6.0
    GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(unity)

set(TEST_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/app/Inc
    ${CMAKE_SOURCE_DIR}/bsp/Inc
    ${CMAKE_SOURCE_DIR}/tests/mocks
    ${unity_SOURCE_DIR}/src
)

set(TEST_COMPILE_FLAGS
    -Wall -Wextra -DUNIT_TEST
    -fprofile-arcs -ftest-coverage
    -g -O0
)

# Macro to register a unit test executable
macro(add_unit_test TEST_NAME)
    cmake_parse_arguments(ARG "" "" "SOURCES;MOCKS" ${ARGN})
    add_executable(${TEST_NAME}
        ${ARG_SOURCES}
        ${ARG_MOCKS}
        ${unity_SOURCE_DIR}/src/unity.c
    )
    target_include_directories(${TEST_NAME} PRIVATE ${TEST_INCLUDE_DIRS})
    target_compile_options(${TEST_NAME} PRIVATE ${TEST_COMPILE_FLAGS})
    target_link_options(${TEST_NAME} PRIVATE -fprofile-arcs -ftest-coverage)
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endmacro()

# Register test executables
add_unit_test(test_led_manager
    SOURCES
        ${CMAKE_SOURCE_DIR}/tests/unit/test_led_manager.c
        ${CMAKE_SOURCE_DIR}/app/Src/led_manager.c
    MOCKS
        ${CMAKE_SOURCE_DIR}/tests/mocks/mock_bsp.c
)

add_unit_test(test_uart_logger
    SOURCES
        ${CMAKE_SOURCE_DIR}/tests/unit/test_uart_logger.c
        ${CMAKE_SOURCE_DIR}/app/Src/uart_logger.c
    MOCKS
        ${CMAKE_SOURCE_DIR}/tests/mocks/mock_bsp.c
)
