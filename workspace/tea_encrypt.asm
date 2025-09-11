    .text
    .global tea_encrypt
    .type tea_encrypt, @function

# a0 = msg pointer
# a1 = key pointer (4 x uint32_t)
# a2 = length in bytes (múltiplo de 8)
tea_encrypt:
    add t0, a0, zero       # t0 = ptr al buffer
    add t1, a2, zero       # t1 = longitud restante

    # Cargar clave
    lw t2, 0(a1)           # key[0]
    lw t3, 4(a1)           # key[1]
    lw t4, 8(a1)           # key[2]
    lw t5, 12(a1)          # key[3]

encrypt_block_loop:
    beq t1, zero, encrypt_done

    # Cargar bloque de 64 bits: v0 = t6, v1 = a3
    lw t6, 0(t0)           # v0
    lw a3, 4(t0)           # v1

    li a4, 0               # sum = 0
    li a5, 0x9E3779B9      # delta
    li a6, 32              # rondas

tea_round_loop:
    add a4, a4, a5         # sum += delta

    # v0 += ((v1<<4)+k0) ^ (v1+sum) ^ ((v1>>5)+k1)
    slli t0, a3, 4
    add t0, t0, t2
    add t0, t0, a3
    srli t1, a3, 5
    add t1, t1, t3
    xor t0, t0, t1
    add t6, t6, t0

    # v1 += ((v0<<4)+k2) ^ (v0+sum) ^ ((v0>>5)+k3)
    slli t0, t6, 4
    add t0, t0, t4
    add t0, t0, t6
    srli t1, t6, 5
    add t1, t1, t5
    xor t0, t0, t1
    add a3, a3, t0

    addi a6, a6, -1
    bnez a6, tea_round_loop

    # Guardar bloque cifrado
    sw t6, 0(t0)
    sw a3, 4(t0)

    addi t0, t0, 8
    addi t1, t1, -8
    j encrypt_block_loop

encrypt_done:
    ret
