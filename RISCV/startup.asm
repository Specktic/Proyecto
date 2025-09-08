    .globl _start
_start:
    la sp, stack_top    # Inicializar la pila
    call main           # Llamar a main
1:  j 1b                # Bucle infinito al terminar

    .section .bss
    .space 4096         # Espacio de pila (4KB)
stack_top:
