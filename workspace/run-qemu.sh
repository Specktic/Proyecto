#!/bin/bash
set -e

./build.sh

echo "🚀 Ejecutando en QEMU RV32 bare-metal..."
qemu-system-riscv32 \
  -machine virt \
  -nographic \
  -serial mon:stdio \
  -bios none \
  -kernel build/tea.elf
