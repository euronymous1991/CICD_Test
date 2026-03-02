#include "unity.h"
#include "led_manager.h"
#include "bsp.h"

void MockBSP_Reset(void);
void MockBSP_SetTick(uint32_t ms);
void MockBSP_AdvanceTick(uint32_t ms);
uint8_t MockBSP_LED_LastState(uint8_t id);

void setUp(void)    { MockBSP_Reset(); LedManager_Init(); }
void tearDown(void) { }

void test_LedManager_Init_SetsLedOff(void)
{
    TEST_ASSERT_EQUAL(LED_OFF, LedManager_GetState(LED_GREEN));
    TEST_ASSERT_EQUAL(0U, MockBSP_LED_LastState(0U));
}

void test_LedManager_Set_TurnsLedOn(void)
{
    LedManager_Set(LED_GREEN, LED_ON);
    TEST_ASSERT_EQUAL(LED_ON, LedManager_GetState(LED_GREEN));
    TEST_ASSERT_EQUAL(1U, MockBSP_LED_LastState(0U));
}

void test_LedManager_Set_TurnsLedOff(void)
{
    LedManager_Set(LED_GREEN, LED_ON);
    LedManager_Set(LED_GREEN, LED_OFF);
    TEST_ASSERT_EQUAL(LED_OFF, LedManager_GetState(LED_GREEN));
}

void test_LedManager_Toggle_InvertsState(void)
{
    LedManager_Set(LED_GREEN, LED_OFF);
    LedManager_Toggle(LED_GREEN);
    TEST_ASSERT_EQUAL(LED_ON, LedManager_GetState(LED_GREEN));
    LedManager_Toggle(LED_GREEN);
    TEST_ASSERT_EQUAL(LED_OFF, LedManager_GetState(LED_GREEN));
}

void test_LedManager_Blink_TogglesAfterHalfPeriod(void)
{
    MockBSP_SetTick(0U);
    LedManager_Blink(LED_GREEN, 500U);
    MockBSP_SetTick(249U); LedManager_Update();
    TEST_ASSERT_EQUAL(LED_OFF, LedManager_GetState(LED_GREEN));
    MockBSP_SetTick(250U); LedManager_Update();
    TEST_ASSERT_EQUAL(LED_ON, LedManager_GetState(LED_GREEN));
}

void test_LedManager_InvalidId_DoesNotCrash(void)
{
    LedManager_Set((LedId_t)99U, LED_ON);
    TEST_PASS();
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_LedManager_Init_SetsLedOff);
    RUN_TEST(test_LedManager_Set_TurnsLedOn);
    RUN_TEST(test_LedManager_Set_TurnsLedOff);
    RUN_TEST(test_LedManager_Toggle_InvertsState);
    RUN_TEST(test_LedManager_Blink_TogglesAfterHalfPeriod);
    RUN_TEST(test_LedManager_InvalidId_DoesNotCrash);
    return UNITY_END();
}