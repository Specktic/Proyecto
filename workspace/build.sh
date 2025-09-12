#!/usr/bin/env bash
set -e

echo "🔨 Compilando proyecto C + RISC-V bare-metal RV32..."

mkdir -p build

# Convertir msg.txt en objeto
riscv64-unknown-elf-objcopy -I binary -O elf32-littleriscv -B riscv msg.txt build/msg.o

# Compilar startup.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv32i -mabi=ilp32 startup.asm -o build/startup.o
w
# Compilar tea_encrypt.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv32i -mabi=ilp32 tea_encrypt.asm -o build/tea_encrypt.o

# Compilar tea_decrypt.asm
riscv64-unknown-elf-gcc -c -x assembler -march=rv32i -mabi=ilp32 tea_decrypt.asm -o build/tea_decrypt.o


# Compilar C
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c main.c -o build/main.o -O2 -ffreestanding -nostdlib

# Enlazar
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 \
    -T linker.ld \
    build/startup.o build/tea_encrypt.o build/tea_decrypt.o build/msg.o build/main.o \
    -o build/tea.elf -nostdlib -nostartfiles

echo "✅ Compilación finalizada: build/tea.elf"
