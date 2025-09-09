ENTRY(_start)

SECTIONS {
  . = 0x80000000;

  .text : {
    *(.text)
  }

  .rodata : {
    *(.rodata)
    *(.rodata.*)
    build/msg.o(.data)   /* Forzar msg.txt en sección de solo lectura */
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
