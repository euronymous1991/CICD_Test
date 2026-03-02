cmake_minimum_required(VERSION 3.20)

include(FetchContent)
FetchContent_Declare(
    unity
    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
    GIT_TAG        v2.6.0
    GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(unity)

if(WIN32)
    set(TEST_COMPILE_FLAGS -Wall -Wextra -DUNIT_TEST -g -O0)
    set(TEST_LINK_FLAGS "")
else()
    set(TEST_COMPILE_FLAGS -Wall -Wextra -DUNIT_TEST -fprofile-arcs -ftest-coverage -g -O0)
    set(TEST_LINK_FLAGS -fprofile-arcs -ftest-coverage)
endif()

set(TEST_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/app/Inc
    ${CMAKE_SOURCE_DIR}/bsp/Inc
    ${CMAKE_SOURCE_DIR}/tests/mocks
    ${CMAKE_BINARY_DIR}/generated
    ${unity_SOURCE_DIR}/src
)

macro(add_unit_test TEST_NAME)
    cmake_parse_arguments(ARG "" "" "SOURCES;MOCKS" ${ARGN})
    add_executable(${TEST_NAME}
        ${ARG_SOURCES}
        ${ARG_MOCKS}
        ${unity_SOURCE_DIR}/src/unity.c
    )
    target_include_directories(${TEST_NAME} PRIVATE ${TEST_INCLUDE_DIRS})
    target_compile_options(${TEST_NAME} PRIVATE ${TEST_COMPILE_FLAGS})
    if(NOT "${TEST_LINK_FLAGS}" STREQUAL "")
        target_link_options(${TEST_NAME} PRIVATE ${TEST_LINK_FLAGS})
    endif()
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endmacro()

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