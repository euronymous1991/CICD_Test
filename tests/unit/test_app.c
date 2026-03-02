#include "unity.h"

#include "app.h"
#include "mock_bsp.h"

#include <stdio.h>

static int ParseVoltage(const char *msg)
{
    int value = -1;
    if (msg == NULL)
    {
        return -1;
    }

    if (sscanf(msg, "Voltage: %d V", &value) != 1)
    {
        return -1;
    }

    return value;
}

void setUp(void)
{
    MockBSP_Reset();
}

void tearDown(void)
{
}

void test_App_Run_DoesNotLogVoltageBefore1000ms(void)
{
    uint32_t baseCalls;

    MockBSP_SetTick(0U);
    App_Init();
    baseCalls = MockBSP_UART_PrintCallCount();

    MockBSP_SetTick(999U);
    App_Run();

    TEST_ASSERT_EQUAL_UINT32(baseCalls, MockBSP_UART_PrintCallCount());
}

void test_App_Run_LogsVoltageAt1000ms(void)
{
    uint32_t baseCalls;
    int voltage;

    MockBSP_SetTick(0U);
    App_Init();
    baseCalls = MockBSP_UART_PrintCallCount();

    MockBSP_SetTick(1000U);
    App_Run();

    TEST_ASSERT_EQUAL_UINT32(baseCalls + 1U, MockBSP_UART_PrintCallCount());
    voltage = ParseVoltage(MockBSP_UART_LastMsg());
    TEST_ASSERT_GREATER_OR_EQUAL_INT(207, voltage);
    TEST_ASSERT_LESS_OR_EQUAL_INT(253, voltage);
}

void test_App_Run_LoggedVoltageAlwaysWithinRange(void)
{
    uint32_t tickMs = 0U;
    int      voltage;
    uint32_t i;

    MockBSP_SetTick(0U);
    App_Init();

    for (i = 0U; i < 20U; i++)
    {
        tickMs += 1000U;
        MockBSP_SetTick(tickMs);
        App_Run();

        voltage = ParseVoltage(MockBSP_UART_LastMsg());
        TEST_ASSERT_GREATER_OR_EQUAL_INT(207, voltage);
        TEST_ASSERT_LESS_OR_EQUAL_INT(253, voltage);
    }
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_App_Run_DoesNotLogVoltageBefore1000ms);
    RUN_TEST(test_App_Run_LogsVoltageAt1000ms);
    RUN_TEST(test_App_Run_LoggedVoltageAlwaysWithinRange);

    return UNITY_END();
}
