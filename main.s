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
.extern adc_init_asm
.extern requestDataAdc
.extern uart_printValueAdc_asm 

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
mainasm:
    bl adc_init_asm
    mov r0,#26
    bl setFunctionGPIO
    bl configurePadControl
    bl EnableAdc
    loop:
        bl requestDataAdc
        bl uart_printValueAdc_asm
        b loop
