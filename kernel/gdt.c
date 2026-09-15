#include "gdt.h"

// GDT entry structure (8 bytes)
struct gdt_entry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t  base_middle;
    uint8_t  access;
    uint8_t  granularity;
    uint8_t  base_high;
} __attribute__((packed));

// GDT pointer structure (6 bytes)
struct gdt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

// Our GDT with 3 entries: null, code, data
struct gdt_entry gdt[3];
struct gdt_ptr gp;

// Defined in gdt_flush.asm
extern void gdt_flush(uint32_t);

// Set a GDT entry
static void gdt_set_gate(int num, uint32_t base, uint32_t limit,
                          uint8_t access, uint8_t gran) {
    // Base address
    gdt[num].base_low    = (base & 0xFFFF);
    gdt[num].base_middle = (base >> 16) & 0xFF;
    gdt[num].base_high   = (base >> 24) & 0xFF;

    // Limit
    gdt[num].limit_low   = (limit & 0xFFFF);
    gdt[num].granularity = (limit >> 16) & 0x0F;

    // Granularity flags
    gdt[num].granularity |= (gran & 0xF0);

    // Access flags
    gdt[num].access      = access;
}

    // Initialize the GDT
void gdt_init(void) {
    // Setup the GDT pointer
    gp.limit = (sizeof(struct gdt_entry) * 3) - 1;
    gp.base  = (uint32_t)&gdt;

    // Entry 0: Null descriptor
    gdt_set_gate(0, 0, 0, 0, 0);

    // Entry 1: Kernel code segment
    // base=0, limit=4GB, access=0x9A, gran=0xCF
    gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);

    // Entry 2: Kernel data segment
    // base=0, limit=4GB, access=0x92, gran=0xCF
    gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    // Load the GDT
    gdt_flush((uint32_t)&gp);
}