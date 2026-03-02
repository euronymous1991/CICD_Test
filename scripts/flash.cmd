@echo off
setlocal EnableExtensions

rem scripts\flash.cmd
rem Flash firmware to NUCLEO-F401RE via OpenOCD + ST-Link (Windows cmd)

set "BINARY=%~1"
if "%BINARY%"=="" set "BINARY=build/stm32-nucleo-cicd.bin"
set "BINARY=%BINARY:\=/%"
set "FLASH_ADDR=0x08000000"
set "SWD_KHZ=%SWD_KHZ%"
if "%SWD_KHZ%"=="" set "SWD_KHZ=1000"

if not exist "%BINARY%" (
    echo ERROR: Binary not found: %BINARY%
    echo   Build first: cmake --build build
    exit /b 1
)

where openocd >nul 2>nul
if errorlevel 1 (
    echo ERROR: openocd not found in PATH.
    echo   Install OpenOCD and ensure "openocd" is available in cmd.
    exit /b 1
)

echo ==^> Flashing: %BINARY%
echo ==^> Target  : STM32F401RE @ %FLASH_ADDR%
echo ==^> SWD     : %SWD_KHZ% kHz (connect-under-reset)

openocd ^
  -f interface/stlink.cfg ^
  -f target/stm32f4x.cfg ^
  -c "transport select hla_swd" ^
  -c "adapter speed %SWD_KHZ%" ^
  -c "reset_config srst_only srst_nogate connect_assert_srst" ^
  -c "init" ^
  -c "reset halt" ^
  -c "program %BINARY% verify %FLASH_ADDR%" ^
  -c "reset run" ^
  -c "shutdown"
if errorlevel 1 exit /b 1

echo ==^> Flash complete. Device is running.
exit /b 0
