#include "bsp.h"
#include "mock_bsp.h"

#include <string.h>

static uint32_t s_tickMs;
static uint32_t s_ledWriteCalls;
static uint8_t  s_lastLedId;
static uint8_t  s_lastLedState;
static char     s_lastUartMsg[256];

void MockBSP_Reset(void)
{
    s_tickMs = 0U;
    s_ledWriteCalls = 0U;
    s_lastLedId = 0U;
    s_lastLedState = 0U;
    s_lastUartMsg[0] = '\0';
}

void MockBSP_SetTick(uint32_t tickMs)
{
    s_tickMs = tickMs;
}

uint32_t MockBSP_GetLedWriteCallCount(void)
{
    return s_ledWriteCalls;
}

uint8_t MockBSP_GetLastLedId(void)
{
    return s_lastLedId;
}

uint8_t MockBSP_GetLastLedState(void)
{
    return s_lastLedState;
}

const char *MockBSP_GetLastUartMsg(void)
{
    return s_lastUartMsg;
}

void BSP_Init(void)
{
}

void BSP_LED_Write(uint8_t ledId, uint8_t state)
{
    s_ledWriteCalls++;
    s_lastLedId = ledId;
    s_lastLedState = state;
}

uint8_t BSP_LED_Read(uint8_t ledId)
{
    (void)ledId;
    return s_lastLedState;
}

uint32_t BSP_GetTickMs(void)
{
    return s_tickMs;
}

uint32_t BSP_GetTim2Ticks(void)
{
    return 0U;
}

void BSP_DelayMs(uint32_t ms)
{
    s_tickMs += ms;
}

void BSP_UART_Print(const char *msg)
{
    if (msg == NULL)
    {
        return;
    }

    (void)strncpy(s_lastUartMsg, msg, sizeof(s_lastUartMsg) - 1U);
    s_lastUartMsg[sizeof(s_lastUartMsg) - 1U] = '\0';
}

void BSP_UART_Transmit(const uint8_t *data, uint16_t len)
{
    size_t copyLen;

    if (data == NULL)
    {
        return;
    }

    copyLen = (size_t)len;
    if (copyLen > (sizeof(s_lastUartMsg) - 1U))
    {
        copyLen = sizeof(s_lastUartMsg) - 1U;
    }

    (void)memcpy(s_lastUartMsg, data, copyLen);
    s_lastUartMsg[copyLen] = '\0';
}

uint8_t BSP_Button_Read(void)
{
    return 0U;
}
