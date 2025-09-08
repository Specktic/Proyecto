// Prototipos
void putchars(char c);
void print_str(const char *s);

// Punto de entrada en C
int main(void) {
    print_str("Hello\n");
    while (1);   // Bucle infinito
    return 0;
}

// Dirección base del UART en QEMU (virt machine)
#define UART0 0x10000000L

void putchars(char c) {
    volatile char *uart = (volatile char *)UART0;
    *uart = c;
}

void print_str(const char *s) {
    while (*s) {
        putchars(*s++);
    }
}
