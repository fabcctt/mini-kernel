# Mini-kernel

A minimal x86 kernel written in C and Assembly.

## Features

### Implemented

- [x] Multiboot compliant (GRUB)
- [x] VGA text mode output
- [x] GDT (Global Descriptor Table)
- [x] IDT (Interrupt Descriptor Table)
- [x] ISR stubs for exceptions 0-31
- [ ] IRQ (PIC)
- [ ] Timer (PIT)
- [ ] Keyboard
- [ ] Paging
- [ ] Heap
- [ ] Syscalls
- [ ] Scheduler

## Requirements

- `gcc` (with `-m32` support)
- `nasm`
- `ld`
- `grub-mkrescue`
- `xorriso`
- `qemu-system-x86_64` (for testing)

## Notes

This is a learning project. I don't understand 100% of the code yet,
but I'm working on it. Some parts are inspired by:
- OSDev Wiki
- JamesM's kernel tutorial

## Build

```bash
make
