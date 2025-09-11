# tea_decrypt.asm - RISC-V RV32, TEA de 64 bits, 32 rondas
# Registros usados: t0-t6, a0-a6

    .section .text
    .globl tea_decrypt
tea_decrypt:
    # a0 = puntero al bloque de datos
    # a1 = puntero a clave de 128 bits (4 palabras)

    # Cargar palabras del bloque
    lw t0, 0(a0)       # t0 = v0
    lw t1, 4(a0)       # t1 = v1

    # Cargar clave
    lw t2, 0(a1)       # t2 = k0
    lw t3, 4(a1)       # t3 = k1
    lw t4, 8(a1)       # t4 = k2
    lw t5, 12(a1)      # t5 = k3

    # Inicializar delta y sum
    li t6, 0x9E3779B9      # delta
    li a2, 0xC6EF3720      # sum inicial = delta*32
    li a3, 32               # contador de rondas

decrypt_loop:
    # v1 -= ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3)
    slli t0, t0, 4          # t0 = v0 << 4
    add t0, t0, t4          # t0 += k2
    add t2, t0, a2          # t2 = v0 + sum
    srai t3, t0, 5          # t3 = v0 >> 5
    add t3, t3, t5          # t3 += k3
    xor t2, t2, t3          # t2 ^= t3
    sub t1, t1, t2          # v1 -= t2

    # v0 -= ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1)
    slli t1, t1, 4
    add t1, t1, t2           # t1 += k0 (usar t2 temporal)
    add t3, t1, a2
    srai t4, t1, 5
    add t4, t4, t3           # usar t3 temporal para k1
    xor t3, t3, t4
    sub t0, t0, t3           # v0 -= t3

    # Restar delta
    sub a2, a2, t6

    # Decrementar contador
    addi a3, a3, -1
    bnez a3, decrypt_loop

    # Guardar resultados
    sw t0, 0(a0)
    sw t1, 4(a0)

    ret
