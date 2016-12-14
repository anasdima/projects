.include "m128def.inc"
.def temp = R16
.def pina_0 = R17
.def pina_1 = R18
.def pina_2 = R19
.def zero = R0
.def ff = R20
.cseg
.org 0

	rjmp RESET

.org $002A

	rjmp CONV_END

.org $0100

RESET:

	ldi temp, LOW(RAMEND)
	out SPL, temp
	ldi temp, HIGH(RAMEND)
	out SPH, temp

	clr zero

CONF_ADC:

	ldi temp, 0b11001000
	out ADMUX, temp
	ldi temp, (1<<ADEN) | (1<<ADFR) | (1<<ADIF) | (1<<ADIE) \
	| (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)
	out ADCSRA, temp

CONF_PORT:

	clr temp
	out DDRA, temp

	sei

CHECK_PINS:

	in temp, pina

	ldi pina_0, 0b11111110
	ldi pina_2, 0b11111110

	lsl temp
	adc pina_0, zero
	lsl temp
	adc pina_1, zero
	lsl temp
	adc pina_2, zero

	com pina_0
	com pina_2

	and pina_0, pina_1
	or pina_0, pina_2
	cpi pina_0, 1
	brne CHECK_PINS

	sbis ADCSRA,6

	clr ff

SAMPLE:

	cpi ff, 1
	brne SAMPLE

	ret


CONV_END:

	in R12, ADCL
	in R13, ADCH

	ldi ff, 1

	reti


