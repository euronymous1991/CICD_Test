#include "app.h"
#include "led_manager.h"
#include "uart_logger.h"

void App_Init(void)
{
    LedManager_Init();
    UartLogger_Init();
    UartLogger_Print("App initialised\r\n");
}

void App_Run(void)
{
    LedManager_Update();
}
