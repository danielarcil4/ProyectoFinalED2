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
.equ    ADC_CH0, 0
.equ    ADC_GPIO_CH1, 27
//Parametros de la funcion de PWM
.equ PWM_GPIO_CH0A,        16 //LEFT MOTOR
.equ PWM_GPIO_CH0B ,       17//LEFT LED
.equ PWM_GPIO_CH1A  ,      18//RIGHT
.equ PWM_GPIO_CH1B   ,     19//RIGHT LED
.equ PWM_CHA  ,            0 //Select channel 0 or 1
.equ PWM_CHB   ,           1
mainasm:
    /* ADC Initialize */
    bl      adc_init_asm
    mov     r0,#ADC_GPIO_CH0    
    bl      adc_gpio_init
    mov     r0,#ADC_CH0
    bl      adc_set_input_asm
    
    /*PWM Initialize*/
    //Motor Izquiero
    LDR R0, =PWM_GPIO_CH0A //Pin 16
    LDR R1, =PWM_CHA
    BL      project_pwm_init
    //LED Izquierdo
    LDR R0, =PWM_GPIO_CH0B  //Pin 17
    LDR R1, =PWM_CHB
    BL      project_pwm_init
    //Motor Derecho
    LDR R0, =PWM_GPIO_CH1A //Pin 18
    LDR R1, =PWM_CHA
    BL      project_pwm_init
    //LED Derecho
    LDR R0, =PWM_GPIO_CH1B //Pin 19
    LDR R1, =PWM_CHB
    BL      project_pwm_init

    loop:
        //Lectura ADC izquierdo
        bl requestDataAdc //R1 retorna valor
        bl uart_printValueAdc_asm //Se imprime con R1

        mov R0, R1
        MOV R1, #PWM_GPIO_CH0A //Pin 16
        bl project_pwm_set_chan_level
        //Lectura ADC derecho
        bl requestDataAdc //R1 retorna valor
        bl uart_printValueAdc_asm //Se imprime con R1

        mov R0, R1
        MOV R1, #PWM_GPIO_CH1A //Pin 18
        bl project_pwm_set_chan_level
        
        LDR R0, =DELAY
        bl delay_asm
        b loop