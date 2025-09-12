// main.c - Bare-metal RV32 con TEA, UART y padding para bloques de 64 bits

#include <stdint.h>

#define BLOCK_SIZE 8          // TEA trabaja en bloques de 64 bits
#define MAX_MSG_SIZE 256
#define UART_ADDR 0x10000000  // Dirección UART en QEMU

// --- Funciones de ensamblador (con longitud en bytes) ---
extern void tea_encrypt(uint8_t *msg, uint32_t key[4], uint32_t len);
extern void tea_decrypt(uint8_t *msg, uint32_t key[4], uint32_t len);

// Símbolos generados desde msg.txt convertido a objeto
extern uint8_t _binary_msg_txt_start[];
extern uint8_t _binary_msg_txt_end[];

// --- UART output ---
static inline void putchar_uart(char c) {
    volatile char *uart = (volatile char*)UART_ADDR;
    *uart = c;
}

void print_string(const char *str) {
    while (*str) putchar_uart(*str++);
}

// --- Funciones de impresión en hexadecimal ---
void print_hex_byte(uint8_t byte) {
    const char hex[] = "0123456789ABCDEF";
    putchar_uart(hex[(byte >> 4) & 0xF]);
    putchar_uart(hex[byte & 0xF]);
}

void print_buffer_hex(uint8_t *buf, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        print_hex_byte(buf[i]);
        putchar_uart(' ');
    }
    putchar_uart('\n');
}

void print_buffer_ascii(uint8_t *buf, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        char c = buf[i];
        if (c >= 32 && c <= 126)  // rango ASCII visible
            putchar_uart(c);
        else
            putchar_uart('.');
    }
    putchar_uart('\n');
}

// --- Padding de mensaje ---
uint32_t padded_length(uint32_t len) {
    return (len + BLOCK_SIZE - 1) & ~(BLOCK_SIZE - 1);
}

void copy_and_pad(uint8_t *dst, uint8_t *src, uint32_t len) {
    uint32_t pad_len = padded_length(len);
    for (uint32_t i = 0; i < pad_len; i++) {
        dst[i] = (i < len) ? src[i] : 0;
    }
}

int main(void) {
    uint8_t *msg = _binary_msg_txt_start;
    uint32_t msg_len = _binary_msg_txt_end - _binary_msg_txt_start;

    uint32_t key[4] = {0x12345678, 0x9ABCDEF0, 0xFEDCBA98, 0x76543210};

    uint8_t buffer[MAX_MSG_SIZE];
    copy_and_pad(buffer, msg, msg_len);
    uint32_t padded_len = padded_length(msg_len);

    print_string("Mensaje original (hex):\n");
    print_buffer_hex(buffer, padded_len);
    print_string("Mensaje original (ASCII):\n");
    print_buffer_ascii(buffer, msg_len);

    tea_encrypt(buffer, key, padded_len);

    print_string("Mensaje cifrado (hex):\n");
    print_buffer_hex(buffer, padded_len);

    tea_decrypt(buffer, key, padded_len);

    print_string("Mensaje descifrado (hex):\n");
    print_buffer_hex(buffer, padded_len);
    print_string("Mensaje descifrado (ASCII):\n");
    print_buffer_ascii(buffer, msg_len);

    while (1) { __asm__ volatile("nop"); }
}
