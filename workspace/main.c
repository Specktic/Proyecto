// main.c - Bare-metal RV32 con TEA y semihosting para impresión

#include <stdint.h>

#define BLOCK_SIZE 8    // 64 bits
#define MAX_MSG_SIZE 256

// Funciones de ensamblador
void tea_encrypt(uint8_t *msg, uint32_t key[4]);
void tea_decrypt(uint8_t *msg, uint32_t key[4]);

// Símbolos generados desde msg.txt convertido a objeto
extern uint8_t _binary_msg_txt_start[];
extern uint8_t _binary_msg_txt_end[];

// --- Semihosting putchar ---
static inline void putchar_sh(unsigned char c) {
    asm volatile(
        "li a7, 1\n"    // SYS_WRITE0: semihosting write char
        "mv a0, %0\n"
        "ecall\n"
        : : "r"(c)
    );
}

// Imprime un buffer completo
void print_buffer(uint8_t *buf, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        putchar_sh(buf[i]);
    }
}

// Calcula tamaño con padding
uint32_t padded_length(uint32_t len) {
    return (len + BLOCK_SIZE - 1) & ~(BLOCK_SIZE - 1);
}

// Copia mensaje y aplica padding con ceros
void copy_and_pad(uint8_t *dst, uint8_t *src, uint32_t len) {
    uint32_t pad_len = padded_length(len);
    for (uint32_t i = 0; i < pad_len; i++) {
        dst[i] = (i < len) ? src[i] : 0;
    }
}

int main(void) {
    uint8_t *msg = _binary_msg_txt_start;
    uint32_t msg_len = _binary_msg_txt_end - _binary_msg_txt_start;

    // Clave TEA configurable
    uint32_t key[4] = {0x12345678, 0x9ABCDEF0, 0xFEDCBA98, 0x76543210};

    // Buffer con padding
    uint8_t buffer[MAX_MSG_SIZE];
    copy_and_pad(buffer, msg, msg_len);
    uint32_t padded_len = padded_length(msg_len);

    // Imprime mensaje original
    print_buffer(buffer, padded_len);
    putchar_sh('\n');

    // Cifrar
    tea_encrypt(buffer, key);
    print_buffer(buffer, padded_len);
    putchar_sh('\n');

    // Descifrar
    tea_decrypt(buffer, key);
    print_buffer(buffer, padded_len);
    putchar_sh('\n');

    // Loop infinito
    while (1) { }

    return 0;
}
