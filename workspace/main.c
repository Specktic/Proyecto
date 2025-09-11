// main.c - Proyecto C bare-metal con salida semihosting
#include <stdint.h>

#define BLOCK_SIZE 8    // 64 bits
#define MAX_MSG_SIZE 256

#define UART0 0x10000000
#define UART0_REG (*(volatile uint8_t*)UART0)

// Funciones de ensamblador
void tea_encrypt(uint8_t *msg, uint32_t key[4]);
void tea_decrypt(uint8_t *msg, uint32_t key[4]);

// Símbolos generados desde msg.txt convertido a objeto
extern uint8_t _binary_msg_txt_start[];
extern uint8_t _binary_msg_txt_end[];

// Función para calcular tamaño con padding
uint32_t padded_length(uint32_t len) {
    return (len + BLOCK_SIZE - 1) & ~(BLOCK_SIZE - 1);
}

// Copia mensaje y aplica padding (relleno con ceros)
void copy_and_pad(uint8_t *dst, uint8_t *src, uint32_t len) {
    uint32_t pad_len = padded_length(len);
    for (uint32_t i = 0; i < pad_len; i++) {
        dst[i] = (i < len) ? src[i] : 0;
    }
}

// Imprimir un carácter usando UART
void putchar_uart(uint8_t c) {
    UART0_REG = c;  // Escribir byte al UART
}


// Imprimir un buffer de bytes como caracteres
void print_buffer(uint8_t *buf, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        putchar_uart(buf[i]);
    }
}

//imprime buffer como hexadecimal
void print_buffer_hex(uint8_t *data, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        uint8_t b = data[i];
        uint8_t hi = (b >> 4) & 0xF;
        uint8_t lo = b & 0xF;
        putchar_uart(hi < 10 ? '0'+hi : 'A'+hi-10);
        putchar_uart(lo < 10 ? '0'+lo : 'A'+lo-10);
        putchar_uart(' ');
    }
    putchar_uart('\n');
}

int main(void) {
    uint8_t *msg = _binary_msg_txt_start;
    uint32_t msg_len = _binary_msg_txt_end - _binary_msg_txt_start;

    // Clave de 128 bits configurable
    uint32_t key[4] = {0x12345678, 0x9ABCDEF0, 0xFEDCBA98, 0x76543210};

    // Buffer con padding
    uint8_t buffer[MAX_MSG_SIZE];
    copy_and_pad(buffer, msg, msg_len);
    uint32_t padded_len = padded_length(msg_len);

    // Mostrar mensaje original
    print_buffer(buffer, padded_len);

    // Cifrar
    tea_encrypt(buffer, key);
    print_buffer_hex(buffer, padded_len);
    putchar_uart('\n');

    // Descifrar
    tea_decrypt(buffer, key);
    print_buffer(buffer, padded_len);
    putchar_uart('\n');

    // Loop infinito para que QEMU no salga
    while (1) { }

    return 0;
}
