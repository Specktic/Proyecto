// Prototipos ASM
void tea_encrypt(char *buf, unsigned int len);
void tea_decrypt(char *buf, unsigned int len);
void putchars(char c);
void print_str(const char *s);

// Binary include de msg.txt
extern const char _binary_msg_txt_start[];
extern const char _binary_msg_txt_end[];

int main(void) {
    unsigned int msg_len = _binary_msg_txt_end - _binary_msg_txt_start;
    char buffer[256]; // buffer de trabajo, ajustar según tamaño
    unsigned int i;

    // Copiar mensaje al buffer
    for (i = 0; i < msg_len; i++)
        buffer[i] = _binary_msg_txt_start[i];

    // Llamadas a funciones ASM
    tea_encrypt(buffer, msg_len);
    tea_decrypt(buffer, msg_len);

    // Imprimir resultado
    for (i = 0; i < msg_len; i++)
        putchars(buffer[i]);

    while (1);
    return 0;
}

#define UART0 0x10000000L
void putchars(char c) {
    volatile char *uart = (volatile char *)UART0;
    *uart = c;
}

void print_str(const char *s) {
    while (*s) putchars(*s++);
}
