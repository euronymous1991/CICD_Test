#ifndef LED_MANAGER_H
#define LED_MANAGER_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    LED_GREEN = 0U,
    LED_COUNT
} LedId_t;

typedef enum {
    LED_OFF = 0U,
    LED_ON  = 1U
} LedState_t;

void       LedManager_Init   (void);
void       LedManager_Set    (LedId_t id, LedState_t state);
void       LedManager_Toggle (LedId_t id);
void       LedManager_Blink  (LedId_t id, uint32_t periodMs);
LedState_t LedManager_GetState(LedId_t id);
void       LedManager_Update (void);

#endif /* LED_MANAGER_H */
