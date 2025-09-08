#!/bin/bash
set -e

echo "🔨 Compilando proyecto C + RISC-V bare-metal RV64..."

mkdir -p build

# Compilar startup
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/startup.asm -o build/startup.o

# Compilar tea functions
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/tea_encrypt.asm -o build/tea_encrypt.o
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/tea_decrypt.asm -o build/tea_decrypt.o

# Incluir msg.txt como objeto binario
riscv64-unknown-elf-ld -r -b binary msg.txt -o build/msg.o

# Compilar C
riscv64-unknown-elf-gcc -c C/main.c -O2 -march=rv64i -mabi=lp64 -o build/main.o

# Enlazar todo
riscv64-unknown-elf-gcc -T linker.ld build/startup.o build/main.o build/tea_encrypt.o build/tea_decrypt.o build/msg.o -o build/tea.elf -nostdlib -nostartfiles

echo "✅ Compilación completada: build/tea.elf"
