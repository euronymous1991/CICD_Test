#include "uart_logger.h"
#include "bsp.h"
#include <stdio.h>
#include <stdarg.h>

#define UART_LOGGER_BUF_SIZE 128U

void UartLogger_Init(void)
{
    /* BSP UART already initialised in BSP_Init */
}

void UartLogger_Print(const char *msg)
{
    if (msg == NULL) { return; }
    BSP_UART_Print(msg);
}

void UartLogger_Printf(const char *fmt, ...)
{
    char    buf[UART_LOGGER_BUF_SIZE];
    va_list args;
    va_start(args, fmt);
    (void)vsnprintf(buf, sizeof(buf), fmt, args);
    va_end(args);
    BSP_UART_Print(buf);
}
