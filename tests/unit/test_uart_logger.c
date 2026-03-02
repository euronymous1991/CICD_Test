#include "unity.h"

#include "uart_logger.h"
#include "mock_bsp.h"

void setUp(void)
{
    MockBSP_Reset();
}

void tearDown(void)
{
}

void test_UartLogger_Print_NullMessage_DoesNothing(void)
{
    UartLogger_Print(NULL);
    TEST_ASSERT_EQUAL_STRING("", MockBSP_GetLastUartMsg());
}

void test_UartLogger_Print_ForwardsMessageToBSP(void)
{
    UartLogger_Print("hello");
    TEST_ASSERT_EQUAL_STRING("hello", MockBSP_GetLastUartMsg());
}

void test_UartLogger_Printf_FormatsMessage(void)
{
    UartLogger_Printf("v%d.%d.%d", 1, 2, 3);
    TEST_ASSERT_EQUAL_STRING("v1.2.3", MockBSP_GetLastUartMsg());
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_UartLogger_Print_NullMessage_DoesNothing);
    RUN_TEST(test_UartLogger_Print_ForwardsMessageToBSP);
    RUN_TEST(test_UartLogger_Printf_FormatsMessage);

    return UNITY_END();
}
