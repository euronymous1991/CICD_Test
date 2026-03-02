#include "led_manager.h"
#include "bsp.h"

static uint32_t s_lastToggleMs = 0U;
static uint8_t  s_ledState     = 0U;

void LedManager_Init(void)
{
    s_lastToggleMs = BSP_GetTickMs();
    s_ledState     = 0U;
    BSP_LED_Write(0U, 0U);
}

void LedManager_Update(void)
{
    uint32_t now = BSP_GetTickMs();
    if ((now - s_lastToggleMs) >= 500U)
    {
        s_lastToggleMs = now;
        s_ledState     = (s_ledState == 0U) ? 1U : 0U;
        BSP_LED_Write(0U, s_ledState);
    }
}