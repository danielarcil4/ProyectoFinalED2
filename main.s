/**
 * @file main.s
 * @brief This is a brief description of the main asm file.
 *
 * Detailed description of the main asm file.
 */

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
mainasm:
    bl adc_init_asm
    mov r0,#26
    bl setFunctionGPIO
    bl configurePadControl
    bl EnableAdc
    bl configClk
    loop:
        bl requestDataAdc
        bl uart_printValueAdc_asm
        b loop
