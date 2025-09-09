    .section .text
    .global tea_encrypt
    .align  2

# void tea_encrypt(uint32_t *v, uint32_t *key);
# v[0], v[1] = bloque de 64 bits a cifrar (2 x 32 bits)
# key[0..3]  = clave de 128 bits
tea_encrypt:
    # Guardar registros de llamada si es necesario
    addi sp, sp, -16
    sd ra, 8(sp)

    # --- Aquí irá la lógica de cifrado TEA ---
    # Entrada:
    #   a0 -> puntero a bloque v
    #   a1 -> puntero a clave key
    # Salida:
    #   bloque cifrado escrito en *v

    # Restaurar y retornar
    ld ra, 8(sp)
    addi sp, sp, 16
    ret
