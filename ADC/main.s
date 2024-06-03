/**
 * @file main.s
 * @brief This is a brief description of the main asm file.
 *
 * Detailed description of the main asm file.
 */

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
mainasm:
<<<<<<< HEAD:ADC/main.s
    bl      adc_init_asm
    mov     r0,#26
    bl      adc_gpio_init
    //bl      configurePadControl => Se puede ubicar después de la func anterior
    bl      EnableAdc
    bl      configClk
=======
    bl adc_init_asm
    mov r0,#26
    bl setFunctionGPIO
    bl configurePadControl
    bl EnableAdc
    bl configClk
>>>>>>> a2ee552ddd7841bdc257d1e7cb3072ed7067b88e:main.s
    loop:
        bl requestDataAdc
        bl uart_printValueAdc_asm
        b loop