#!/bin/bash
set -e

./build.sh

echo "🚀 Ejecutando en QEMU RV64 bare-metal..."
qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -kernel build/tea.elf
