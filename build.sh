#!/usr/bin/env bash
set -e

echo "Compiling C + RISC-V..."

# Crear carpeta build si no existe
mkdir -p build

# Compilar el startup en ensamblador
riscv64-unknown-elf-gcc -c RISCV/startup.asm -o build/startup.o

# Compilar el programa principal en C
riscv64-unknown-elf-gcc -c C/main.c -o build/main.o -O2 -march=rv32i -mabi=ilp32

# Enlazar todos los objetos en un ELF ejecutable
riscv64-unknown-elf-gcc -T linker.ld \
    build/startup.o build/main.o \
    -o build/tea.elf -nostdlib -nostartfiles

echo "build/tea.elf generado"

