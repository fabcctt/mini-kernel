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

## Build

```bash
make
