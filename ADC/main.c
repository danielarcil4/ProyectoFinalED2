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

	return 0;
}