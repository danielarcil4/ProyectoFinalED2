/**
 * @file pwm.h
 * @brief Header file for the pwm.c file
 */

#include <stdint.h>

// Avoid duplication in code
#ifndef _PWM_H_
#define _PWM_H_

// Definitions and prototypes
#define PWM_GPIO_CH0A        16 //LEFT MOTOR
#define PWM_GPIO_CH0B        17//LEFT LED
#define PWM_GPIO_CH1A        18//RIGHT
#define PWM_GPIO_CH1B        19//RIGHT LED
#define PWM_CHA             0 //Select channel 0 or 1
#define PWM_CHB             1
#define PWM_DIV_INTEGER     128
#define PWM_DIV_FRAC        0
#define PWM_TOP_VALUE       4095
#define PWM_DUTY_ZERO       0

void project_pwm_init(uint, uint);
void project_pwm_set_chan_level(uint, uint);

#endif