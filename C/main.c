#include <stdint.h>

// Assembly functions (defined in tea_encrypt.asm and tea_decrypt.asm)
extern void tea_encrypt(uint32_t *v, uint32_t *key);
extern void tea_decrypt(uint32_t *v, uint32_t *key);

// Assembly function to print a string to UART
extern void putchars(const char *s);

void main(void) {
    uint32_t v[2] = {0x12345678, 0x9ABCDEF0};   // test block
    uint32_t key[4] = {0x11111111, 0x22222222, 0x33333333, 0x44444444}; // test key

    putchars("Starting TEA test...\n");

    tea_encrypt(v, key);
    putchars("Encryption called.\n");

    tea_decrypt(v, key);
    putchars("Decryption called.\n");

    putchars("End of TEA test.\n");
    while (1); // loop forever to avoid exit
}

