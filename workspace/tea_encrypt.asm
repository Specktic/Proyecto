    .section .text
    .globl tea_encrypt

# void tea_encrypt(uint8_t *msg, uint32_t key[4], uint32_t len)
# a0 = msg, a1 = key, a2 = len

tea_encrypt:
    add     t0, a0, a2          # t0 = msg + len (fin del buffer)

enc_loop:
    bge     a0, t0, enc_done    # si a0 >= t0, terminamos

    # --- cargar bloque de 64 bits (dos palabras) ---
    lw      t1, 0(a0)           # v0
    lw      t2, 4(a0)           # v1

    # --- cargar clave K0..K3 ---
    lw      t3, 0(a1)           # k0
    lw      t4, 4(a1)           # k1
    lw      t5, 8(a1)           # k2
    lw      t6, 12(a1)          # k3

    # --- delta y sum inicial ---
    li      s0, 0x9E3779B9      # delta
    li      s1, 0               # sum = 0

    li      a3, 32              # contador = 32 rondas

enc_round:
    # sum += delta
    add     s1, s1, s0

    # v0 += (((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1))
    sll     a4, t2, 4           # (v1 << 4)
    add     a4, a4, t3          # + k0

    add     a5, t2, s1          # v1 + sum
    xor     a4, a4, a5

    srl     a5, t2, 5           # (v1 >> 5)
    add     a5, a5, t4          # + k1
    xor     a4, a4, a5

    add     t1, t1, a4          # v0 += ...

    # v1 += (((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3))
    sll     a4, t1, 4           # (v0 << 4)
    add     a4, a4, t5          # + k2

    add     a5, t1, s1          # v0 + sum
    xor     a4, a4, a5

    srl     a5, t1, 5           # (v0 >> 5)
    add     a5, a5, t6          # + k3
    xor     a4, a4, a5

    add     t2, t2, a4          # v1 += ...

    addi    a3, a3, -1
    bnez    a3, enc_round

    # --- guardar bloque cifrado ---
    sw      t1, 0(a0)
    sw      t2, 4(a0)

    addi    a0, a0, 8           # avanzar al siguiente bloque
    j       enc_loop

enc_done:
    ret
