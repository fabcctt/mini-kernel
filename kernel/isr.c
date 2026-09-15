#include "isr.h"
#include "idt.h"

isr_t isr_handlers[256];

// defined in kernel
extern void print(const char *str, int x, int y, char color);

// Register an ISR handler
void isr_register(uint8_t num, isr_t handler) {
    isr_handlers[num] = handler;
}

// Initialize ISRs
void isr_init(void) {
    for (int i = 0; i < 256; i++) {
        isr_handlers[i] = 0;
    }
}

// Called from isr.asm
void isr_handler(uint32_t *regs) {
    uint32_t int_no = regs[0];
    uint32_t err_code = regs[1];

    // Print the exception
    print("Exception: ", 0, 10, 0x0C);
    
    // Convert int_no to string
    char buf[4];
    buf[0] = '0' + (int_no / 10);
    buf[1] = '0' + (int_no % 10);
    buf[2] = '\0';
    print(buf, 11, 10, 0x0C);

    // Halt
    while (1) { }
}