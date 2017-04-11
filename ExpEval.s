	AREA	ExpEval, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start
	LDR R4, =0	 
	LDR	R6, =10	;initialise variable and constant
read
	BL	getkey		; read key from console
	CMP	R0, #0x0D  	; while (key != CR)
	BEQ	endRead
	CMP	R0, #0x2B	; did user input +
	BEQ sum
	CMP	R0,	#0x2D	;did user input -
	BEQ	dif
	CMP	R0, #0x2A	;did user input *
	BEQ	pro
	
	BL	sendchar	;   echo key back to console
	
	SUB	R0,	R0,	#48	;convert ASCII character to number
	MOV R5, R4		;ARM7 processor doesn't support Rd = Rn
	MUL	R4, R5, R6	;multiply r4 by 10, ie:move previous value one digit left
	ADD	R4,	R4,	R0	;add number to r4

	B	read		; }

sum	MOV R10, #0		;set R10 to 0, which will represent addition
	BL	sendchar	;send operation character to console
	MOV R7, R4		;store the previous number in an unused register, R7
	B	start		;return to start to repeat the key-reading process for the second operand
dif	MOV R10, #1		;1 represents subtraction (difference)
	BL sendchar
	MOV R7, R4
	B	start
pro	MOV R10, #2
	BL sendchar
	MOV R7, R4
	B	start
	
endRead
	MOV R0, #'='
	BL	sendchar
	CMP	R10, #0	;if operation == addition
	ADDEQ	R5, R7, R4
	CMP R10, #1		;if operation == subtraction
	SUBEQ	R5, R7, R4
	CMP R10, #2		;if operation == multiplication
	MULEQ	R5, R7, R4
	MOV R0, R5
	
	MOV R10, R5
	
	LDR R9, =0		;R9 Stores count, which counts the number of times n can be divided by 10
	CMP R10, #10	;if n is less than 10, we don't need to perform the subsequent operation, we can simply add 48 to the number giving th ASCII value, which can then be printed
	BMI	out
	
	MOV	R8, R10		;R8 Stores previous quotient(iteration's remainder), except in first iteration
	LDR R1, =10		;b=10
aD10
	MOV	R2,	R8	;remainder = a = previous quotient (except for first time)
	LDR	R3, =0	;quotient is 0 at beginning, stored in R3
subtractbQtimes 
	CMP R2, R1	; a-10	
	BMI	break	; if true, a/10 without remainder is now stored in R3		
	ADD R3, R3, #1	
	SUB R2, R2, R1			
	B	subtractbQtimes		
break
	ADD	R9, R9, #1			;count ++
	CMP	R3, #10			;compare a/10 to 10
	BMI	out					;if a is less than 10, finish loop
	MOV R8, R3				; change a to this iteration's quotient
	B	aD10				;Divide a by ten again

out

nDivTenPcount
	LDR	R3,=0	;quotient = 0 at start of each iteration
	
tenPcount
	MOV	R4, R9	;	tencount -> endwh: calculate #10^R9, store in R6
	MOV	R6,	#1
	LDR R12, =10

whilet
	CMP	R4, #0
	BEQ	endwh
	MOV	R11, R6
	MUL	R6, R11, R12
	SUB	R4, R4, #1
	B	whilet
endwh

while
	CMP	R5, R6			;Divide by 10^count
	BMI	breakW
	ADD	R3, R3, #1
	SUB	R5, R5, R6
	B	while

breakW


	MOV R0, R3
	ADD R0, #48
	BL sendchar
	SUB	R9, R9, #1
	CMP R9, #0
	BMI stop
	B	nDivTenPcount

	
stop	B	stop


	END	
