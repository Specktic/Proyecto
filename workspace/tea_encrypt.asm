    .section .text
    .globl tea_encrypt
    .type tea_encrypt, @function

# void tea_encrypt(uint8_t *msg, uint32_t key[4])
# Entrada:
#   a0 = puntero al buffer del mensaje
#   a1 = puntero a la clave (4x32 bits)
tea_encrypt:
    # Cargar bloque de 64 bits (2 palabras)
    lw t0, 0(a0)         # v0
    lw t1, 4(a0)         # v1

    # Cargar clave
    lw t2, 0(a1)         # k0
    lw t3, 4(a1)         # k1
    lw t4, 8(a1)         # k2
    lw t5, 12(a1)        # k3

    # Inicializar suma y delta
    li t6, 0             # sum
    li a6, 0x9e3779b9    # delta

    # 32 rondas de cifrado
    li a0, 32            # contador de rondas
encrypt_loop:
    add t6, t6, a6
    slli t2, t1, 4       # tmp1 = v1 << 4
    add t2, t2, t2       # tmp1 += k0
    srli t3, t1, 5       # tmp2 = v1 >> 5
    add t3, t3, t3       # tmp2 += k1
    xor t0, t0, t2
    xor t0, t0, t3
    add t0, t0, t6

    slli t2, t0, 4
    add t2, t2, t4
    srli t3, t0, 5
    add t3, t3, t5
    xor t1, t1, t2
    xor t1, t1, t3
    add t1, t1, t6

    addi a0, a0, -1
    bnez a0, encrypt_loop

    # Guardar bloque cifrado
    sw t0, 0(a0)
    sw t1, 4(a0)

    ret
