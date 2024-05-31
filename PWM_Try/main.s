/**
 * @file main.s
 * @brief This is a brief description of the main asm file.
 *
 * Detailed description of the main asm file.
 */
.extern uart_printMsgLED_asm
.extern gpio_init_asm
.extern gpio_set_dir_asm
.extern gpio_put_asm
.extern delay_asm

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
mainasm:
    bl adc_init_asm
    loop:
        bl requestDataAdc
        bl uart_printValueAdc_asm
        b loop
