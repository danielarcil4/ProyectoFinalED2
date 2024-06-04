/**
 * @file main.s
 * @brief This is a brief description of the main asm file.
 *
 * Detailed description of the main asm file.
 */

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
.equ    GPIO_FUNC_PWM, 4
.equ    ADC_GPIO_CH0, 26
.equ    ADC_GPIO_CH1, 27
mainasm:
    /* ADC Initialize */
    bl      adc_init_asm
    mov     r0,#ADC_GPIO_CH0    
    bl      adc_gpio_init
    
    /*PWM Initialize*/
    BL      project_pwm_init
    loop:
        bl requestDataAdc //R1 retorna valor
        bl uart_printValueAdc_asm //Se imprime con R1

        mov R0, R1
        bl project_pwm_set_chan_level
        
        LDR R0, =DELAY
        bl delay_asm
        b loop