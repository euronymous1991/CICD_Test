#include "bsp.h"
#include <string.h>

static uint8_t  s_ledState[8]      = {0};
static uint32_t s_tickMs           = 0U;
static uint8_t  s_buttonPressed    = 0U;
static char     s_lastUartMsg[256] = {0};
static uint32_t s_uartPrintCalls   = 0U;

void    MockBSP_Reset       (void)        { memset(s_ledState, 0, sizeof(s_ledState)); memset(s_lastUartMsg, 0, sizeof(s_lastUartMsg)); s_tickMs = 0U; s_buttonPressed = 0U; s_uartPrintCalls = 0U; }
void    MockBSP_SetTick     (uint32_t ms) { s_tickMs = ms; }
void    MockBSP_AdvanceTick (uint32_t ms) { s_tickMs += ms; }
void    MockBSP_SetButton   (uint8_t v)   { s_buttonPressed = v; }
uint8_t MockBSP_LED_LastState(uint8_t id) { return s_ledState[id]; }
char   *MockBSP_UART_LastMsg(void)        { return s_lastUartMsg; }
uint32_t MockBSP_UART_PrintCallCount(void){ return s_uartPrintCalls; }

void     BSP_Init      (void)                      { }
void     BSP_LED_Write (uint8_t id, uint8_t state) { s_ledState[id] = state; }
uint8_t  BSP_LED_Read  (uint8_t id)                { return s_ledState[id]; }
uint32_t BSP_GetTickMs (void)                      { return s_tickMs; }
void     BSP_DelayMs   (uint32_t ms)               { s_tickMs += ms; }
uint8_t  BSP_Button_Read(void)                     { return s_buttonPressed; }

void BSP_UART_Print(const char *msg)
{
    s_uartPrintCalls++;
    if (msg != NULL) { strncpy(s_lastUartMsg, msg, sizeof(s_lastUartMsg) - 1U); }
}

void BSP_UART_Transmit(const uint8_t *data, uint16_t len)
{
    s_uartPrintCalls++;
    if (data != NULL && len < (uint16_t)sizeof(s_lastUartMsg))
    {
        memcpy(s_lastUartMsg, data, len);
    }
}
