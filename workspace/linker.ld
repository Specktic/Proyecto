/* linker.ld - Bare-metal RISC-V RV32 para QEMU virt mejorado */

/* Punto de entrada */
ENTRY(_start)

/* Memoria simulada por QEMU */
MEMORY
{
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

/* Layout de secciones */
SECTIONS
{
  . = ORIGIN(RAM);

  /* Código */
  .text : {
    KEEP(*(.init))
    *(.text .text.*)
    *(.rodata .rodata.*)
  } > RAM

  /* Datos inicializados */
  .data : {
    *(.data .data.*)
  } > RAM

  /* BSS (no inicializado) */
  .bss (NOLOAD) : {
    __bss_start = .;
    *(.bss .bss.*)
    *(COMMON)
    __bss_end = .;
  } > RAM

  /* Alineación final */
  . = ALIGN(4);

  /* Pila mínima 4 KB al final de RAM */
  _stack_end = ORIGIN(RAM) + LENGTH(RAM);
  _stack_start = _stack_end - 0x1000; /* 4 KB de stack */

  /* Símbolo de fin de memoria para heap dinámico */
  end = .;
  PROVIDE(_end = .);
}

