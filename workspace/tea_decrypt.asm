    .text
    .global tea_decrypt
    .type tea_decrypt, @function

# a0 = msg pointer
# a1 = key pointer (4 x uint32_t)
# a2 = length in bytes (múltiplo de 8)
tea_decrypt:
    add t0, a0, zero       # t0 = ptr al buffer
    add t1, a2, zero       # t1 = longitud restante

    # Cargar clave
    lw t2, 0(a1)           # key[0]
    lw t3, 4(a1)           # key[1]
    lw t4, 8(a1)           # key[2]
    lw t5, 12(a1)          # key[3]

decrypt_block_loop:
    beq t1, zero, decrypt_done

    # Cargar bloque de 64 bits: v0 = t6, v1 = a3
    lw t6, 0(t0)           # v0
    lw a3, 4(t0)           # v1

    li a5, 0x9E3779B9      # delta
    li a6, 32               # rondas
    slli a4, a5, 5         # sum inicial = delta * rounds (0x9E3779B9 * 32)

tea_decrypt_round_loop:
    # v1 -= ((v0<<4)+k2) ^ (v0+sum) ^ ((v0>>5)+k3)
    slli t0, t6, 4
    add t0, t0, t4
    add t0, t0, t6
    srli t1, t6, 5
    add t1, t1, t5
    xor t0, t0, t1
    sub a3, a3, t0

    # v0 -= ((v1<<4)+k0) ^ (v1+sum) ^ ((v1>>5)+k1)
    slli t0, a3, 4
    add t0, t0, t2
    add t0, t0, a3
    srli t1, a3, 5
    add t1, t1, t3
    xor t0, t0, t1
    sub t6, t6, t0

    sub a4, a4, a5         # sum -= delta
    addi a6, a6, -1
    bnez a6, tea_decrypt_round_loop

    # Guardar bloque descifrado
    sw t6, 0(t0)
    sw a3, 4(t0)

    addi t0, t0, 8
    addi t1, t1, -8
    j decrypt_block_loop

decrypt_done:
    ret
