# 需要 riscv64-linux-gnu-gcc 与 qemu-riscv64
CROSS   ?= riscv64-linux-gnu-
CC      := $(CROSS)gcc
OBJDUMP := $(CROSS)objdump
QEMU    ?= qemu-riscv64
CFLAGS  := -march=rv64gc -mabi=lp64 -nostdlib -static

all: sumto

sumto: sumto.s
	$(CC) $(CFLAGS) -o $@ $<

run: sumto
	$(QEMU) ./sumto; echo "exit code = $$?  (期望 15)"

disasm: sumto
	$(OBJDUMP) -d $< | tee sumto.disasm.txt

clean:
	rm -f sumto

.PHONY: all run disasm clean
