	AREA	ConsoleInput, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start
	MOV R4, #0	;final value will be stored in R4, 
	MOV	R6, #10	;initialise variable and constant
read
	BL	getkey		; read key from console
	CMP	R0, #0x0D  	; while (key != CR)
	BEQ	endRead		; {
	BL	sendchar	;   echo key back to console
	SUB	R0,	R0,	#48	;convert ASCII character to number
	MOV R5, R4		;ARM7 processor doesn't support Rd = operand/Rn
	MUL	R4, R5, R6	;multiply r4 by 10, ie:move previous value one digit left
	ADD	R4,	R4,	R0	;add number to r4

	B	read		; }
	
endRead

stop	B	stop

	END