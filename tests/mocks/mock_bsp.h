#ifndef MOCK_BSP_H
#define MOCK_BSP_H

#include <stdint.h>

void     MockBSP_Reset(void);
void     MockBSP_SetTick(uint32_t ms);
void     MockBSP_AdvanceTick(uint32_t ms);
void     MockBSP_SetButton(uint8_t v);
uint8_t  MockBSP_LED_LastState(uint8_t id);
char    *MockBSP_UART_LastMsg(void);
uint32_t MockBSP_UART_PrintCallCount(void);

#endif /* MOCK_BSP_H */
