/**
 * @file main.c
 * @brief This example takes a sample using the ADC channel 0 (GPIO26) and writes it
 * to the PWM slice 0 channel A (GPIO16).
 * 
 * To carry out the example, the user must connect a potentiometer to GND, GPIO26 and VCC33 pins,
 * and a LED in series with a 470-ohm resistor between GPIO16 and GND.
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"

// The header files
#include "main.h"
#include "adc.h"
#include "pwm.h"

/**
 * @brief Main program.
 *
 * This function initializes the MCU and does an infinite cycle.
 */
int main() {
	// STDIO initialization
    stdio_init_all();
	
	// ADC Initialization
    project_adc_init(); //Internamente especifico pines a leer

    // PWM Initialization
    //Motor Izquierda
    project_pwm_init(PWM_GPIO_CH0A, PWM_CHA); //Inicializar PIN 16, canal A
    //Led izquierda
    project_pwm_init(PWM_GPIO_CH0B, PWM_CHB); //Inicializar PIN 17, canal B
    //Motor Derecha
    project_pwm_init(PWM_GPIO_CH1A, PWM_CHA); //Inicializar PIN 18, canal a
    project_pwm_init(PWM_GPIO_CH1B, PWM_CHB); //Inicializar PIN 19, canal B
    
	// Infinite loop to take samples and send them to PWM channel
    while (1) {
        uint16_t adcSample_1;
        uint16_t adcSample_2;

        // Read ADC sample (12-bit: 0 to 4095)
        adcSample_1 = project_adc_read(); //¿Lee el canal 0? ¿O cuál lee realmente?
        //adc_select_input(ADC_CH1); //Me cambio al canal 1
        adcSample_2 = project_adc_read();
        //adc_select_input(ADC_CH0); //En la proxima lectura, empezara en channel 0
        printf("*** ADC channel 0: %d ***\n", adcSample_1);
        printf("*** ADC channel 1: %d ***\n", adcSample_2);
        // Send value to PWM channel A (level: 0 to 4095)
        // But, first guarantee 0% duty for values near zero
        if (adcSample_1 < ADC_MIN_READVALUE)
            adcSample_1 = 0;  
        if (adcSample_2 < ADC_MIN_READVALUE)
            adcSample_2 = 0; 
        project_pwm_set_chan_level((uint)adcSample_1, PWM_GPIO_CH0A); //LEFT
        project_pwm_set_chan_level((uint)adcSample_2, PWM_GPIO_CH1A);//RIGHT

        // Wait for DELAY milliseconds
        sleep_ms(DELAY);
    }
	
    return 0;
}