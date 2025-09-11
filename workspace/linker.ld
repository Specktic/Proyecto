/* linker.ld - Script de enlazado mínimo para bare-metal RISC-V */

ENTRY(_start)  /* Punto de entrada: definido en startup.asm */

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 16M
}

SECTIONS
{
    /* Sección de código */
    .text :
    {
        _text_start = .;
        *(.text*)
        _text_end = .;
    } > RAM

    /* Sección de datos inicializados */
    .data :
    {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > RAM

    /* Sección de datos no inicializados (bss) */
    .bss :
    {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        _bss_end = .;
    } > RAM

    /* Incluir los símbolos del archivo msg.txt convertido a objeto */
    .rodata :
    {
        _binary_msg_txt_start = .;
        *(.rodata*)
        _binary_msg_txt_end = .;
    } > RAM
}

