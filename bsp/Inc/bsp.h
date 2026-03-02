#ifndef BSP_H
#define BSP_H

/**
 * @file  bsp.h
 * @brief Board Support Package interface.
 *        This is the ONLY header that app/ code includes
 *        for any hardware interaction. All HAL calls are
 *        hidden behind this interface in bsp.c.
 */

#include <stdint.h>

/* --- Initialisation --- */
void     BSP_Init(void);

/* --- LED --- */
void     BSP_LED_Write(uint8_t ledId, uint8_t state);
uint8_t  BSP_LED_Read (uint8_t ledId);

/* --- Timing --- */
uint32_t BSP_GetTickMs(void);    /* SysTick-driven — main time source        */
uint32_t BSP_GetTim2Ticks(void); /* TIM2-driven    — reserved for future use */
void     BSP_DelayMs (uint32_t ms);

/* --- UART --- */
void     BSP_UART_Print   (const char *msg);
void     BSP_UART_Transmit(const uint8_t *data, uint16_t len);

/* --- Button --- */
uint8_t  BSP_Button_Read(void);

#endif /* BSP_H */