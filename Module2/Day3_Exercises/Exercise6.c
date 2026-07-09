#include <stdio.h>
#include <stdint.h>

// UART register block 
typedef struct {
    uint32_t CTRL;
    uint32_t STATUS;
    uint32_t TX_DATA;
    uint32_t RX_DATA;
} uart_t;

// Status flags 
#define UART_STATUS_TX_EMPTY  (1 << 0)
#define UART_STATUS_RX_FULL   (1 << 1)

// Control flags
#define UART_CTRL_TX_ENABLE   (1 << 0)
#define UART_CTRL_RX_ENABLE   (1 << 1)

// Initialize UART 
void uart_init(uart_t *uart)
{
    uart->CTRL = UART_CTRL_TX_ENABLE | UART_CTRL_RX_ENABLE;
    uart->STATUS = UART_STATUS_TX_EMPTY;
    uart->TX_DATA = 0;
    uart->RX_DATA = 0;
}

// Transmit one character 
void uart_putchar(uart_t *uart, char c)
{
    if (!(uart->CTRL & UART_CTRL_TX_ENABLE))
        return;

    while (!(uart->STATUS & UART_STATUS_TX_EMPTY)) ;

    uart->TX_DATA = (uint32_t)c;

    printf("%c", c);

    uart->STATUS |= UART_STATUS_TX_EMPTY;
}

// Receive one character 
char uart_getchar(uart_t *uart)
{
    if (!(uart->CTRL & UART_CTRL_RX_ENABLE))
        return 0;

    while (!(uart->STATUS & UART_STATUS_RX_FULL))
        ;

    char c = (char)(uart->RX_DATA & 0xFF);

    uart->STATUS &= ~UART_STATUS_RX_FULL;

    return c;
}

// Simulation helper: inject received data 
void uart_receive_sim(uart_t *uart, char c)
{
    uart->RX_DATA = (uint32_t)c;
    uart->STATUS |= UART_STATUS_RX_FULL;
}

// Test program 
int main()
{
    uart_t uart;

    uart_init(&uart);

    uart_receive_sim(&uart, 'H');
    char a = uart_getchar(&uart);
    uart_receive_sim(&uart, 'i');
    char b = uart_getchar(&uart);
    uart_receive_sim(&uart, '!');
    char c = uart_getchar(&uart);
  
    uart_putchar(&uart, a);
    uart_putchar(&uart, b);
    uart_putchar(&uart, c);
    uart_putchar(&uart, '\n');

    return 0;
}