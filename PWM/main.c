/**
 * @file main.c
 * @brief This is a brief description of the main C file.
 *
 * Detailed description of the main C file.
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "main.h"
#include "hardware/pwm.h"
// Include your own header files here

/**
 * @brief Main program.
 *
 
 * This function initializes the MCU and does an infinite cycle.
 */
int main() {
	// STDIO initialization
    stdio_init_all();
	
	mainasm();
	
}

#include "hardware/pwm.h"

// Wrapper function for assembly call
// Wrapper function for assembly call
void gpio_set_function_wrapper(uint gpio, uint function) {
    gpio_set_function(gpio, function);
}

uint pwm_gpio_to_slice_num_wrapper(uint gpio) {
    return pwm_gpio_to_slice_num(gpio);
}

void pwm_set_clkdiv_int_frac_wrapper(uint slice_num, uint8_t div_int, uint8_t div_frac) {
    pwm_set_clkdiv_int_frac(slice_num, div_int, div_frac);
}

void pwm_set_wrap_wrapper(uint slice_num, uint16_t wrap) {
    pwm_set_wrap(slice_num, wrap);
}

void pwm_set_chan_level_wrapper(uint slice_num, uint chan, uint16_t level) {
    pwm_set_chan_level(slice_num, chan, level);
}

void pwm_set_enabled_wrapper(uint slice_num, bool enabled) {
    pwm_set_enabled(slice_num, enabled);
}