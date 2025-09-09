/* C/main.c  --  bare-metal RV64 sin includes */

/* símbolos del objeto binario (generado desde msg.txt) */
extern const unsigned char _binary_msg_txt_start[];
extern const unsigned char _binary_msg_txt_end[];

/* prototipos */
void putchars(unsigned char c);

/* función que recorre el buffer y lo imprime byte a byte */
int main(void) {
    const unsigned char *p = _binary_msg_txt_start;
    const unsigned char *end = _binary_msg_txt_end;

    while (p < end) {
        putchars(*p++);
    }

    /* quédese aquí */
    while (1) { }
    return 0;
}

/* UART base (dirección usada por QEMU 'virt') */
#define UART0 0x10000000UL

void putchars(unsigned char c) {
    volatile unsigned char *uart = (volatile unsigned char *)UART0;
    *uart = c;
}
