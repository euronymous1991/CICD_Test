@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  STM32 Nucleo CI/CD - Project Structure Creator
::  Creates the full folder and file structure for the guide.
::  Run from the folder WHERE you want the project created.
::  A new folder "stm32-nucleo-cicd" will be created here.
:: ============================================================

set PROJECT=stm32-nucleo-cicd

echo.
echo ============================================================
echo   STM32 Nucleo CI/CD - Project Structure Creator
echo ============================================================
echo.
echo   This will create: %CD%\%PROJECT%\
echo.
set /p CONFIRM=   Continue? (Y/N): 
if /i "!CONFIRM!" neq "Y" ( echo Cancelled. & pause & exit /b 0 )
echo.

:: ── Check project folder doesn't already exist ───────────────
if exist "%PROJECT%" (
    echo [ERROR] Folder already exists: %CD%\%PROJECT%
    echo         Delete it first or run this script from a different location.
    pause
    exit /b 1
)

:: ============================================================
echo [1/9] Creating folder structure...
:: ============================================================

mkdir "%PROJECT%"
mkdir "%PROJECT%\.github\workflows"
mkdir "%PROJECT%\app\Inc"
mkdir "%PROJECT%\app\Src"
mkdir "%PROJECT%\bsp\Inc"
mkdir "%PROJECT%\bsp\Src"
mkdir "%PROJECT%\core\Inc"
mkdir "%PROJECT%\core\Src"
mkdir "%PROJECT%\drivers\CMSIS\Device\ST\STM32F4xx\Include"
mkdir "%PROJECT%\drivers\CMSIS\Include"
mkdir "%PROJECT%\drivers\STM32F4xx_HAL_Driver\Inc"
mkdir "%PROJECT%\drivers\STM32F4xx_HAL_Driver\Src"
mkdir "%PROJECT%\tests\mocks"
mkdir "%PROJECT%\tests\unit"
mkdir "%PROJECT%\scripts"
mkdir "%PROJECT%\cmake"

echo [ OK ] Folders created.
echo.

:: ============================================================
echo [2/9] Creating CI/CD workflow placeholder...
:: ============================================================

(
echo # .github/workflows/build.yml
echo # CI/CD Pipeline — created in Step 3 of the guide
echo # Replace this file with the complete build.yml from Step 3.
echo name: Embedded CI
echo on:
echo   push:
echo     branches: [ main, develop ]
echo   pull_request:
echo     branches: [ main, develop ]
echo jobs:
echo   placeholder:
echo     runs-on: ubuntu-22.04
echo     steps:
echo       - uses: actions/checkout@v4
echo       - run: echo "Replace this with the full pipeline from Step 3"
) > "%PROJECT%\.github\workflows\build.yml"

echo [ OK ] .github/workflows/build.yml

:: ============================================================
echo [3/9] Creating app/ source files...
:: ============================================================

:: app/Inc/app.h
(
echo #ifndef APP_H
echo #define APP_H
echo.
echo /**
echo  * @file  app.h
echo  * @brief Main application interface
echo  *        Called from main.c USER CODE blocks.
echo  */
echo.
echo void App_Init^(void^);
echo void App_Run^(void^);
echo.
echo #endif /* APP_H */
) > "%PROJECT%\app\Inc\app.h"

:: app/Inc/led_manager.h
(
echo #ifndef LED_MANAGER_H
echo #define LED_MANAGER_H
echo.
echo #include ^<stdint.h^>
echo #include ^<stdbool.h^>
echo.
echo typedef enum {
echo     LED_GREEN = 0U,
echo     LED_COUNT
echo } LedId_t;
echo.
echo typedef enum {
echo     LED_OFF = 0U,
echo     LED_ON  = 1U
echo } LedState_t;
echo.
echo void       LedManager_Init   ^(void^);
echo void       LedManager_Set    ^(LedId_t id, LedState_t state^);
echo void       LedManager_Toggle ^(LedId_t id^);
echo void       LedManager_Blink  ^(LedId_t id, uint32_t periodMs^);
echo LedState_t LedManager_GetState^(LedId_t id^);
echo void       LedManager_Update ^(void^);
echo.
echo #endif /* LED_MANAGER_H */
) > "%PROJECT%\app\Inc\led_manager.h"

:: app/Inc/uart_logger.h
(
echo #ifndef UART_LOGGER_H
echo #define UART_LOGGER_H
echo.
echo #include ^<stdint.h^>
echo.
echo void UartLogger_Init   ^(void^);
echo void UartLogger_Print  ^(const char *msg^);
echo void UartLogger_Printf ^(const char *fmt, ...^);
echo.
echo #endif /* UART_LOGGER_H */
) > "%PROJECT%\app\Inc\uart_logger.h"

:: app/Src/app.c
(
echo #include "app.h"
echo #include "led_manager.h"
echo #include "uart_logger.h"
echo.
echo void App_Init^(void^)
echo {
echo     LedManager_Init^(^);
echo     UartLogger_Init^(^);
echo     UartLogger_Print^("App initialised\r\n"^);
echo }
echo.
echo void App_Run^(void^)
echo {
echo     LedManager_Update^(^);
echo }
) > "%PROJECT%\app\Src\app.c"

:: app/Src/led_manager.c
(
echo #include "led_manager.h"
echo #include "bsp.h"
echo.
echo typedef struct {
echo     LedState_t state;
echo     bool       blinking;
echo     uint32_t   periodMs;
echo     uint32_t   lastToggleMs;
echo } LedContext_t;
echo.
echo static LedContext_t s_leds[LED_COUNT];
echo.
echo void LedManager_Init^(void^)
echo {
echo     for ^(uint8_t i = 0U; i ^< ^(uint8_t^)LED_COUNT; i++^)
echo     {
echo         s_leds[i].state        = LED_OFF;
echo         s_leds[i].blinking     = false;
echo         s_leds[i].periodMs     = 0U;
echo         s_leds[i].lastToggleMs = 0U;
echo         BSP_LED_Write^(i, 0U^);
echo     }
echo }
echo.
echo void LedManager_Set^(LedId_t id, LedState_t state^)
echo {
echo     if ^(id ^>= LED_COUNT^) { return; }
echo     s_leds[id].blinking = false;
echo     s_leds[id].state    = state;
echo     BSP_LED_Write^(^(uint8_t^)id, ^(uint8_t^)state^);
echo }
echo.
echo void LedManager_Toggle^(LedId_t id^)
echo {
echo     if ^(id ^>= LED_COUNT^) { return; }
echo     LedState_t next = ^(s_leds[id].state == LED_ON^) ? LED_OFF : LED_ON;
echo     LedManager_Set^(id, next^);
echo }
echo.
echo void LedManager_Blink^(LedId_t id, uint32_t periodMs^)
echo {
echo     if ^(id ^>= LED_COUNT^) { return; }
echo     s_leds[id].blinking     = true;
echo     s_leds[id].periodMs     = periodMs;
echo     s_leds[id].lastToggleMs = BSP_GetTickMs^(^);
echo }
echo.
echo LedState_t LedManager_GetState^(LedId_t id^)
echo {
echo     if ^(id ^>= LED_COUNT^) { return LED_OFF; }
echo     return s_leds[id].state;
echo }
echo.
echo void LedManager_Update^(void^)
echo {
echo     uint32_t now = BSP_GetTickMs^(^);
echo     for ^(uint8_t i = 0U; i ^< ^(uint8_t^)LED_COUNT; i++^)
echo     {
echo         if ^(!s_leds[i].blinking^) { continue; }
echo         if ^(^(now - s_leds[i].lastToggleMs^) ^>= ^(s_leds[i].periodMs / 2U^)^)
echo         {
echo             s_leds[i].lastToggleMs = now;
echo             LedState_t next = ^(s_leds[i].state == LED_ON^) ? LED_OFF : LED_ON;
echo             s_leds[i].state = next;
echo             BSP_LED_Write^(i, ^(uint8_t^)next^);
echo         }
echo     }
echo }
) > "%PROJECT%\app\Src\led_manager.c"

:: app/Src/uart_logger.c
(
echo #include "uart_logger.h"
echo #include "bsp.h"
echo #include ^<stdio.h^>
echo #include ^<stdarg.h^>
echo.
echo #define UART_LOGGER_BUF_SIZE 128U
echo.
echo void UartLogger_Init^(void^)
echo {
echo     /* BSP UART already initialised in BSP_Init */
echo }
echo.
echo void UartLogger_Print^(const char *msg^)
echo {
echo     if ^(msg == NULL^) { return; }
echo     BSP_UART_Print^(msg^);
echo }
echo.
echo void UartLogger_Printf^(const char *fmt, ...^)
echo {
echo     char    buf[UART_LOGGER_BUF_SIZE];
echo     va_list args;
echo     va_start^(args, fmt^);
echo     ^(void^)vsnprintf^(buf, sizeof^(buf^), fmt, args^);
echo     va_end^(args^);
echo     BSP_UART_Print^(buf^);
echo }
) > "%PROJECT%\app\Src\uart_logger.c"

echo [ OK ] app/ files created.

:: ============================================================
echo [4/9] Creating bsp/ files...
:: ============================================================

:: bsp/Inc/bsp.h
(
echo #ifndef BSP_H
echo #define BSP_H
echo.
echo /**
echo  * @file  bsp.h
echo  * @brief Board Support Package interface.
echo  *        This is the ONLY header that app/ code includes
echo  *        for any hardware interaction. All HAL calls are
echo  *        hidden behind this interface in bsp.c.
echo  */
echo.
echo #include ^<stdint.h^>
echo.
echo /* --- Initialisation --- */
echo void     BSP_Init^(void^);
echo.
echo /* --- LED --- */
echo void     BSP_LED_Write^(uint8_t ledId, uint8_t state^);
echo uint8_t  BSP_LED_Read ^(uint8_t ledId^);
echo.
echo /* --- Timing --- */
echo uint32_t BSP_GetTickMs^(void^);
echo void     BSP_DelayMs ^(uint32_t ms^);
echo.
echo /* --- UART --- */
echo void     BSP_UART_Print   ^(const char *msg^);
echo void     BSP_UART_Transmit^(const uint8_t *data, uint16_t len^);
echo.
echo /* --- Button --- */
echo uint8_t  BSP_Button_Read^(void^);
echo.
echo #endif /* BSP_H */
) > "%PROJECT%\bsp\Inc\bsp.h"

:: bsp/Src/bsp.c
(
echo #include "bsp.h"
echo.
echo /*
echo  * bsp.c — Board Support Package implementation
echo  *
echo  * ALL HAL calls live in this file ONLY.
echo  * app/ code never includes stm32f4xx_hal.h directly.
echo  *
echo  * Fill in the HAL calls after CubeMX generates main.c.
echo  * The extern handles below reference the MX_xxx_Init
echo  * generated globals.
echo  */
echo.
echo #ifndef UNIT_TEST
echo #include "main.h"          /* Generated by CubeMX — provides htim2, huart2 etc. */
echo #endif
echo.
echo #include ^<string.h^>
echo.
echo /* ── Internal state ────────────────────────────────────────────── */
echo static volatile uint32_t s_tickMs      = 0U;
echo static          uint8_t  s_uartRxByte  = 0U;
echo.
echo /* ── BSP_Init ───────────────────────────────────────────────────── */
echo void BSP_Init^(void^)
echo {
echo     /* Start TIM2 interrupt for 1ms tick */
echo #ifndef UNIT_TEST
echo     HAL_TIM_Base_Start_IT^(^&htim2^);
echo #endif
echo }
echo.
echo /* ── TIM2 callback — increments tick every 1ms ──────────────────── */
echo #ifndef UNIT_TEST
echo void HAL_TIM_PeriodElapsedCallback^(TIM_HandleTypeDef *htim^)
echo {
echo     if ^(htim-^>Instance == TIM2^)
echo     {
echo         s_tickMs++;
echo     }
echo }
echo #endif
echo.
echo /* ── LED ─────────────────────────────────────────────────────────── */
echo void BSP_LED_Write^(uint8_t ledId, uint8_t state^)
echo {
echo #ifndef UNIT_TEST
echo     ^(void^)ledId;  /* Only one LED on Nucleo: LD2 on PA5 */
echo     HAL_GPIO_WritePin^(LD2_GPIO_Port, LD2_Pin,
echo                       state ? GPIO_PIN_SET : GPIO_PIN_RESET^);
echo #endif
echo }
echo.
echo uint8_t BSP_LED_Read^(uint8_t ledId^)
echo {
echo #ifndef UNIT_TEST
echo     ^(void^)ledId;
echo     return ^(uint8_t^)HAL_GPIO_ReadPin^(LD2_GPIO_Port, LD2_Pin^);
echo #else
echo     return 0U;
echo #endif
echo }
echo.
echo /* ── Timing ──────────────────────────────────────────────────────── */
echo uint32_t BSP_GetTickMs^(void^)
echo {
echo     return s_tickMs;
echo }
echo.
echo void BSP_DelayMs^(uint32_t ms^)
echo {
echo #ifndef UNIT_TEST
echo     HAL_Delay^(ms^);
echo #else
echo     s_tickMs += ms;  /* Advance simulated tick in test builds */
echo #endif
echo }
echo.
echo /* ── UART ────────────────────────────────────────────────────────── */
echo void BSP_UART_Print^(const char *msg^)
echo {
echo #ifndef UNIT_TEST
echo     if ^(msg == NULL^) { return; }
echo     uint16_t len = ^(uint16_t^)strlen^(msg^);
echo     ^(void^)HAL_UART_Transmit^(^&huart2, ^(const uint8_t *^)msg, len, 100U^);
echo #endif
echo }
echo.
echo void BSP_UART_Transmit^(const uint8_t *data, uint16_t len^)
echo {
echo #ifndef UNIT_TEST
echo     ^(void^)HAL_UART_Transmit^(^&huart2, data, len, 100U^);
echo #endif
echo }
echo.
echo /* ── Button ──────────────────────────────────────────────────────── */
echo uint8_t BSP_Button_Read^(void^)
echo {
echo #ifndef UNIT_TEST
echo     return ^(uint8_t^)HAL_GPIO_ReadPin^(B1_GPIO_Port, B1_Pin^);
echo #else
echo     return 0U;
echo #endif
echo }
) > "%PROJECT%\bsp\Src\bsp.c"

echo [ OK ] bsp/ files created.

:: ============================================================
echo [5/9] Creating core/ placeholder files...
:: ============================================================

(
echo /* core/Inc/main.h — generated by CubeMX                           */
echo /* DO NOT EDIT MANUALLY. Regenerate via STM32CubeMX.               */
echo /* This placeholder will be replaced when you generate from CubeMX */
echo #ifndef MAIN_H
echo #define MAIN_H
echo #ifdef __cplusplus
echo extern "C" {
echo #endif
echo /* Add your pin defines here after CubeMX generation */
echo /* e.g. #define LD2_Pin GPIO_PIN_5                   */
echo /*      #define LD2_GPIO_Port GPIOA                  */
echo #ifdef __cplusplus
echo }
echo #endif
echo #endif /* MAIN_H */
) > "%PROJECT%\core\Inc\main.h"

(
echo /* core/Src/main.c — generated by CubeMX                           */
echo /* DO NOT EDIT MANUALLY outside of USER CODE blocks.               */
echo /* This placeholder will be replaced when you generate from CubeMX */
echo.
echo #include "main.h"
echo #include "app.h"
echo #include "bsp.h"
echo.
echo int main^(void^)
echo {
echo     /* USER CODE BEGIN 1 */
echo     /* USER CODE END 1 */
echo.
echo     /* MCU init — generated by CubeMX */
echo     /* HAL_Init^(^); SystemClock_Config^(^); MX_xxx_Init^(^); */
echo.
echo     /* USER CODE BEGIN 2 */
echo     BSP_Init^(^);
echo     App_Init^(^);
echo     /* USER CODE END 2 */
echo.
echo     while ^(1^)
echo     {
echo         /* USER CODE BEGIN WHILE */
echo         App_Run^(^);
echo         /* USER CODE END WHILE */
echo     }
echo }
) > "%PROJECT%\core\Src\main.c"

echo [ OK ] core/ placeholder files created.
echo        ^(Replace with CubeMX-generated files^)

:: ============================================================
echo [6/9] Creating tests/ files...
:: ============================================================

:: tests/CMakeLists.txt
(
echo # tests/CMakeLists.txt
echo # Unit test build — runs on host PC using GCC, NOT arm-none-eabi-gcc.
echo # Included only when CMAKE_CROSSCOMPILING is FALSE ^(no toolchain file passed^).
echo.
echo cmake_minimum_required^(VERSION 3.20^)
echo.
echo # Download Unity test framework
echo include^(FetchContent^)
echo FetchContent_Declare^(
echo     unity
echo     GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
echo     GIT_TAG        v2.6.0
echo     GIT_SHALLOW    TRUE
echo ^)
echo FetchContent_MakeAvailable^(unity^)
echo.
echo set^(TEST_INCLUDE_DIRS
echo     ${CMAKE_SOURCE_DIR}/app/Inc
echo     ${CMAKE_SOURCE_DIR}/bsp/Inc
echo     ${CMAKE_SOURCE_DIR}/tests/mocks
echo     ${unity_SOURCE_DIR}/src
echo ^)
echo.
echo set^(TEST_COMPILE_FLAGS
echo     -Wall -Wextra -DUNIT_TEST
echo     -fprofile-arcs -ftest-coverage
echo     -g -O0
echo ^)
echo.
echo # Macro to register a unit test executable
echo macro^(add_unit_test TEST_NAME^)
echo     cmake_parse_arguments^(ARG "" "" "SOURCES;MOCKS" ${ARGN}^)
echo     add_executable^(${TEST_NAME}
echo         ${ARG_SOURCES}
echo         ${ARG_MOCKS}
echo         ${unity_SOURCE_DIR}/src/unity.c
echo     ^)
echo     target_include_directories^(${TEST_NAME} PRIVATE ${TEST_INCLUDE_DIRS}^)
echo     target_compile_options^(${TEST_NAME} PRIVATE ${TEST_COMPILE_FLAGS}^)
echo     target_link_options^(${TEST_NAME} PRIVATE -fprofile-arcs -ftest-coverage^)
echo     add_test^(NAME ${TEST_NAME} COMMAND ${TEST_NAME}^)
echo endmacro^(^)
echo.
echo # Register test executables
echo add_unit_test^(test_led_manager
echo     SOURCES
echo         ${CMAKE_SOURCE_DIR}/tests/unit/test_led_manager.c
echo         ${CMAKE_SOURCE_DIR}/app/Src/led_manager.c
echo     MOCKS
echo         ${CMAKE_SOURCE_DIR}/tests/mocks/mock_bsp.c
echo ^)
echo.
echo add_unit_test^(test_uart_logger
echo     SOURCES
echo         ${CMAKE_SOURCE_DIR}/tests/unit/test_uart_logger.c
echo         ${CMAKE_SOURCE_DIR}/app/Src/uart_logger.c
echo     MOCKS
echo         ${CMAKE_SOURCE_DIR}/tests/mocks/mock_bsp.c
echo ^)
) > "%PROJECT%\tests\CMakeLists.txt"

:: tests/mocks/mock_bsp.c  (header inline below)
(
echo /* tests/mocks/mock_bsp.c
echo  * Mock BSP implementation for unit tests.
echo  * Replaces the real bsp.c — no HAL, no hardware.
echo  */
echo #include "bsp.h"
echo #include ^<string.h^>
echo.
echo static uint8_t  s_ledState[8]     = {0};
echo static uint32_t s_tickMs          = 0U;
echo static uint8_t  s_buttonPressed   = 0U;
echo static char     s_lastUartMsg[256] = {0};
echo.
echo /* ── Mock control functions (called from test setUp/tearDown) ───── */
echo void MockBSP_Reset^(void^)
echo {
echo     memset^(s_ledState, 0, sizeof^(s_ledState^)^);
echo     s_tickMs        = 0U;
echo     s_buttonPressed = 0U;
echo     memset^(s_lastUartMsg, 0, sizeof^(s_lastUartMsg^)^);
echo }
echo void     MockBSP_SetTick         ^(uint32_t ms^)   { s_tickMs = ms; }
echo void     MockBSP_AdvanceTick     ^(uint32_t ms^)   { s_tickMs += ms; }
echo void     MockBSP_SetButtonPressed^(uint8_t  v ^)   { s_buttonPressed = v; }
echo uint8_t  MockBSP_LED_LastState   ^(uint8_t  id^)   { return s_ledState[id]; }
echo char    *MockBSP_UART_LastMsg    ^(void^)           { return s_lastUartMsg; }
echo.
echo /* ── BSP interface implementations ─────────────────────────────── */
echo void     BSP_Init^(void^)                            { }
echo void     BSP_LED_Write^(uint8_t id, uint8_t state^) { s_ledState[id] = state; }
echo uint8_t  BSP_LED_Read ^(uint8_t id^)                { return s_ledState[id]; }
echo uint32_t BSP_GetTickMs^(void^)                      { return s_tickMs; }
echo void     BSP_DelayMs  ^(uint32_t ms^)               { s_tickMs += ms; }
echo uint8_t  BSP_Button_Read^(void^)                    { return s_buttonPressed; }
echo void     BSP_UART_Print^(const char *msg^)
echo {
echo     if ^(msg^) { strncpy^(s_lastUartMsg, msg, sizeof^(s_lastUartMsg^) - 1U^); }
echo }
echo void BSP_UART_Transmit^(const uint8_t *data, uint16_t len^)
echo {
echo     if ^(data ^&^& len ^< sizeof^(s_lastUartMsg^)^)
echo     {
echo         memcpy^(s_lastUartMsg, data, len^);
echo     }
echo }
) > "%PROJECT%\tests\mocks\mock_bsp.c"

:: tests/unit/test_led_manager.c
(
echo #include "unity.h"
echo #include "led_manager.h"
echo #include "bsp.h"
echo.
echo /* Declared in mock_bsp.c */
echo void    MockBSP_Reset^(void^);
echo void    MockBSP_SetTick^(uint32_t ms^);
echo void    MockBSP_AdvanceTick^(uint32_t ms^);
echo uint8_t MockBSP_LED_LastState^(uint8_t id^);
echo.
echo void setUp^(void^)    { MockBSP_Reset^(^); LedManager_Init^(^); }
echo void tearDown^(void^) { }
echo.
echo void test_LedManager_Init_SetsLedOff^(void^)
echo {
echo     TEST_ASSERT_EQUAL^(LED_OFF, LedManager_GetState^(LED_GREEN^)^);
echo     TEST_ASSERT_EQUAL^(0U, MockBSP_LED_LastState^(0U^)^);
echo }
echo.
echo void test_LedManager_Set_TurnsLedOn^(void^)
echo {
echo     LedManager_Set^(LED_GREEN, LED_ON^);
echo     TEST_ASSERT_EQUAL^(LED_ON, LedManager_GetState^(LED_GREEN^)^);
echo     TEST_ASSERT_EQUAL^(1U, MockBSP_LED_LastState^(0U^)^);
echo }
echo.
echo void test_LedManager_Set_TurnsLedOff^(void^)
echo {
echo     LedManager_Set^(LED_GREEN, LED_ON^);
echo     LedManager_Set^(LED_GREEN, LED_OFF^);
echo     TEST_ASSERT_EQUAL^(LED_OFF, LedManager_GetState^(LED_GREEN^)^);
echo }
echo.
echo void test_LedManager_Toggle_InvertsState^(void^)
echo {
echo     LedManager_Set^(LED_GREEN, LED_OFF^);
echo     LedManager_Toggle^(LED_GREEN^);
echo     TEST_ASSERT_EQUAL^(LED_ON, LedManager_GetState^(LED_GREEN^)^);
echo     LedManager_Toggle^(LED_GREEN^);
echo     TEST_ASSERT_EQUAL^(LED_OFF, LedManager_GetState^(LED_GREEN^)^);
echo }
echo.
echo void test_LedManager_Blink_TogglesAfterHalfPeriod^(void^)
echo {
echo     MockBSP_SetTick^(0U^);
echo     LedManager_Blink^(LED_GREEN, 500U^);
echo     MockBSP_SetTick^(249U^); LedManager_Update^(^);
echo     TEST_ASSERT_EQUAL^(LED_OFF, LedManager_GetState^(LED_GREEN^)^); /* not yet */
echo     MockBSP_SetTick^(250U^); LedManager_Update^(^);
echo     TEST_ASSERT_EQUAL^(LED_ON,  LedManager_GetState^(LED_GREEN^)^); /* toggled */
echo }
echo.
echo void test_LedManager_InvalidId_DoesNotCrash^(void^)
echo {
echo     LedManager_Set^(^(LedId_t^)99U, LED_ON^);  /* Should not crash */
echo     TEST_PASS^(^);
echo }
echo.
echo int main^(void^)
echo {
echo     UNITY_BEGIN^(^);
echo     RUN_TEST^(test_LedManager_Init_SetsLedOff^);
echo     RUN_TEST^(test_LedManager_Set_TurnsLedOn^);
echo     RUN_TEST^(test_LedManager_Set_TurnsLedOff^);
echo     RUN_TEST^(test_LedManager_Toggle_InvertsState^);
echo     RUN_TEST^(test_LedManager_Blink_TogglesAfterHalfPeriod^);
echo     RUN_TEST^(test_LedManager_InvalidId_DoesNotCrash^);
echo     return UNITY_END^(^);
echo }
) > "%PROJECT%\tests\unit\test_led_manager.c"

:: tests/unit/test_uart_logger.c
(
echo #include "unity.h"
echo #include "uart_logger.h"
echo #include "bsp.h"
echo #include ^<string.h^>
echo.
echo void MockBSP_Reset^(void^);
echo char *MockBSP_UART_LastMsg^(void^);
echo.
echo void setUp^(void^)    { MockBSP_Reset^(^); UartLogger_Init^(^); }
echo void tearDown^(void^) { }
echo.
echo void test_UartLogger_Print_TransmitsData^(void^)
echo {
echo     UartLogger_Print^("hello\r\n"^);
echo     TEST_ASSERT_EQUAL_STRING^("hello\r\n", MockBSP_UART_LastMsg^(^)^);
echo }
echo.
echo void test_UartLogger_Printf_FormatsCorrectly^(void^)
echo {
echo     UartLogger_Printf^("val=%d\r\n", 42^);
echo     TEST_ASSERT_EQUAL_STRING^("val=42\r\n", MockBSP_UART_LastMsg^(^)^);
echo }
echo.
echo void test_UartLogger_NullPointer_DoesNotCrash^(void^)
echo {
echo     UartLogger_Print^(NULL^);  /* Should not crash */
echo     TEST_PASS^(^);
echo }
echo.
echo int main^(void^)
echo {
echo     UNITY_BEGIN^(^);
echo     RUN_TEST^(test_UartLogger_Print_TransmitsData^);
echo     RUN_TEST^(test_UartLogger_Printf_FormatsCorrectly^);
echo     RUN_TEST^(test_UartLogger_NullPointer_DoesNotCrash^);
echo     return UNITY_END^(^);
echo }
) > "%PROJECT%\tests\unit\test_uart_logger.c"

echo [ OK ] tests/ files created.

:: ============================================================
echo [7/9] Creating cmake/ files...
:: ============================================================

:: cmake/toolchain-arm-none-eabi.cmake
(
echo # cmake/toolchain-arm-none-eabi.cmake
echo # ARM cross-compilation toolchain for STM32F4
echo.
echo set^(CMAKE_SYSTEM_NAME      Generic^)
echo set^(CMAKE_SYSTEM_PROCESSOR arm^)
echo.
echo # Prevent CMake from testing the compiler with a linked executable
echo set^(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY^)
echo.
echo # Toolchain binaries — must be on PATH
echo set^(CMAKE_C_COMPILER   arm-none-eabi-gcc^)
echo set^(CMAKE_CXX_COMPILER arm-none-eabi-g++^)
echo set^(CMAKE_ASM_COMPILER arm-none-eabi-gcc^)
echo set^(CMAKE_OBJCOPY      arm-none-eabi-objcopy^)
echo set^(CMAKE_OBJDUMP      arm-none-eabi-objdump^)
echo set^(CMAKE_SIZE         arm-none-eabi-size^)
echo.
echo # Export compile commands for clang-tidy
echo set^(CMAKE_EXPORT_COMPILE_COMMANDS ON^)
) > "%PROJECT%\cmake\toolchain-arm-none-eabi.cmake"

:: cmake/stm32f401re.cmake
(
echo # cmake/stm32f401re.cmake
echo # MCU-specific flags for STM32F401RE
echo.
echo set^(MCU_FLAGS
echo     -mcpu=cortex-m4
echo     -mthumb
echo     -mfpu=fpv4-sp-d16
echo     -mfloat-abi=hard
echo ^)
echo.
echo set^(MCU_DEFINES
echo     -DUSE_HAL_DRIVER
echo     -DSTM32F401xE
echo ^)
echo.
echo set^(MCU_INCLUDE_DIRS
echo     ${CMAKE_SOURCE_DIR}/core/Inc
echo     ${CMAKE_SOURCE_DIR}/drivers/STM32F4xx_HAL_Driver/Inc
echo     ${CMAKE_SOURCE_DIR}/drivers/STM32F4xx_HAL_Driver/Inc/Legacy
echo     ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F4xx/Include
echo     ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Include
echo ^)
echo.
echo set^(MCU_COMPILE_FLAGS
echo     ${MCU_FLAGS}
echo     ${MCU_DEFINES}
echo     -Wall -Wextra -Wpedantic
echo     -fdata-sections
echo     -ffunction-sections
echo     -fstack-usage
echo     --specs=nano.specs
echo ^)
echo.
echo set^(MCU_LINKER_FLAGS
echo     ${MCU_FLAGS}
echo     -Wl,--gc-sections
echo     -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map
echo     --specs=nano.specs
echo     --specs=nosys.specs
echo ^)
) > "%PROJECT%\cmake\stm32f401re.cmake"

echo [ OK ] cmake/ files created.

:: ============================================================
echo [8/9] Creating root CMakeLists.txt and config files...
:: ============================================================

:: Root CMakeLists.txt
(
echo cmake_minimum_required^(VERSION 3.20^)
echo project^(stm32-nucleo-cicd LANGUAGES C CXX ASM^)
echo.
echo set^(CMAKE_C_STANDARD   11^)
echo set^(CMAKE_C_EXTENSIONS OFF^)
echo.
echo # ── MCU configuration ────────────────────────────────────────────
echo include^(cmake/stm32f401re.cmake^)
echo.
echo # ── Host unit tests (when not cross-compiling) ───────────────────
echo if^(NOT CMAKE_CROSSCOMPILING^)
echo     enable_testing^(^)
echo     add_subdirectory^(tests^)
echo     return^(^)  # Stop here — no firmware build on host
echo endif^(^)
echo.
echo # ── Source files ─────────────────────────────────────────────────
echo file^(GLOB HAL_SOURCES
echo     drivers/STM32F4xx_HAL_Driver/Src/*.c
echo ^)
echo.
echo set^(CORE_SOURCES
echo     core/Src/main.c
echo     core/Src/stm32f4xx_hal_msp.c
echo     core/Src/stm32f4xx_it.c
echo     startup_stm32f401xe.s
echo ^)
echo.
echo set^(APP_SOURCES
echo     app/Src/app.c
echo     app/Src/led_manager.c
echo     app/Src/uart_logger.c
echo     bsp/Src/bsp.c
echo ^)
echo.
echo # ── Firmware target ──────────────────────────────────────────────
echo add_executable^(${PROJECT_NAME}
echo     ${CORE_SOURCES}
echo     ${APP_SOURCES}
echo     ${HAL_SOURCES}
echo ^)
echo.
echo target_include_directories^(${PROJECT_NAME} PRIVATE
echo     ${MCU_INCLUDE_DIRS}
echo     app/Inc
echo     bsp/Inc
echo ^)
echo.
echo target_compile_options^(${PROJECT_NAME} PRIVATE
echo     ${MCU_COMPILE_FLAGS}
echo ^)
echo.
echo target_link_options^(${PROJECT_NAME} PRIVATE
echo     ${MCU_LINKER_FLAGS}
echo     -T${CMAKE_SOURCE_DIR}/STM32F401RETx_FLASH.ld
echo ^)
echo.
echo # ── Post-build: generate .bin and .hex ───────────────────────────
echo add_custom_command^(TARGET ${PROJECT_NAME} POST_BUILD
echo     COMMAND ${CMAKE_OBJCOPY} -O binary
echo             $^<TARGET_FILE:${PROJECT_NAME}^>
echo             ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.bin
echo     COMMAND ${CMAKE_OBJCOPY} -O ihex
echo             $^<TARGET_FILE:${PROJECT_NAME}^>
echo             ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.hex
echo     COMMAND ${CMAKE_SIZE} $^<TARGET_FILE:${PROJECT_NAME}^>
echo     COMMENT "Generating .bin and .hex"
echo ^)
echo.
echo # ── HIL test firmware ^(optional^) ───────────────────────────────
echo option^(HIL_BUILD "Build HIL test firmware" OFF^)
echo if^(HIL_BUILD^)
echo     add_executable^(${PROJECT_NAME}-hil
echo         ${CORE_SOURCES}
echo         ${APP_SOURCES}
echo         ${HAL_SOURCES}
echo         app/Src/hil_protocol.c
echo     ^)
echo     target_include_directories^(${PROJECT_NAME}-hil PRIVATE
echo         ${MCU_INCLUDE_DIRS} app/Inc bsp/Inc
echo     ^)
echo     target_compile_definitions^(${PROJECT_NAME}-hil PRIVATE HIL_TEST_MODE=1^)
echo     target_compile_options^(${PROJECT_NAME}-hil PRIVATE ${MCU_COMPILE_FLAGS}^)
echo     target_link_options^(${PROJECT_NAME}-hil PRIVATE
echo         ${MCU_LINKER_FLAGS} -T${CMAKE_SOURCE_DIR}/STM32F401RETx_FLASH.ld
echo     ^)
echo     add_custom_command^(TARGET ${PROJECT_NAME}-hil POST_BUILD
echo         COMMAND ${CMAKE_OBJCOPY} -O binary
echo                 $^<TARGET_FILE:${PROJECT_NAME}-hil^>
echo                 ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-hil.bin
echo         COMMENT "Generating HIL firmware .bin"
echo     ^)
echo endif^(^)
) > "%PROJECT%\CMakeLists.txt"

:: .clang-format
(
echo ---
echo BasedOnStyle:    Google
echo Language:        Cpp
echo IndentWidth:     4
echo TabWidth:        4
echo UseTab:          Never
echo ColumnLimit:     100
echo BreakBeforeBraces: Allman
echo AllowShortFunctionsOnASingleLine:  None
echo AllowShortIfStatementsOnASingleLine: Never
echo AllowShortLoopsOnASingleLine: false
echo AlignConsecutiveAssignments: Consecutive
echo AlignConsecutiveMacros:      Consecutive
echo AlignConsecutiveBitFields:   Consecutive
echo AlignTrailingComments:
echo   Kind: Always
echo PointerAlignment: Right
echo SortIncludes: CaseSensitive
echo ...
) > "%PROJECT%\.clang-format"

:: .clang-tidy
(
echo ---
echo Checks: ^>
echo   -*,
echo   bugprone-*,
echo   cert-*,
echo   clang-analyzer-*,
echo   misc-*,
echo   performance-*,
echo   portability-*,
echo   readability-braces-around-statements,
echo   readability-function-cognitive-complexity,
echo   -bugprone-easily-swappable-parameters,
echo   -misc-include-cleaner
echo WarningsAsErrors: ^>
echo   bugprone-*,
echo   clang-analyzer-*
echo CheckOptions:
echo   - key:   readability-function-cognitive-complexity.Threshold
echo     value: '20'
echo ...
) > "%PROJECT%\.clang-tidy"

:: .gitignore
(
echo # Build directories
echo build*/
echo.
echo # CMake generated
echo CMakeCache.txt
echo CMakeFiles/
echo cmake_install.cmake
echo Makefile
echo.
echo # Firmware artifacts
echo *.elf
echo *.bin
echo *.hex
echo *.map
echo *.su
echo.
echo # Coverage
echo *.gcda
echo *.gcno
echo coverage.info
echo coverage/
echo.
echo # Python
echo __pycache__/
echo *.pyc
echo .pytest_cache/
echo.
echo # VS Code
echo .vscode/
echo.
echo # CubeMX backup files
echo *.bak
) > "%PROJECT%\.gitignore"

:: README.md
(
echo # stm32-nucleo-cicd
echo.
echo STM32F401RE Nucleo — Professional Embedded Development Guide
echo.
echo ## Quick Start
echo.
echo ### Prerequisites
echo - ARM GNU Toolchain 15.2 on PATH
echo - CMake 3.20+, Ninja
echo - Python 3.x with pyserial and pytest
echo - OpenOCD
echo - clang-format, clang-tidy ^(LLVM^)
echo - cppcheck
echo.
echo ### Build Firmware
echo ```
echo cmake -S . -B build_debug -G Ninja -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-arm-none-eabi.cmake -DCMAKE_BUILD_TYPE=Debug
echo cmake --build build_debug
echo ```
echo.
echo ### Run Unit Tests
echo ```
echo cmake -S . -B build_test -G Ninja -DCMAKE_BUILD_TYPE=Debug
echo cmake --build build_test
echo ctest --test-dir build_test --output-on-failure
echo ```
echo.
echo ### Flash to Board
echo ```
echo openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program build_debug/stm32-nucleo-cicd.bin verify reset exit 0x08000000"
echo ```
echo.
echo ## Guide
echo See the full 5-step guide documents for detailed instructions.
) > "%PROJECT%\README.md"

echo [ OK ] Root files created.

:: ============================================================
echo [9/9] Creating scripts/ placeholder files...
:: ============================================================

(
echo #!/bin/bash
echo # flash.sh — Flash firmware via OpenOCD
echo # Usage: ./scripts/flash.sh [build_dir]
echo BUILD=${1:-build_debug}
echo openocd -f interface/stlink.cfg \
echo         -f target/stm32f4x.cfg \
echo         -c "program ${BUILD}/stm32-nucleo-cicd.bin verify reset exit 0x08000000"
) > "%PROJECT%\scripts\flash.sh"

(
echo #!/bin/bash
echo # debug.sh — Start GDB debug session via OpenOCD
echo BUILD=${1:-build_debug}
echo # Terminal 1: openocd -f interface/stlink.cfg -f target/stm32f4x.cfg
echo # Terminal 2: this script
echo arm-none-eabi-gdb ${BUILD}/stm32-nucleo-cicd.elf \
echo     -ex "target remote :3333" \
echo     -ex "monitor reset halt" \
echo     -ex "load" \
echo     -ex "monitor reset init"
) > "%PROJECT%\scripts\debug.sh"

(
echo #!/usr/bin/env python3
echo """
echo hil_test.py -- HIL test runner placeholder
echo See Step 4 of the guide for the full implementation.
echo """
echo print^("HIL test runner -- see Step 4 of the guide"^)
) > "%PROJECT%\scripts\hil_test.py"

:: Placeholder linker script note
(
echo /* STM32F401RETx_FLASH.ld
echo  * Linker script — generated by CubeMX.
echo  * Replace this file with the one generated by STM32CubeMX
echo  * when you create your project.
echo  */
) > "%PROJECT%\STM32F401RETx_FLASH.ld"

:: Placeholder startup file note
(
echo /* startup_stm32f401xe.s
echo  * Assembly startup file — generated by CubeMX.
echo  * Replace this file with the one generated by STM32CubeMX.
echo  */
) > "%PROJECT%\startup_stm32f401xe.s"

:: Empty .ioc placeholder
echo ; STM32CubeMX project file — open in CubeMX to configure peripherals > "%PROJECT%\stm32-nucleo-cicd.ioc"

echo [ OK ] scripts/ and root placeholders created.

:: ============================================================
echo.
echo ============================================================
echo   Project structure created successfully!
echo ============================================================
echo.
echo   Location: %CD%\%PROJECT%\
echo.
echo   Files ready to edit immediately:
echo     app/Src/led_manager.c      - LED logic
echo     app/Src/uart_logger.c      - UART logging
echo     bsp/Src/bsp.c              - Fill in HAL calls after CubeMX
echo     CMakeLists.txt             - Root build file
echo     tests/unit/*.c             - Unit tests
echo.
echo   Files to replace with CubeMX output:
echo     core/Src/main.c            - After CubeMX generation
echo     core/Inc/main.h            - After CubeMX generation
echo     STM32F401RETx_FLASH.ld     - After CubeMX generation
echo     startup_stm32f401xe.s      - After CubeMX generation
echo     drivers/                   - Copy HAL+CMSIS from CubeMX output
echo.
echo   Next steps:
echo     1. cd %PROJECT%
echo     2. git init ^&^& git add . ^&^& git commit -m "Initial structure"
echo     3. Generate project in CubeMX and copy generated files
echo     4. cmake -S . -B build_debug -G Ninja
echo            -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-arm-none-eabi.cmake
echo            -DCMAKE_BUILD_TYPE=Debug
echo     5. cmake --build build_debug
echo ============================================================
echo.
pause
exit /b 0
