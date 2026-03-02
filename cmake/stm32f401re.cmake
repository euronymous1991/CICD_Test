# cmake/stm32f401re.cmake
# MCU-specific flags for STM32F401RE (Nucleo-F401RE)
#
# Uses plain variables instead of generator expressions for build-type
# flags. Generator expressions with > inside $<...> break on Windows
# because cmd.exe treats > as output redirection.

# -- CPU / FPU architecture flags -------------------------------------------
set(MCU_ARCH_FLAGS
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
)

# Alias so both MCU_FLAGS and MCU_ARCH_FLAGS work in CMakeLists.txt
set(MCU_FLAGS ${MCU_ARCH_FLAGS})

# -- Preprocessor defines ---------------------------------------------------
set(MCU_DEFINES
    USE_HAL_DRIVER
    STM32F401xE
)

# -- Include directories ----------------------------------------------------
set(MCU_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/Core/Inc
    ${CMAKE_SOURCE_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc
    ${CMAKE_SOURCE_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy
    ${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F4xx/Include
    ${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Include
)

# -- Linker flags -----------------------------------------------------------
# NOTE: The linker script (-T flag) is set per-target in CMakeLists.txt
# via target_link_options so it does not end up here.
set(MCU_LINKER_FLAGS
    -Wl,--gc-sections
    -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map,--cref
    --specs=nano.specs
    --specs=nosys.specs
)
