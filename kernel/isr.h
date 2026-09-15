#ifndef ISR_H
#define ISR_H

#include "stdint.h"

// ISR handler type
typedef void (*isr_t)(void);

// Register an ISR handler
void isr_register(uint8_t num, isr_t handler);

// Initialize ISRs
void isr_init(void);

void isr_handler(uint32_t *regs);

#endif