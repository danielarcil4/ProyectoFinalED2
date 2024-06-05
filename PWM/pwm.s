//.equ    PWM_GPIO_CHA,        16
.equ    GPIO_FUNC_PWM,       4
.equ    PWM_CHA,             0
.equ    PWM_CHB,             1
.equ    PWM_DIV_INTEGER,     128
.equ    PWM_DIV_FRAC,        0
.equ    PWM_TOP_VALUE,       4095
.equ    PWM_DUTY_ZERO,       0

// Add .extern statements for the necessary functions
/**
 * @brief project_pwm_init.
 *
 *	Configurar Puerto PWM
 *  Parameters:
 *  R0: PIN value: PWM_GPIO_CH0A (16) or PWM_GPIO_CH0B (17)
 *		 or PWM_GPIO_CH1A (18) or PWM_GPIO_CH1B (19)
 *  R1: Channel value: PWM_CHA(0) or PWM_CHB (1)
 */
.global project_pwm_init

project_pwm_init:
    push {R0, R1, lr}
	
    //MOV R0, #PWM_GPIO_CHA
    MOV R1, #GPIO_FUNC_PWM
    bl  gpio_set_function_asm // Initialize function PWM for GPIO: PWM_GPIO_CHXX
	
	pop {R0} //R0= PWM_GPIO_CHXX 
    bl  pwm_gpio_to_slice_num_wrapper // Determine the PWM slice connected to GPIO: PWM_GPIO_CHXX
	//RETORNA!! R0 = sliceNum. Se debe garantizar que no se pierda

    mov R1, #PWM_DIV_INTEGER
    mov R2, #PWM_DIV_FRAC
	push {R0} //Guardar Slice Num
	//MOV R4, R0 //Almaceno en R4 el valor de R0
    bl  pwm_set_clkdiv_int_frac_wrapper //Set period for frequency divisor
	pop {R0}
	
	push {R0}
    LDR R1, =PWM_TOP_VALUE  
    bl  pwm_set_wrap_wrapper // Set top (wrap) value (Determines the frequency)
	pop {R0,R1} //R1 = PWM_CHXX
	
	push {R0}
    //mov r1, #PWM_CHA => R1 Se pasa como parametro
    mov r2, #PWM_DUTY_ZERO 
    bl  pwm_set_chan_level_wrapper  // Set zero duty
	pop {R0}
	
    mov R1, #1 //Set true
    bl pwm_set_enabled_wrapper  // Enable PWM

    pop {pc}
	
.global project_pwm_set_chan_level

/**
 * @brief project_pwm_set_chan_level.
 *
 * This function selects function SIO for GPIOx
 * Parameters:
 *  R0: adc value => 0 to 4095?
 *  R1: Channel value: PWM_GPIO_CHXX (16 or 18)
 */
 project_pwm_set_chan_level:
 	PUSH {r0, LR} //Guardar Value
	
 	bl pwm_gpio_to_slice_num_wrapper

	//R0 = SliceNum
	MOV R1, #PWM_CHA
	POP {R2} //R2 = Value	
	PUSH {R0, R2} //Guarda sliceNum y Value
	bl pwm_set_chan_level_wrapper//(sliceNum, PWM_CHXX, value)

	POP {R0,R2} //Extraer sliceNum y Value
	MOV R1, #PWM_CHB
	PUSH {R0} //Guardar sliceNum
	bl pwm_set_chan_level_wrapper

	//Imprimir valores
	bl pwm_get_counter_wrapper
	MOV R1, R0 //Almacena en R1 el PWM value. R1 es el parametro para uart_printValuePWM
	bl uart_printValuePWM_asm //R1 = PWM value
	POP {PC}
 
