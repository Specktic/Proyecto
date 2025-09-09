#!/usr/bin/env bash
set -e

# Compilar antes de ejecutar
./build.sh

echo "🚀 Ejecutando en QEMU RV64 bare-metal..."

qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel build/tea.elf \
    -m 256M \
    -serial mon:stdio

