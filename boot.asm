; boot.asm - Mini-kernel entry point

section .multiboot
align 4
    dd 0x1BADB002
    dd 0x00
    dd -(0x1BADB002 + 0x00)

[bits 32]
section .text
global _start
extern kernel_main

_start:
    mov esp, stack_top
    mov ebp, esp
    call kernel_main
    cli
.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .note.GNU-stack noalloc noexec nowrite progbits