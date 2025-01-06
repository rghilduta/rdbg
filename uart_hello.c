#define UART_BASE 0xFEB50000
#define UART_THR  (*(volatile unsigned char *)(UART_BASE + 0x0))  // Transmitter Holding Register
#define UART_LSR  (*(volatile unsigned char *)(UART_BASE + 0x5))  // Line Status Register
#define UART_LSR_THRE 0x20  // Transmitter Holding Register Empty bit

// Forward declare main
void main(void) __attribute__((section(".text.main")));

// Vector table for ARM
__attribute__((section(".vector_table")))
void (* const vector_table[])(void) __attribute__((used)) = {
    0,  // Stack pointer value (will be set by linker script)
    main // Reset vector
};

// Simple delay function
static void delay(volatile unsigned int count) {
    while(count--) {
        __asm__ volatile("nop");
    }
}

// Initialize UART - in this case, we assume it's already initialized by bootloader/BIOS
static void uart_init(void) {
    // The UART is already initialized by Linux bootloader
    // But if needed, we could add initialization here
}

// Write a single character to UART
static void uart_putc(char c) {
    // Wait until transmitter holding register is empty
    while (!(UART_LSR & UART_LSR_THRE)) {
        __asm__ volatile("nop");
    }
    UART_THR = c;
}

// Write a string to UART
static void uart_puts(const char *str) {
    while (*str) {
        uart_putc(*str++);
    }
}

// Main function - entry point
void main(void) {
    // Initialize hardware
    uart_init();

    // Main loop - continuously print Hello World
    while(1) {
        uart_puts("Hello World!\r\n");
        delay(1000000); // Add delay between prints
    }
}
