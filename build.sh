#!/bin/bash
set -e
echo "🔨 Compilando proyecto C + RISC-V bare-metal RV64 (mcmodel=medany)..."

# limpiar y preparar
rm -rf build
mkdir -p build

# 1) compilar startup (asm)
riscv64-unknown-elf-gcc -c -x assembler \
  -march=rv64i -mabi=lp64 -mcmodel=medany \
  RISCV/startup.asm -o build/startup.o

# 2) compilar main.c (C)
riscv64-unknown-elf-gcc -c \
  -O2 -ffreestanding -fno-builtin \
  -march=rv64i -mabi=lp64 -mcmodel=medany \
  C/main.c -o build/main.o

# 3) convertir msg.txt en objeto binario
riscv64-unknown-elf-ld -r -b binary msg.txt -o build/msg.o

# 4) enlazar todo (usar mcmodel=medany en el enlace)
riscv64-unknown-elf-gcc -nostdlib -nostartfiles -T linker.ld \
  -mcmodel=medany \
  build/startup.o build/main.o build/msg.o \
  -o build/tea.elf

echo "✅ Compilación finalizada: build/tea.elf"
