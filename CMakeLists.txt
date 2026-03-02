cmake_minimum_required(VERSION 3.22)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain-arm-none-eabi.cmake"
        CACHE STRING "ARM bare-metal toolchain"
    )
endif()

project(stm32-nucleo-cicd
    VERSION   1.0.0
    LANGUAGES C CXX ASM
)

set(CMAKE_C_STANDARD          11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD        17)

include(cmake/stm32f401re.cmake)

# Version runs for BOTH firmware and test builds
include(cmake/version.cmake)

# Host unit tests
if(NOT CMAKE_CROSSCOMPILING)
    enable_testing()
    add_subdirectory(tests)
    return()
endif()

add_compile_options(
    ${MCU_ARCH_FLAGS}
    -Wall
    -Wextra
    -Wshadow
    -Wdouble-promotion
    -Wformat=2
    -ffunction-sections
    -fdata-sections
    -fno-common
    $<$<CONFIG:Debug>:-g3>
    $<$<CONFIG:Debug>:-O0>
    $<$<CONFIG:Debug>:-DDEBUG=1>
    $<$<CONFIG:Release>:-O2>
    $<$<CONFIG:Release>:-DNDEBUG>
    $<$<CONFIG:RelWithDebInfo>:-O2>
    $<$<CONFIG:RelWithDebInfo>:-g1>
)

add_compile_definitions(${MCU_DEFINES})
add_link_options(${MCU_ARCH_FLAGS} ${MCU_LINKER_FLAGS})

file(GLOB HAL_SOURCES CONFIGURE_DEPENDS
    Drivers/STM32F4xx_HAL_Driver/Src/*.c
)

set(CORE_SOURCES
    Core/Src/main.c
    Core/Src/gpio.c
    Core/Src/tim.c
    Core/Src/usart.c
    Core/Src/system_stm32f4xx.c
    Core/Src/stm32f4xx_hal_msp.c
    Core/Src/stm32f4xx_it.c
    startup_stm32f401xe.s
)

set(APP_SOURCES
    app/Src/app.c
    app/Src/led_manager.c
    app/Src/uart_logger.c
    bsp/Src/bsp.c
)

add_executable(${PROJECT_NAME}
    ${CORE_SOURCES}
    ${APP_SOURCES}
    ${HAL_SOURCES}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    SUFFIX ".elf"
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${MCU_INCLUDE_DIRS}
    ${CMAKE_BINARY_DIR}/generated
    app/Inc
    bsp/Inc
)

set_source_files_properties(${HAL_SOURCES} PROPERTIES
    COMPILE_FLAGS "-w"
)

target_link_options(${PROJECT_NAME} PRIVATE
    -T${CMAKE_SOURCE_DIR}/STM32F401RETx_FLASH.ld
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex
            $<TARGET_FILE:${PROJECT_NAME}>
            ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:${PROJECT_NAME}>
            ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
    COMMENT "Generating .hex and .bin -- check memory usage above"
)

option(HIL_BUILD "Build HIL test firmware" OFF)

if(HIL_BUILD)
    add_executable(${PROJECT_NAME}-hil
        ${CORE_SOURCES}
        ${APP_SOURCES}
        ${HAL_SOURCES}
        app/Src/hil_protocol.c
    )
    set_target_properties(${PROJECT_NAME}-hil PROPERTIES SUFFIX ".elf")
    target_include_directories(${PROJECT_NAME}-hil PRIVATE
        ${MCU_INCLUDE_DIRS}
        ${CMAKE_BINARY_DIR}/generated
        app/Inc
        bsp/Inc
    )
    target_compile_definitions(${PROJECT_NAME}-hil PRIVATE HIL_TEST_MODE=1)
    set_source_files_properties(${HAL_SOURCES} PROPERTIES COMPILE_FLAGS "-w")
    target_link_options(${PROJECT_NAME}-hil PRIVATE
        ${MCU_ARCH_FLAGS}
        ${MCU_LINKER_FLAGS}
        -T${CMAKE_SOURCE_DIR}/STM32F401RETx_FLASH.ld
    )
    add_custom_command(TARGET ${PROJECT_NAME}-hil POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary
                $<TARGET_FILE:${PROJECT_NAME}-hil>
                ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-hil.bin
        COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}-hil>
        COMMENT "Generating HIL firmware .bin"
    )
endif()