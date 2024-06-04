/**
 * @file adc.c
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/adc.h"

// ADC header file
#include "adc.h"

// ADC initialization for the project
void project_adc_init() {
    // Initializes ADC
	adc_init();
    // Disable Input and pullups
    adc_gpio_init(ADC_GPIO_CH0); //First ADC

    adc_gpio_init(ADC_GPIO_CH1); //Second ADC
    // Select channel for ADC conversion
    adc_select_input(ADC_CH0); //It will begin reading the first channel
    adc_select_input(ADC_CH1); //It will begin reading the first channel

    
    // Select channel for ADC conversion
    //adc_select_input(ADC_CH1);
}

// ADC initialization for the project
uint16_t project_adc_read() {
    // Read 12-bit sample
    return adc_read();
}