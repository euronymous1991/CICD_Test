#ifndef MOCK_BSP_H
#define MOCK_BSP_H

#include <stdint.h>

void        MockBSP_Reset(void);
void        MockBSP_SetTick(uint32_t tickMs);
uint32_t    MockBSP_GetLedWriteCallCount(void);
uint8_t     MockBSP_GetLastLedId(void);
uint8_t     MockBSP_GetLastLedState(void);
const char *MockBSP_GetLastUartMsg(void);

#endif /* MOCK_BSP_H */
