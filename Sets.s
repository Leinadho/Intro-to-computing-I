	AREA	Sets, CODE, READONLY
	IMPORT	main
	EXPORT	start

start

		LDR R5, =AElems		;load to R5 the start address of AElems
		LDR R0, [R5]		;R0=M[R0]

		LDR R6, =BElems		;load to R6 the address of BElems
		LDR R1, [R6]		;R1=M[R6]

		LDR R2, =0			;AinB=R2=0
		LDR R3, =0			;ACOUNT=0
		LDR R4, =0		;BCOUNT=0

		LDR R7, =CElems
		LDR	R8, =ASize		;load address of ASize to R8  
		LDR R8, [R8]
		LDR R9, =BSize 		;R3= M[R3]
		LDR R9, [R9]
		LDR R10, =0		

iterationA

		CMP R3, R8        															;confident
		BEQ NEXT   																	;confident
		
		LDR R6, =BElems		;reset B_address for next iteration						confident
		LDR R1, [R6]		;reset elementB to first e in B							confident
		
		LDR R4, =0 			;RESET COUNT  	BCOUNT=0								confident
		LDR R2, =0			;RESET AinB		AinB=0									confident
		
;THE LOOP BELOW ITERATES THROUGH ALL ELEMENTS OF B, COMPARING THEM TO A, INCREMENTING AinB (setting to true) IF ANY ELEMENT B[i]= THE CURRENT ELEMENT OF A
iterateB
			CMP R4, R9			;does BCOUNT=BSize?										confident
			BEQ breakB          ;end while loop if B has been fully iterated through	confident
			CMP R2,#1			;has elementA been found in B?	(AinB==true?)			confident
			BEQ breakB			;if yes stop iteration through B						confident

			CMP R0, R1			;compare elementA and elementB							confident
			BNE skip		    ;if equal:												confident
			LDR R2, =1			;	AinB = true											confident

skip	ADD R6, R6, #4		;BAddress-> next word									confidentish (as long as)
			LDR R1, [R6]		;elementB= next element									confident
			ADD R4, R4, #1		;increment Bcount										confident
			B iterateB
			
breakB	CMP R2, #0			;if AinB==true:											confident
		STREQ R0, [R7] 		;if equal add elementA to C								;unsure of syntax
		ADDEQ R10, R10, #1	;if equal Ccount++
		ADDEQ R7, R7, #4	;if equal CAddress++									; does flag change?	
		
		ADD R5, R5, #4		;AAddress-> next word									confident
		LDR R0, [R5]		;load next value of elementA to R0						confident
		ADD R3, R3, #1																;confident
		B iterationA

NEXT
	LDR R5, =AElems
	LDR R6, =BElems
	LDR R0, [R5]
	LDR R1, [R6]
	LDR R2, =0
	LDR R3, =0
	LDR R4, =0
	
iterationB

		CMP R4, R9   		;if Bcount=Bsize    
		BEQ finish  					
		
		LDR R5, =AElems		;reset A_address for next iteration		
		LDR R0, [R5]		;reset elementA to first e in A				
		
		LDR R3, =0 			;RESET COUNT  	ACOUNT=0		
		LDR R2, =0			;RESET AinB		AinB=0			

iterateA
			CMP R3, R8			;does ACOUNT=ASize?			
			BEQ breakA          ;end while loop if A has been fully iterated through	
			CMP R2,#1			;has elementB been found in A?	(AinB==true?)		
			BEQ breakA			;if yes stop iteration through B				

			CMP R0, R1			;compare elementA and elementB		
			BNE skipp		    ;if equal:		
			LDR R2, =1			;	AinB = true		

skipp		
			ADD R5, R5, #4		;BAddress-> next word	
			LDR R0, [R5]		;elementB= next element		
			ADD R3, R3, #1		;increment Acount
			B iterateA
			
breakA	CMP R2, #0			;if AinB==true:											
		STREQ R1, [R7] 		;if equal add elementB to C								
		ADDEQ R10, R10, #1	;if equal Ccount++
		ADDEQ R7, R7, #4	;if equal CAddress++									

		ADD R6, R6, #4		;BAddress-> next word									
		LDR R1, [R6]		;load next value of elementB to R1						
		ADD R4, R4, #1		;BCount++										
		B iterationB
		
finish
;The below instructions are just for debugging: they put all the elements and size of C in the registers at the end. 
		LDR R9, =CSize
		STR R10, [R9]
		LDR R0, =CElems
		LDR R1, [R0]
		ADD R0, R0, #4
		LDR R2, [R0]
		ADD R0, R0, #4
		LDR R3, [R0]
		ADD R0, R0, #4
		LDR R4, [R0]
		ADD R0, R0, #4
		LDR R5, [R0]
		ADD R0, R0, #4
		LDR R6, [R0]
		ADD R0, R0, #4
		LDR R7, [R0]
		ADD R0, R0, #4
		LDR R8, [R0]
		ADD R0, R0, #4
		LDR R9, [R0]
		ADD R0, R0, #4
		LDR R10 , [R0]
		ADD R0, R0, #4
		LDR R11, [R0]
		LDR R10, =CSize
		LDR R10, [R10]
stop	B	stop


	AREA	TestData, DATA, READWRITE
	
ASize	DCD	6			; Number of elements in A
AElems	DCD	4,8,15,16,23,42	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD	13,9,1,9,5,8		; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE	56			; Elements of C

	END	
