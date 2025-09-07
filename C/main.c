#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// Funciones en ASM
extern void tea_encrypt(uint32_t* v, uint32_t* k);
extern void tea_decrypt(uint32_t* v, uint32_t* k);

// Clave de 128 bits (puede modificarse directamente en el código)
static uint32_t key[4] = {0x01234567, 0x89abcdef, 0xfedcba98, 0x76543210};

// Funciones de alto nivel (definidas en C)
void encrypt_message(const char* filename);
void decrypt_message(const char* filename);

int main() {
    encrypt_message("msg.txt");
    decrypt_message("msg.txt"); // se puede modificar para usar otro archivo
    return 0;
}

