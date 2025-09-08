#!/bin/bash
set -e

echo "🔨 Compilando proyecto C + RISC-V bare-metal 64-bit..."

mkdir -p build

# Compilar startup.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/startup.asm -o build/startup.o

# Compilar main.c
riscv64-unknown-elf-gcc -c C/main.c -O2 -march=rv64i -mabi=lp64 -o build/main.o

# Enlazar (sin librerías estándar)
riscv64-unknown-elf-gcc -T linker.ld build/startup.o build/main.o -o build/tea.elf -nostdlib -nostartfiles

echo "✅ Compilación completada: build/tea.elf"
