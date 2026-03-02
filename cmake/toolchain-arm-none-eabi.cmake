# cmake/toolchain-arm-none-eabi.cmake
 
# Declare bare-metal ARM target
set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
 
# ARM cross-compiler executables (must be on system PATH)
set(CMAKE_C_COMPILER       arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER     arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER     arm-none-eabi-gcc)
set(CMAKE_OBJCOPY          arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP          arm-none-eabi-objdump)
set(CMAKE_SIZE             arm-none-eabi-size)
 
# CRITICAL: Prevent CMake from testing the compiler with a host executable.
# On bare-metal, linking to run an executable on the host will always fail.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
 
# Restrict library/include search to the ARM sysroot, not the host system.
# This prevents accidentally linking host libraries into firmware.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
