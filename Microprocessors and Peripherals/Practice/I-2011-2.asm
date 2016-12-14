.include "m128def.inc"

.def temp = R16
.def a = R17
.def b = R18
.def c = R19
.def ms_counter = R20
.def tms_counter = R21
.def s_counter = R22
.def min_counter = R23
.def mf = R24

.org 0

	rjmp RESET

.org $001E

	rjmp UPDATE_CLOCKS

.org $0100

RESET:

	ldi temp, LOW(RAMEND)
	out SPL, temp
	ldi temp, HIGH(RAMEND)
	out SPH, temp

	clr temp
	out DDRA, temp
	out DDRB, temp
	out DDRC, temp

	sei

SET_TIMER:

	ldi temp, (1<<OCIE0)
	out TIMSK, temp
	ldi temp, (1<<OCF0)
	out TIFR, temp
	ldi temp, 16
	out OCR0, temp

CHECK_SWITCHES_S:

	in a, PINA
	cpi A, 1
	breq START

	in b, PINB
	cpi B, 3
	breq START
	
	in c, PINC
	cpi c, 5
	breq START

	rjmp CHECK_SWITCHES_S

START:

	ldi mf, 2

	ldi temp, (1<<CS00) | (1<<WGM01)
	out TCCR0, temp

CHECK_SWITCHES_E:

	cpi min_counter, 5
	breq FINISH

	in a, PINA
	cpi a, 2
	breq TRUE

	in b, PINB
	cpi b, 4
	breq TRUE

	in c, PINC
	cpi c, 7
	breq TRUE

	rjmp CHECK_SWITCHES_E

TRUE:

	cpi mf, 0
	brne CHECK_SWITCHES_E

FINISH:

	ret
	
UPDATE_CLOCKS:

	cpi mf, 0 ;check if 2 ms have passed (1000 interrupts per second | 1 interrupt = 1ms)
	breq SKIP_1
	dec mf

SKIP_1:

	inc ms_counter
	cpi ms_counter, 10
	brne SKIP_2
	clr ms_counter
	inc tms_counter
	cpi tms_counter, 100
	brne SKIP_2
	clr tms_counter
	inc s_counter
	cpi s_counter, 60
	brne SKIP_2
	clr s_counter
	inc min_counter

SKIP_2:

	reti




	
