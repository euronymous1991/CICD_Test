#include "led_manager.h"
#include "bsp.h"

typedef struct {
    LedState_t state;
    bool       blinking;
    uint32_t   periodMs;
    uint32_t   lastToggleMs;
} LedContext_t;

static LedContext_t s_leds[LED_COUNT];

void LedManager_Init(void)
{
    for (uint8_t i = 0U; i < (uint8_t)LED_COUNT; i++)
    {
        s_leds[i].state        = LED_OFF;
        s_leds[i].blinking     = false;
        s_leds[i].periodMs     = 0U;
        s_leds[i].lastToggleMs = 0U;
        BSP_LED_Write(i, 0U);
    }
}

void LedManager_Set(LedId_t id, LedState_t state)
{
    if (id >= LED_COUNT) { return; }
    s_leds[id].blinking = false;
    s_leds[id].state    = state;
    BSP_LED_Write((uint8_t)id, (uint8_t)state);
}

void LedManager_Toggle(LedId_t id)
{
    if (id >= LED_COUNT) { return; }
    LedState_t next = (s_leds[id].state == LED_ON) ? LED_OFF : LED_ON;
    LedManager_Set(id, next);
}

void LedManager_Blink(LedId_t id, uint32_t periodMs)
{
    if (id >= LED_COUNT) { return; }
    s_leds[id].blinking     = true;
    s_leds[id].periodMs     = periodMs;
    s_leds[id].lastToggleMs = BSP_GetTickMs();
}

LedState_t LedManager_GetState(LedId_t id)
{
    if (id >= LED_COUNT) { return LED_OFF; }
    return s_leds[id].state;
}

void LedManager_Update(void)
{
    uint32_t now = BSP_GetTickMs();
    for (uint8_t i = 0U; i < (uint8_t)LED_COUNT; i++)
    {
        if (s_leds[i].blinking) { continue; }
        if ((now - s_leds[i].lastToggleMs) >= (s_leds[i].periodMs / 2U))
        {
            s_leds[i].lastToggleMs = now;
            LedState_t next = (s_leds[i].state == LED_ON) ? LED_OFF : LED_ON;
            s_leds[i].state = next;
            BSP_LED_Write(i, (uint8_t)next);
        }
    }
}
