#include "app.h"
#include "led_manager.h"
#include "uart_logger.h"
#include "version.h"
#include "version_git.h"

void App_Init(void)
{
    LedManager_Init();
    UartLogger_Init();
    UartLogger_Printf("FW: %s  built: %s %s\r\n",
                      FW_VERSION_FULL,
                      FW_BUILD_DATE,
                      FW_BUILD_TIME);   // ← semicolon here
}

void App_Run(void)
{
    LedManager_Update();
}
