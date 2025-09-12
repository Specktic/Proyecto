#include <stdint.h>

#define BLOCK_SIZE 8          // TEA usa bloques de 64 bits
#define MAX_MSG_SIZE 256
#define UART_ADDR 0x10000000  // Dirección UART en QEMU

// --- Ensamblador ---
extern void tea_encrypt(uint32_t v[2], uint32_t key[4]);
extern void tea_decrypt(uint32_t v[2], uint32_t key[4]);

// --- UART ---
static inline void putchar_uart(char c) {
    volatile char *uart = (volatile char*)UART_ADDR;
    *uart = c;
}

void print_string(const char *s) {
    while (*s) putchar_uart(*s++);
}

void print_hex_byte(uint8_t b) {
    const char hex[] = "0123456789ABCDEF";
    putchar_uart(hex[(b >> 4) & 0xF]);
    putchar_uart(hex[b & 0xF]);
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
        if (c >= 32 && c <= 126) putchar_uart(c);
        else putchar_uart('.');
    }
    putchar_uart('\n');
}

// --- Padding ---
uint32_t padded_length(uint32_t len) {
    uint32_t rem = len & (BLOCK_SIZE - 1); // len % 8 pero sin división
    if (rem == 0) return len;
    return len + (BLOCK_SIZE - rem);
}

void copy_and_pad(uint8_t *dst, uint8_t *src, uint32_t len) {
    uint32_t pad_len = padded_length(len);
    for (uint32_t i = 0; i < pad_len; i++) {
        dst[i] = (i < len) ? src[i] : 0;
    }
}

int main(void) {
    // --- Mensaje fijo dentro del código ---
    uint8_t msg[] = "HOLA1234";
    uint32_t msg_len = sizeof(msg) - 1; // sin incluir el '\0'

    // --- Clave fija ---
    uint32_t key[4] = { 
        0x12345678, 
        0x9ABCDEF0, 
        0xFEDCBA98, 
        0x76543210 
    };

    // --- Copiar con padding ---
    uint32_t padded_len = padded_length(msg_len);
    uint8_t buffer[MAX_MSG_SIZE];
    for (uint32_t i = 0; i < MAX_MSG_SIZE; i++) buffer[i] = 0;

    copy_and_pad(buffer, msg, msg_len);

    // --- Mostrar mensaje original ---
    print_string("Mensaje original (hex): ");
    print_buffer_hex(buffer, padded_len);

    print_string("Mensaje original (ASCII): ");
    print_buffer_ascii(buffer, msg_len);

    // --- Cifrado por bloques ---
    for (uint32_t i = 0; i < padded_len; i += 8) {
        uint32_t v[2];
        // Big-endian
        v[0] = ((uint32_t)buffer[i] << 24) | ((uint32_t)buffer[i+1] << 16) |
               ((uint32_t)buffer[i+2] << 8) | (uint32_t)buffer[i+3];
        v[1] = ((uint32_t)buffer[i+4] << 24) | ((uint32_t)buffer[i+5] << 16) |
               ((uint32_t)buffer[i+6] << 8) | (uint32_t)buffer[i+7];

        tea_encrypt(v, key);

        // Guardar de vuelta
        buffer[i]   = (v[0] >> 24) & 0xFF;
        buffer[i+1] = (v[0] >> 16) & 0xFF;
        buffer[i+2] = (v[0] >> 8) & 0xFF;
        buffer[i+3] = v[0] & 0xFF;
        buffer[i+4] = (v[1] >> 24) & 0xFF;
        buffer[i+5] = (v[1] >> 16) & 0xFF;
        buffer[i+6] = (v[1] >> 8) & 0xFF;
        buffer[i+7] = v[1] & 0xFF;
    }

    print_string("Mensaje cifrado (hex): ");
    print_buffer_hex(buffer, padded_len);

    // --- Descifrado ---
    for (uint32_t i = 0; i < padded_len; i += 8) {
        uint32_t v[2];
        v[0] = ((uint32_t)buffer[i] << 24) | ((uint32_t)buffer[i+1] << 16) |
               ((uint32_t)buffer[i+2] << 8) | (uint32_t)buffer[i+3];
        v[1] = ((uint32_t)buffer[i+4] << 24) | ((uint32_t)buffer[i+5] << 16) |
               ((uint32_t)buffer[i+6] << 8) | (uint32_t)buffer[i+7];

        tea_decrypt(v, key);

        buffer[i]   = (v[0] >> 24) & 0xFF;
        buffer[i+1] = (v[0] >> 16) & 0xFF;
        buffer[i+2] = (v[0] >> 8) & 0xFF;
        buffer[i+3] = v[0] & 0xFF;
        buffer[i+4] = (v[1] >> 24) & 0xFF;
        buffer[i+5] = (v[1] >> 16) & 0xFF;
        buffer[i+6] = (v[1] >> 8) & 0xFF;
        buffer[i+7] = v[1] & 0xFF;
    }

    print_string("Mensaje descifrado (hex): ");
    print_buffer_hex(buffer, padded_len);

    print_string("Mensaje descifrado (ASCII): ");
    print_buffer_ascii(buffer, msg_len);

    while (1) { __asm__ volatile("nop"); }
}
