#include "unity.h"
#include "uart_logger.h"
#include "bsp.h"
#include <string.h>

void MockBSP_Reset(void);
char *MockBSP_UART_LastMsg(void);

void setUp(void)    { MockBSP_Reset(); UartLogger_Init(); }
void tearDown(void) { }

void test_UartLogger_Print_TransmitsData(void)
{
    UartLogger_Print("hello\r\n");
    TEST_ASSERT_EQUAL_STRING("hello\r\n", MockBSP_UART_LastMsg());
}

void test_UartLogger_Printf_FormatsCorrectly(void)
{
    UartLogger_Printf("val=%d\r\n", 42);
    TEST_ASSERT_EQUAL_STRING("val=42\r\n", MockBSP_UART_LastMsg());
}

void test_UartLogger_NullPointer_DoesNotCrash(void)
{
    UartLogger_Print(NULL);
    TEST_PASS();
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_UartLogger_Print_TransmitsData);
    RUN_TEST(test_UartLogger_Printf_FormatsCorrectly);
    RUN_TEST(test_UartLogger_NullPointer_DoesNotCrash);
    return UNITY_END();
}