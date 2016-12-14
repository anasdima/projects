.include "m128def.inc"
.def temp = R16
.def number = R17
.def number_temp = R22
.def zero = R0
.def counter= R18
.def parity = R19
.def paritybit = R20
.def transmit_counter = R21
.def ff = R23
.cseg
.org 0

	rjmp RESET

.org $001C

	rjmp TIMER1OVF

.org $0100

RESET:

	ldi temp, LOW(RAMEND)
	out SPL, temp
	ldi temp, HIGH(RAMEND)
	out SPH, temp

	clr zero
	ldi number, 0b00111001

	ser temp
	out DDRA, temp
	ldi temp, 1
	out PORTA, temp

	clr parity
	clr paritybit
	clr transmit_counter
	clr ff

	ldi counter, 8
	mov number_temp, number

LOOP:

	lsl number_temp

	adc parity, zero
	
	dec counter
	brne LOOP

	sbrc parity, 0
	ldi paritybit, 1

	mov number_temp, number

SET_TCNT1:

	ldi temp, 1<<TOV1
	out TIFR, temp
	ldi temp, 1<<TOIE1
	out TIMSK, temp
	ldi temp, (1<<CS10) | (1<<CS11)
	out TCCR1B, temp

	sei

TRANSMIT:

	cpi ff, 1
	brne TRANSMIT

	ret
;-------------------------

TIMER1OVF:

	clr temp

	cpi transmit_counter, 0
	breq START_BIT

	cpi transmit_counter, 9
	breq PARITY_BIT

	cpi transmit_counter, 10
	breq STOP_BIT

	cpi transmit_counter, 11
	breq FINISH_FLAG

	lsl number_temp
	adc temp, zero
	out PORTA, temp

	inc transmit_counter
	reti

START_BIT:

	clr temp
	out PORTA, temp

	reti

PARITY_BIT:

	out PORTA, paritybit

	reti

STOP_BIT:

	ldi temp, 1
	out PORTA, temp

	reti

FINISH_FLAG:

	ldi ff, 1
	reti

