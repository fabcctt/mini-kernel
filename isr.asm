[bits 32]
section .text

; Macros for ISRs without error code
%macro ISR_NOERR 1
global isr%1
isr%1:
    cli
    push 0
    push %1
    jmp isr_common
%endmacro

; Macros for ISRs with error code
%macro ISR_ERR 1
global isr%1
isr%1:
    cli
    push %1
    jmp isr_common
%endmacro

; Exceptions 0-31
ISR_NOERR 0   ; Divide by zero
ISR_NOERR 1   ; Debug
ISR_NOERR 2   ; Non-maskable interrupt
ISR_NOERR 3   ; Breakpoint
ISR_NOERR 4   ; Overflow
ISR_NOERR 5   ; Bound range exceeded
ISR_NOERR 6   ; Invalid opcode
ISR_NOERR 7   ; Device not available
ISR_ERR   8   ; Double fault
ISR_NOERR 9   ; Coprocessor segment overrun
ISR_ERR   10  ; Invalid TSS
ISR_ERR   11  ; Segment not present
ISR_ERR   12  ; Stack-segment fault
ISR_ERR   13  ; General protection fault
ISR_ERR   14  ; Page fault
ISR_NOERR 15  ; Reserved
ISR_NOERR 16  ; x87 floating-point exception
ISR_ERR   17  ; Alignment check
ISR_NOERR 18  ; Machine check
ISR_NOERR 19  ; SIMD floating-point exception
ISR_NOERR 20  ; Virtualization exception
ISR_NOERR 21  ; Control protection exception
ISR_NOERR 22  ; Reserved
ISR_NOERR 23  ; Reserved
ISR_NOERR 24  ; Reserved
ISR_NOERR 25  ; Reserved
ISR_NOERR 26  ; Reserved
ISR_NOERR 27  ; Reserved
ISR_NOERR 28  ; Reserved
ISR_NOERR 29  ; Reserved
ISR_NOERR 30  ; Reserved
ISR_NOERR 31  ; Reserved

; Common ISR handler
extern isr_handler
isr_common:
    pusha

    mov ax, ds
    push eax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp
    call isr_handler
    add esp, 4

    pop eax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    popa
    add esp, 8
    iret

section .note.GNU-stack noalloc noexec nowrite progbits