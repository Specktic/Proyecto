    .section .text
    .globl _start

_start:
    # Inicializar la pila
    la sp, stack_top

    # Limpiar .bss
    la t0, __bss_start       # inicio de bss
    la t1, __bss_end         # fin de bss
clear_bss:
    bge t0, t1, bss_done
    sw x0, 0(t0)
    addi t0, t0, 4
    j clear_bss
bss_done:

    # Llamar a main
    call main

    # Loop infinito al finalizar
hang:
    j hang

    .section .bss
    .align 3
stack:
    .space 4096             # 4 KB de pila
stack_top:

    .align 4
