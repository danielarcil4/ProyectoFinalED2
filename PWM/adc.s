// General definitions
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000

.global adc_init_asm                   // To allow this function to be called from another file
adc_init_asm:                      // Function to initialize the ADC
        push {lr}
        bl releaseResetAdc
        bl EnableAdc        
        pop {pc}

.global adc_gpio_init
adc_gpio_init:
        push {lr}
        MOV r1, #31
        bl gpio_set_function
        bl configurePadControl        
        pop {pc}

.equ    RESETS_BASE, 0x4000c000         // See RP2040 datasheet: 2.14.3 (Subsystem Resets)
.equ    RESET_DONE_OFFSET, 8
.equ    ADC_BITMASK,  1
releaseResetAdc:
    ldr r0, =(RESETS_BASE+ATOMIC_CLR)	// Address for reset controller atomic clr register
	mov r1, #ADC_BITMASK                // Load a '1' into bit 5: IO_Bank0
	str r1, [r0]    	                // Request to clear reset IOBank0
    ldr r0, =RESETS_BASE                // Base address for reset controller
rstAdcdone:     
	ldr r1, [r0, #RESET_DONE_OFFSET]    // Read reset done register
	mov r2, #ADC_BITMASK                 // Load a '1' into bit 5: IO_Bank0
	and r1, r1, r2		                // Check bit IO_Bank0 (0: reset has not been released yet)
	beq rstAdcdone
    bx  lr
/**
 * @brief EnableAdc.
 *
 * Activar AINSEL (mux) y ENABLE 
 */
//.global EnableAdc => Poner global si se llama desde afuera
.equ    BASE_ADC, 0x4004c000
.equ    AINSEL_BITMASK,  4096  //Activar AINSEL adc (bit 12)
.equ    ENABLE_BITMASK,  1 //Activar adc
EnableAdc:
    LDR R0, =(BASE_ADC + ATOMIC_SET)
    LDR R1, =AINSEL_BITMASK
    STR R1, [R0]    //Habilita MUX para lectura de multiples entradas

    LDR R0, =(BASE_ADC + ATOMIC_SET)
    LDR R1, =ENABLE_BITMASK
    STR R1, [R0] //Habilita Enable de ADC
    bx lr


/**
 * @brief configurePadControl.
 *
 */
.equ BASE_PAD_CONTROL, 0x4001c000
.equ ADC_OFFSET, 0x6c
.equ OD_BITMASK, 128
.equ IE_BITMASK, 64
.equ PULLUP_BITMASK, 8
configurePadControl:    
    LDR R0,=(BASE_PAD_CONTROL+ADC_OFFSET+ATOMIC_SET)
    LDR R1,=(OD_BITMASK)
    STR R1,[R0]
    
    LDR R0,=(BASE_PAD_CONTROL+ADC_OFFSET+ATOMIC_CLR)
    LDR R1,=(IE_BITMASK)
    STR R1,[R0]

    LDR R0,=(BASE_PAD_CONTROL+ADC_OFFSET+ATOMIC_SET)
    LDR R1,=(PULLUP_BITMASK)
    STR R1,[R0]
    bx lr


/*
*This funtion return value in R0
*/

.global requestDataAdc
.equ BASE_ADC, 0x4004c000
.equ    ADC_READY_BITMASK, 256
.equ    ADC_DATARESULT_OFFSET, 4
.equ    ONE_SHOT_BITMASK,  4 //activar adc
requestDataAdc:
    LDR R0,=(BASE_ADC+ATOMIC_SET)
    LDR R1,=ONE_SHOT_BITMASK
    STR R1,[R0]

    LDR R0,=(BASE_ADC)
    DATAISREADY:
        LDR R1, [R0]   
        LDR R2,=ADC_READY_BITMASK
        AND R1,R1,R2
        beq DATAISREADY
    TAKEDATA:
        LDR R1, [R0,#ADC_DATARESULT_OFFSET]    // Read DATA READY
        bx lr

.global configClk
.equ BASE_ADC, 0x4004c000
.equ CLK_INT, 100000
.equ CLK_OFFSET, 16
configClk:
    LDR R0,=(BASE_ADC+CLK_OFFSET)
    LDR R1,=CLK_INT
    LSL R1,R1,#8
    STR R1,[R0]
    bx lr