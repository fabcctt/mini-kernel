; gdt_flush.asm - Load the GDT and reload segments

[bits 32]
section .text
global gdt_flush
extern gp

gdt_flush:
    mov eax, [esp + 4]      ; get the pointer to gdt_ptr
    lgdt [eax]              ; load the GDT

    ; Reload segment registers
    mov ax, 0x10            ; 0x10 = offset to data segment (entry 2)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Far jump to reload CS (0x08 = offset to code segment, entry 1)
    jmp 0x08:.flush
.flush:
    ret

section .note.GNU-stack noalloc noexec nowrite progbits