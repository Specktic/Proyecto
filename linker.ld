ENTRY(_start)

SECTIONS {
  . = 0x80000000;   /* Punto de entrada típico en QEMU virt */

  .text : {
    *(.text)
  }

  .rodata : {
    *(.rodata)
  }

  .data : {
    *(.data)
    *(.sdata)
  }

  .bss : {
    *(.bss)
    *(.sbss)
    *(COMMON)
  }
}
