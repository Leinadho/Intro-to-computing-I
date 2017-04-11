	AREA	Lotto, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR	R1, =TICKETS

stop	B	stop 



	AREA	TestData, DATA, READWRITE
	
COUNT	DCD	3			; Number of Tickets
TICKETS	DCB	3, 8, 11, 21, 22, 31	; Tickets
	DCB	7, 23, 25, 28, 29, 32
	DCB	10, 11, 12, 22, 26, 30
	

DRAW	DCB	10, 11, 12, 22, 26, 30	; Lottery Draw

MATCH4	DCD	0
MATCH5	DCD	0
MATCH6	DCD	0

	END	
