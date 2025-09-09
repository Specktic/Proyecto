#!/usr/bin/env bash
set -e

echo "🔨 Compilando proyecto C + RISC-V bare-metal RV64 (mcmodel=medany)..."

mkdir -p build

# Compilar startup.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/startup.asm -o build/startup.o

# Compilar tea_encrypt.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/tea_encrypt.asm -o build/tea_encrypt.o

# Compilar tea_decrypt.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/tea_decrypt.asm -o build/tea_decrypt.o

# Compilar putchars.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv64i -mabi=lp64 RISCV/putchars.asm -o build/putchars.o

# Compilar main.c
riscv64-unknown-elf-gcc -c -O2 -march=rv64i -mabi=lp64 C/main.c -o build/main.o

# Enlazar todo
riscv64-unknown-elf-gcc -T linker.ld \
    build/startup.o build/tea_encrypt.o build/tea_decrypt.o build/putchars.o build/main.o \
    -o build/tea.elf -nostdlib -nostartfiles

echo "✅ Compilación finalizada: build/tea.elf"
