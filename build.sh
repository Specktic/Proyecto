#!/usr/bin/env bash
set -euo pipefail

echo "Compiling"

mkdir -p build

riscv64-unknown-elf-gcc -Wall -O2 -nostartfiles \
    -T linker.ld \
    RISCV/startup.s \
    C/main.c \
    RISCV/tea_encrypt.asm \
    RISCV/tea_decrypt.asm \
    -o build/tea.elf

echo "Compiled: build/tea.elf"
