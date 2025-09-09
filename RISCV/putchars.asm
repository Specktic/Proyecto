    .section .text
    .global putchars
    .align 2

# void putchars(const char *s);
putchars:
    addi sp, sp, -16
    sd ra, 8(sp)

.loop:
    ld a0, 0(a0)       # load byte from pointer s
    beq a0, zero, .done
    # write char to UART0 (ejemplo mapeo MMIO)
    li t0, 0x10000000  # dirección base UART0
    sb a0, 0(t0)
    addi a0, a0, 1
    j .loop

.done:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret
