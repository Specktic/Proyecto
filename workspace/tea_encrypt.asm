        .text
        .globl tea_encrypt
        .type tea_encrypt, @function

# void tea_encrypt(uint32_t v[2], uint32_t key[4])
# a0 = puntero al bloque v[2]
# a1 = puntero a key[4]

tea_encrypt:
        # Carga bloque
        lw      t0, 0(a0)        # v0
        lw      t1, 4(a0)        # v1

        # Carga clave
        lw      s0, 0(a1)        # k0
        lw      s1, 4(a1)        # k1
        lw      s2, 8(a1)        # k2
        lw      s3, 12(a1)       # k3

        li      t2, 0             # sum = 0
        li      t3, 32            # rondas = 32
        li      t4, 0x9E3779B9    # DELTA

round_loop:
        beqz    t3, save_block    # si rondas == 0, salir

        add     t2, t2, t4        # sum += DELTA

        # --- v0 += ((v1<<4)+k0) ^ (v1+sum) ^ ((v1>>5)+k1) ---
        sll     t5, t1, 4         # t5 = v1 << 4
        add     t5, t5, s0        # t5 += k0
        add     t6, t1, t2        # t6 = v1 + sum
        xor     t5, t5, t6        # t5 = ((v1<<4)+k0) ^ (v1+sum)
        srl     t6, t1, 5         # t6 = v1 >> 5
        add     t6, t6, s1        # t6 += k1
        xor     t5, t5, t6        # t5 = ((v1<<4)+k0) ^ (v1+sum) ^ ((v1>>5)+k1)
        add     t0, t0, t5        # v0 += t5

        # --- v1 += ((v0<<4)+k2) ^ (v0+sum) ^ ((v0>>5)+k3) ---
        sll     t5, t0, 4         # t5 = v0 << 4
        add     t5, t5, s2        # t5 += k2
        add     t6, t0, t2        # t6 = v0 + sum
        xor     t5, t5, t6        # t5 = ((v0<<4)+k2) ^ (v0+sum)
        srl     t6, t0, 5         # t6 = v0 >> 5
        add     t6, t6, s3        # t6 += k3
        xor     t5, t5, t6        # t5 = ((v0<<4)+k2) ^ (v0+sum) ^ ((v0>>5)+k3)
        add     t1, t1, t5        # v1 += t5

        addi    t3, t3, -1        # rondas--
        j       round_loop

save_block:
        sw      t0, 0(a0)
        sw      t1, 4(a0)
        ret
