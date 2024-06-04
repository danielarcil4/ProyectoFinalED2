/**
 * @file pwm.c
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/pwm.h"

// PWM header file
#include "pwm.h"

// PWM initialization for the project
void project_pwm_init(uint PWM_GPIO_CHXX,uint PWM_CHXX) {
    // Initialize function PWM for GPIO: PWM_GPIO_CHXX
    gpio_set_function(PWM_GPIO_CHXX, GPIO_FUNC_PWM);
    // Determine the PWM slice connected to GPIO: PWM_GPIO_CHXX
    uint sliceNum = pwm_gpio_to_slice_num(PWM_GPIO_CHXX);
    // Set period for frequency divisor
    pwm_set_clkdiv_int_frac(sliceNum, PWM_DIV_INTEGER, PWM_DIV_FRAC); // What frequency enters to the PWM?
    // Set top (wrap) value (Determines the frequency)
    pwm_set_wrap(sliceNum, PWM_TOP_VALUE);
    // Set zero duty
    pwm_set_chan_level(sliceNum, PWM_CHXX, PWM_DUTY_ZERO);
    // Enable PWM
    pwm_set_enabled(sliceNum, true);    
}

// PWM counter compare level changer
void project_pwm_set_chan_level(uint value, uint PWM_GPIO_CHXX) {
    // Determine the PWM slice connected to GPIO: PWM_GPIO_CHA
    uint sliceNum = pwm_gpio_to_slice_num(PWM_GPIO_CHXX);
    //NOTA!!: En realidad los slices los configuro IGUALES

    // Determine the PWM slice connected to GPIO: PWM_GPIO_CHB
    //uint sliceNum_2 = pwm_gpio_to_slice_num(PWM_GPIO_CHB);

    // Set duty for both channels (Motor and LED)
    pwm_set_chan_level(sliceNum, PWM_CHA, value); 
    pwm_set_chan_level(sliceNum, PWM_CHB, value);

    printf("*** PWM channel: %d ", pwm_get_counter(sliceNum));
}