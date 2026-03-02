#include "app.h"
#include "led_manager.h"
#include "uart_logger.h"
#include "bsp.h"
#include "version.h"
#include "version_git.h"

static uint32_t s_lastVoltageLogMs = 0U;
static uint32_t s_prngState        = 0x12345678UL;

static uint32_t NextRandom(void)
{
    /* xorshift32 PRNG */
    s_prngState ^= (s_prngState << 13);
    s_prngState ^= (s_prngState >> 17);
    s_prngState ^= (s_prngState << 5);
    return s_prngState;
}

static uint32_t GenerateVoltage(void)
{
    /* 230V +/-10% => [207..253] */
    uint32_t step = NextRandom() % 47U; /* 0..46 */
    return 207U + step;
}

void App_Init(void)
{
    LedManager_Init();
    UartLogger_Init();
    s_lastVoltageLogMs = BSP_GetTickMs();
    s_prngState ^= s_lastVoltageLogMs;
    UartLogger_Printf("FW: %s  built: %s %s\r\n",
                      FW_VERSION_FULL,
                      FW_BUILD_DATE,
                      FW_BUILD_TIME);
}

void App_Run(void)
{
    uint32_t now = BSP_GetTickMs();

    LedManager_Update();
    if ((now - s_lastVoltageLogMs) >= 1000U)
    {
        s_lastVoltageLogMs = now;
        UartLogger_Printf("Voltage: %lu V\r\n", (unsigned long)GenerateVoltage());
    }
}