.equ    PWM_GPIO_CHA,        16
.equ    GPIO_FUNC_PWM,       4
.equ    PWM_CHA,             0
.equ    PWM_DIV_INTEGER,     128
.equ    PWM_DIV_FRAC,        0
.equ    PWM_TOP_VALUE,       4095
.equ    PWM_DUTY_ZERO,       0

// Add .extern statements for the necessary functions
.extern __gpio_set_function
.extern pwm_gpio_to_slice_num
.extern pwm_set_clkdiv_int_frac
.extern pwm_set_wrap
.extern pwm_set_chan_level
.extern pwm_set_enabled
.global project_pwm_init

project_pwm_init:
    push {lr}
	
    MOV R0, #PWM_GPIO_CHA
    MOV R1, #GPIO_FUNC_PWM
	push {R0}
    bl  gpio_set_function // Initialize function PWM for GPIO: PWM_GPIO_CHA
	
	pop {R0}
    bl  pwm_gpio_to_slice_num // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
	//R0 = sliceNum. Se debe garantizar que no se pierda
    mov R1, #PWM_DIV_INTEGER
    mov R2, #PWM_DIV_FRAC
	push {R0} //Para no perder sliceNum
	//MOV R4, R0 //Almaceno en R4 el valor de R0
    bl  pwm_set_clkdiv_int_frac //Set period for frequency divisor
	pop {R0}
	
	push {R0}
    LDR R1, =PWM_TOP_VALUE  
    bl  pwm_set_wrap // Set top (wrap) value (Determines the frequency)
	pop {R0}
	
	push {R0}
    mov r1, #PWM_CHA
    mov r2, #PWM_DUTY_ZERO 
    bl  pwm_set_chan_level  // Set zero duty
	pop {R0}
	
    mov R1, #1 //Set true
    bl pwm_set_enabled  // Enable PWM

    pop {pc}
	
.global project_pwm_set_chan_level

/**
 * @brief adc_gpio_init.
 *
 * This function selects function SIO for GPIOx
 * Parameters:
 *  R0: value
 */
 project_pwm_set_chan_level:
 	PUSH {r0, LR}
	
	MOV r0, #PWM_GPIO_CHA
 	bl pwm_gpio_to_slice_num
	//sliceNum = r0
	MOV R1, #PWM_CHA
	POP {R2}
	bl pwm_set_chan_level
	POP {PC}
 
