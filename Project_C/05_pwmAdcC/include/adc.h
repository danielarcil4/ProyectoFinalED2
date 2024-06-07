/**
 * @file adc.h
 * @brief Header file for the adc.c file
 */

#include <stdint.h>

// Avoid duplication in code
#ifndef _ADC_H_
#define _ADC_H_

// Definitions and prototypes
#define ADC_GPIO_CH0        26//PIN to use
#define ADC_GPIO_CH1        27//PIN to use
#define ADC_CH0             1 //Select in MUX
#define ADC_CH1             2
#define ADC_MIN_READVALUE   30
void project_adc_init();
uint16_t project_adc_read();

#endif