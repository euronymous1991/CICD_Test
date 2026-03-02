#include "bsp.h"

/*
 * bsp.c — Board Support Package implementation
 *
 * ALL HAL calls live in this file ONLY.
 * app/ code never includes stm32f4xx_hal.h directly.
 *
 * The extern handle declarations below reference the globals
 * that CubeMX generates in main.c (htim2, huart2).
 * Once you have real CubeMX-generated files, these externs
 * will resolve automatically at link time.
 */

#ifndef UNIT_TEST
#include "main.h"
#include "tim.h"
#include "usart.h"
#endif

#include <string.h>

/* ── Internal state ──────────────────────────────────────────────────────── */
static volatile uint32_t s_tickMs = 0U;

/* ── BSP_Init ────────────────────────────────────────────────────────────── */
void BSP_Init(void)
{
#ifndef UNIT_TEST
    /* Start TIM2 interrupt — fires every 1ms, increments s_tickMs */
    HAL_TIM_Base_Start_IT(&htim2);
#endif
}

/* ── TIM2 callback — called by HAL every 1ms ─────────────────────────────── */
#ifndef UNIT_TEST
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
    if (htim->Instance == TIM2)
    {
        s_tickMs++;
    }
}
#endif

/* ── LED ──────────────────────────────────────────────────────────────────── */
void BSP_LED_Write(uint8_t ledId, uint8_t state)
{
#ifndef UNIT_TEST
    (void)ledId;  /* Only one LED on Nucleo: LD2 on PA5 */
    HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin,
                      state ? GPIO_PIN_SET : GPIO_PIN_RESET);
#else
    (void)ledId;
    (void)state;
#endif
}

uint8_t BSP_LED_Read(uint8_t ledId)
{
    (void)ledId;
#ifndef UNIT_TEST
    return (uint8_t)HAL_GPIO_ReadPin(LD2_GPIO_Port, LD2_Pin);
#else
    return 0U;
#endif
}

/* ── Timing ───────────────────────────────────────────────────────────────── */
uint32_t BSP_GetTickMs(void)
{
    return s_tickMs;
}

void BSP_DelayMs(uint32_t ms)
{
#ifndef UNIT_TEST
    HAL_Delay(ms);
#else
    s_tickMs += ms;
#endif
}

/* ── UART ─────────────────────────────────────────────────────────────────── */
void BSP_UART_Print(const char *msg)
{
#ifndef UNIT_TEST
    if (msg == NULL) { return; }
    uint16_t len = (uint16_t)strlen(msg);
    (void)HAL_UART_Transmit(&huart2, (const uint8_t *)msg, len, 100U);
#else
    (void)msg;
#endif
}

void BSP_UART_Transmit(const uint8_t *data, uint16_t len)
{
#ifndef UNIT_TEST
    (void)HAL_UART_Transmit(&huart2, data, len, 100U);
#else
    (void)data;
    (void)len;
#endif
}

/* ── Button ───────────────────────────────────────────────────────────────── */
uint8_t BSP_Button_Read(void)
{
#ifndef UNIT_TEST
    return (uint8_t)HAL_GPIO_ReadPin(B1_GPIO_Port, B1_Pin);
#else
    return 0U;
#endif
}
