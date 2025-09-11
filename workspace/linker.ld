/* linker.ld - Bare-metal RISC-V RV32 para QEMU virt */

/* Punto de entrada */
ENTRY(_start)

/* Memoria simulada por QEMU: 
   - RAM en 0x80000000 (128 MB por defecto en -machine virt)
   - UART en 0x10000000 (no lo definimos aquí, se accede directo por MMIO) */
MEMORY
{
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

/* Layout de secciones */
SECTIONS
{
  . = ORIGIN(RAM);

  .text : {
    KEEP(*(.init))         /* código de arranque */
    *(.text .text.*)       /* código del programa */
    *(.rodata .rodata.*)   /* datos de solo lectura */
  } > RAM

  .data : {
    *(.data .data.*)
  } > RAM

  .bss (NOLOAD) : {
    __bss_start = .;
    *(.bss .bss.*)
    *(COMMON)
    __bss_end = .;
  } > RAM

  . = ALIGN(4);
  end = .;
  PROVIDE(_end = .);
}
