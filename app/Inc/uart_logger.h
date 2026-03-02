#ifndef UART_LOGGER_H
#define UART_LOGGER_H

#include <stdint.h>

void UartLogger_Init   (void);
void UartLogger_Print  (const char *msg);
void UartLogger_Printf (const char *fmt, ...);

#endif /* UART_LOGGER_H */
