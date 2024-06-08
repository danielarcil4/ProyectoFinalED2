/**
 * @file main.s
 * @brief This is a brief description of the main asm file.
 *
 * Detailed description of the main asm file.
 */

.global mainasm              // To be called from another file
.equ DELAY, 0x1523A96
//Derecho
.equ    PWM_GPIO_CHA1,  18
.equ    PWM_GPIO_CHA2,  16
//Izquierdo
.equ    PWM_GPIO_CHA3,  12
.equ    PWM_GPIO_CHA4,  14

.equ    GPIO_FUNC_PWM, 4
.equ    ADC_GPIO_CH0, 28
.equ    ADC_GPIO_CH1, 27
.equ    AINSEL_BITMASK_ADC0,  8192  //Activar AINSEL adc (bit 12)
.equ    AINSEL_BITMASK_ADC1,  4096  //Activar AINSEL adc (bit 13)

mainasm:
    /* ADC Initialize */
    bl      adc_init_asm

    mov     r0,#ADC_GPIO_CH0    
    bl      adc_gpio_init

    mov     r0,#ADC_GPIO_CH1    
    bl      adc_gpio_init

    /*PWM Initialize*/
    //Derecho
    MOV R0, #PWM_GPIO_CHA1
    BL      project_pwm_init

    MOV R0, #PWM_GPIO_CHA2
    BL      project_pwm_init
    //Izquierdo
    MOV R0, #PWM_GPIO_CHA3
    BL      project_pwm_init

    MOV R0, #PWM_GPIO_CHA4
    BL      project_pwm_init

    loop:
        //Lectura Derecha
        LDR R0,=(AINSEL_BITMASK_ADC0)
        MOV R1, #PWM_GPIO_CHA1
        MOV R2, #PWM_GPIO_CHA2
        bl DoAll
        //Lectura Izquierda
        LDR R0,=(AINSEL_BITMASK_ADC1)
        MOV R1, #PWM_GPIO_CHA3
        MOV R2, #PWM_GPIO_CHA4
        bl DoAll
        //Delay
        LDR R0, =DELAY
        LSR R0, R0, #2
        bl delay_asm
        b loop
    
DoAll:
    PUSH {R1,R2,LR} //Pin 1, pin 2
    bl requestDataAdc //R1 retorna valor    
    bl CompareVal//R1 < MIN ? R1 : 0

    push {R1}
    bl uart_printValueAdc_asm //Se imprime con R1
    pop {R1}//Valor ADC

    POP {R0}//Pin 1

    PUSH {R1} //Guardo Valor del ADC
    bl project_pwm_set_chan_level
    POP {R1} //Valor adc

    POP {R0} //PIN 2
    bl project_pwm_set_chan_level
    POP {PC}
    