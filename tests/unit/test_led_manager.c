#include "unity.h"

#include "led_manager.h"
#include "mock_bsp.h"

void setUp(void)
{
    MockBSP_Reset();
}

void tearDown(void)
{
}

void test_LedManager_Init_TurnsLedOff(void)
{
    MockBSP_SetTick(123U);
    LedManager_Init();

    TEST_ASSERT_EQUAL_UINT32(1U, MockBSP_GetLedWriteCallCount());
    TEST_ASSERT_EQUAL_UINT8(0U, MockBSP_GetLastLedId());
    TEST_ASSERT_EQUAL_UINT8(0U, MockBSP_GetLastLedState());
}

void test_LedManager_Update_DoesNotToggleBeforePeriod(void)
{
    MockBSP_SetTick(0U);
    LedManager_Init();

    MockBSP_SetTick(499U);
    LedManager_Update();

    TEST_ASSERT_EQUAL_UINT32(1U, MockBSP_GetLedWriteCallCount());
    TEST_ASSERT_EQUAL_UINT8(0U, MockBSP_GetLastLedState());
}

void test_LedManager_Update_TogglesAt500ms(void)
{
    MockBSP_SetTick(0U);
    LedManager_Init();

    MockBSP_SetTick(500U);
    LedManager_Update();

    TEST_ASSERT_EQUAL_UINT32(2U, MockBSP_GetLedWriteCallCount());
    TEST_ASSERT_EQUAL_UINT8(1U, MockBSP_GetLastLedState());
}

void test_LedManager_Update_TogglesBackAt1000ms(void)
{
    MockBSP_SetTick(0U);
    LedManager_Init();

    MockBSP_SetTick(500U);
    LedManager_Update();
    MockBSP_SetTick(1000U);
    LedManager_Update();

    TEST_ASSERT_EQUAL_UINT32(3U, MockBSP_GetLedWriteCallCount());
    TEST_ASSERT_EQUAL_UINT8(0U, MockBSP_GetLastLedState());
}

void test_LedManager_Update_HandlesTickWraparound(void)
{
    MockBSP_SetTick(0xFFFFFFF0U);
    LedManager_Init();

    MockBSP_SetTick(600U);
    LedManager_Update();

    TEST_ASSERT_EQUAL_UINT32(2U, MockBSP_GetLedWriteCallCount());
    TEST_ASSERT_EQUAL_UINT8(1U, MockBSP_GetLastLedState());
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_LedManager_Init_TurnsLedOff);
    RUN_TEST(test_LedManager_Update_DoesNotToggleBeforePeriod);
    RUN_TEST(test_LedManager_Update_TogglesAt500ms);
    RUN_TEST(test_LedManager_Update_TogglesBackAt1000ms);
    RUN_TEST(test_LedManager_Update_HandlesTickWraparound);

    return UNITY_END();
}
