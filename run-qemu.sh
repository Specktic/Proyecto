#!/usr/bin/env bash
set -euo pipefail

ELF="build/tea.elf"

if [ ! -f "$ELF" ]; then
    echo "No $ELF. Execute ./build.sh"
    exit 1
fi

if [[ "${1:-}" == "-d" ]]; then
    echo "QEMU / GDB (port 1234)..."
    qemu-riscv64 -g 1234 "$ELF"
else
    echo "QEMU"
    qemu-riscv64 "$ELF"
fi
