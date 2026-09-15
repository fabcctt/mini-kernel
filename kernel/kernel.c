#include "gdt.h"
#include "idt.h"
#include "isr.h"

volatile char *vga = (volatile char *)0xB8000;

#define WHITE_ON_BLACK 0x0F
#define GREEN_ON_BLACK 0x0A
#define RED_ON_BLACK   0x0C

void putchar(int x, int y, char c, char color) {
    int offset = (y * 80 + x) * 2;
    vga[offset] = c;
    vga[offset + 1] = color;
}

void print(const char *str, int x, int y, char color) {
    int i = 0;
    while (str[i] != '\0') {
        putchar(x + i, y, str[i], color);
        i++;
    }
}

void clear_screen(void) {
    for (int y = 0; y < 25; y++) {
        for (int x = 0; x < 80; x++) {
            putchar(x, y, ' ', WHITE_ON_BLACK);
        }
    }
}

void kernel_main(void) {
    clear_screen();

    print("Mini-kernel in C v0.3", 0, 0, WHITE_ON_BLACK);

    print("Initializing GDT...", 0, 2, WHITE_ON_BLACK);
    gdt_init();
    print("GDT loaded.", 0, 3, GREEN_ON_BLACK);

    print("initializing IDT..", 0, 4, WHITE_ON_BLACK);
    idt_init();
    isr_init();
    print("IDT loaded.", 0, 5, GREEN_ON_BLACK);

    while (1) { }
}