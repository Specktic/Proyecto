    .section .text
    .globl _start

_start:
    # Inicializar la pila
    la sp, stack_top

    # Llamar a main
    call main

    # Loop infinito al finalizar
hang:
    j hang

    .section .bss
    .align 3
stack:
    .space 4096         # 4 KB de pila
stack_top:
