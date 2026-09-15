CC = gcc
LD = ld
ASM = nasm
QEMU = qemu-system-x86_64

CFLAGS = -m32 -ffreestanding -c -fno-pic -fno-stack-protector
LDFLAGS = -m elf_i386 -T linker.ld
ASMFLAGS = -f elf32

BUILD = build

all: kernel.iso

$(BUILD)/boot.o: boot.asm
	@mkdir -p $(BUILD)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD)/gdt_flush.o: gdt_flush.asm
	@mkdir -p $(BUILD)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD)/idt_flush.o: idt_flush.asm
	@mkdir -p $(BUILD)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD)/isr.o: isr.asm
	@mkdir -p $(BUILD)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD)/kernel.o: kernel/kernel.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/gdt.o: kernel/gdt.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/idt.o: kernel/idt.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/isr_c.o: kernel/isr.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/kernel.bin: $(BUILD)/boot.o $(BUILD)/gdt_flush.o $(BUILD)/idt_flush.o $(BUILD)/isr.o $(BUILD)/kernel.o $(BUILD)/gdt.o $(BUILD)/idt.o $(BUILD)/isr_c.o
	$(LD) $(LDFLAGS) -o $@ $^

iso/boot/kernel.bin: $(BUILD)/kernel.bin
	@mkdir -p iso/boot/grub
	cp $(BUILD)/kernel.bin iso/boot/

iso/boot/grub/grub.cfg:
	@mkdir -p iso/boot/grub
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'menuentry "Mini-kernel" {' >> iso/boot/grub/grub.cfg
	echo '    multiboot /boot/kernel.bin' >> iso/boot/grub/grub.cfg
	echo '    boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg

kernel.iso: $(BUILD)/kernel.bin iso/boot/kernel.bin iso/boot/grub/grub.cfg
	grub-mkrescue -o kernel.iso iso/

run: kernel.iso
	$(QEMU) -enable-kvm -cdrom kernel.iso

clean:
	rm -f $(BUILD)/*.o $(BUILD)/*.bin *.iso
	rm -rf iso/ $(BUILD)

.PHONY: all run clean