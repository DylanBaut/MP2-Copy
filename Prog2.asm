;partners: dylanjb5, aadim2
; The code presented below completes the reverse polish notation stack calculator. My part of the code reads and echos a character each time, detecting if theres an equal sign or space. Spaces are ignored, while equals signs branches off to test if the STACK_TOP and STACK_START differ by 1. If this is not the case, it prints an error using predefined stored data. If this is the case, the value is popped and then loaded into R5 and R3 to be printed to the screen in hexadecimal. The subroutine that accomplishes this was created last MP. Other characters will be sorted via ASCII tests between operators or operands. If it is an operator, it will pop two values and store them in R3 and R4 to be the inputs for the corresponding operator's subroutine. The result will be pushed to the stack. If the R5 POP flag is 1 during any of this, it branches to INVALID. After failing all operator tests, the character will be pushed to the stack and then the next input will be read.
;
.ORIG x3000

;R0 - character input from keyboard
;R1 - temp 
;R3, R4- popped values/inputs for subroutines
;R5 - flag

EVALUATE

READCHAR
		
		TRAP x23				; IN (read and echo character from keyboard)
		LD R1, NEG_EQUAL		; Test if input is equal sign
		ADD R1, R0, R1
		BRz EQUAL				; If equal, branch to EQUAL
		LD R1, NEG_SPACE		; Test if input is space
		ADD R1, R0, R1
		BRz READCHAR			; if its a space, ignore and read next input

		LD R1, NEG_STAR			; Test if input is star
		ADD R1, R0, R1
		BRnp TEST_PLUS			; if it isnt, branch to TEST_PLUS
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID	
		AND R3, R3, #0			; Load popped value into R3
		ADD R3, R3, R0
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R4, R4, #0			; Load popped value into R4
		ADD R4, R4, R0
		JSR MUL					; Multiply popped values
		JSR PUSH				; Push result
		BR READCHAR				; Read next character
TEST_PLUS		
		LD R1, NEG_PLUS			; Test if input is plus sign
		ADD R1, R0, R1			
		BRnp TEST_MIN			; if it isnt, branch to TEST_MIN
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R3, R3, #0			; Load popped value into R3
		ADD R3, R3, R0
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R4, R4, #0			; Load popped value into R4
		ADD R4, R4, R0
		JSR PLUS				; ADD popped values
		JSR PUSH				; Push result
		BR READCHAR				; Read next character
TEST_MIN
		LD R1, NEG_MIN			; Test if input is minus sign
		ADD R1, R0, R1
		BRnp TEST_SLASH			; if it isnt, branch to TEST_SLASH
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R3, R3, #0			; Load popped value into R3
		ADD R3, R3, R0
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R4, R4, #0			; Load popped value into R4
		ADD R4, R4, R0
		JSR MIN					; Subtract popped values
		JSR PUSH				; Push result
		BR READCHAR				; Read next character
TEST_SLASH
		LD R1, NEG_SLASH		; Test if input is slash
		ADD R1, R0, R1
		BRnp TEST_CARET			; if it isnt, branch to TEST_CARET
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R3, R3, #0			; Load popped value into R3
		ADD R3, R3, R0
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R4, R4, #0			; Load popped value into R4
		ADD R4, R4, R0
		JSR DIV					; Divide popped values
		JSR PUSH				; Push result
		BR READCHAR				; Read next character
TEST_CARET
		LD R1, NEG_CARET		; Test if input is CARET
		ADD R1, R0, R1
		BRnp OPERAND			; if it isnt, branch to OPERAND
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R3, R3, #0			; Load popped value into R3
		ADD R3, R3, R0
		JSR POP					; POP a value
		ADD R5, R5, #0			; If R5 flag is 1, branch to INVALID
		BRnp INVALID
		AND R4, R4, #0			; Load popped value into R4
		ADD R4, R4, R0
		JSR EXP					; EXPONENT popped values
		JSR PUSH				; Push result
		BR READCHAR				; Read next character
OPERAND
		LD R1, OFFSET			; Account for ASCII offset of numbers
		ADD R0, R1, R0
		JSR PUSH				; push operand into stack
		BR READCHAR				; Read next character


EQUAL	
		LD R4, STACK_START		; Load STACK positions into R3 and R4
		LD R3, STACK_TOP
		JSR MIN					; Subtract STACK positions
		ADD R0, R0, #-1			; Subtract one from difference
		BRnp INVALID			; If the difference was not 1, branch to invalid
		JSR POP					; POP a value
		AND R5, R5, #0			; Clear R5
		ADD R5, R5, R0			; R5 and R3 get value of R0
		AND R3, R3, #0
		ADD R3, R3, R5
		JSR PRINT_HEX			; print hexadecimal of value within R3


INVALID
		LD R0, capI_let			; Load the ASCII values into R0 and output them to
		TRAP x21				; spell INVALID EXPRESSION
		LD R0, n_let
		TRAP x21
		LD R0, v_let
		TRAP x21
		LD R0, a_let
		TRAP x21
		LD R0, l_let
		TRAP x21
		LD R0, i_let
		TRAP x21
		LD R0, d_let
		TRAP x21
		LD R0, SPACE
		TRAP x21
		LD R0, capE_let
		TRAP x21
		LD R0, x_let
		TRAP x21
		LD R0, p_let
		TRAP x21
		LD R0, r_let
		TRAP x21
		LD R0, e_let
		TRAP x21
		LD R0, s_let
		TRAP x21
		TRAP x21
		LD R0, i_let
		TRAP x21
		LD R0, o_let
		TRAP x21
		LD R0, n_let
		TRAP x21
		BR STOP_PROG


EVALUATE_SaveR7	.BLKW #1
NEG_EQUAL 		.FILL xFFC3
NEG_SPACE 		.FILL #-32
NEG_STAR		.FILL xFFD6
NEG_PLUS		.FILL xFFD5
NEG_MIN			.FILL xFFD3
NEG_SLASH		.FILL xFFD1
NEG_CARET		.FILL xFFA2
OFFSET			.FILL #-48
SPACE  			.FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D
capI_let		.FILL #73
n_let			.FILL #110
v_let			.FILL #118
a_let			.FILL #97
l_let			.FILL #108
i_let			.FILL #105
d_let			.FILL #100
capE_let		.FILL #69
x_let			.FILL #120
p_let			.FILL #112
r_let			.FILL #114
e_let			.FILL #101
s_let			.FILL #115
o_let			.FILL #111
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX
			AND R2, R2, #0			; zero out R2
			ADD R2, R2, #4			; Add 4 to R2 for the number of digits


PRINTDIGIT	BRnz STOP_PROG	 		; if 4 digits have been printed, branch to STOP
			AND R1, R1, #0			; zero out R1
			AND R0, R0, #0			; zero out R0
BIT			ADD R1, R1, #-3			; Test if R1, the bit counter, is 3 or less
			BRp FOURBIT 			; if not, move to FOURBIT
			ADD R1, R1, #3			; reverse test subtraction
			ADD R0, R0, R0			; shift digit left
			ADD R3, R3, #0			; test if R3 is less than 0
			BRzp POSITIVE 			; if R3 is positive, the MSB is 0 and branch to positive
			ADD R0, R0, #1			; if R3 is negative, the MSB is 1 so add 1 to digit
POSITIVE	ADD R3, R3, R3			; shift R3 left
			ADD R1, R1, #1			; increment bit counter
			BRnzp BIT				; branch back to BIT
FOURBIT		LD R1, FOURTYEIGHT 		; R1 gets the value of 48, the ASCII distance to '0'
			ADD R0, R0, #-9			; test if digit is less than or equal to 9
			BRnz LESSNINE 			; if it is, Branch to LESSNINE
			ADD R0, R0, #7			; if it isnt, add ASCII distance to 'A'
LESSNINE	ADD R0, R0, #9			; reverse testing subtraction
			ADD R0, R1, R0			; Add 48 to digit
			TRAP x21; OUT
			ADD R2, R2, #-1			; decrement digit counter
			BRnzp PRINTDIGIT 		;


FOURTYEIGHT	.FILL #48; ASCII distance to '0'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;input R3, R4
;out R0
PLUS	
	ADD R0, R3, R4		; ADD R3 and R4 and store result in R0
	RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 R4-R3
;out R0
MIN	
	ST R3, MIN_SaveR3	; Save R3
	NOT R3, R3
	ADD R3, R3, #1		; Form twos complement of R3
	ADD R0, R3, R4		; Add negated R3 and R4, store result in R0
	LD R3, MIN_SaveR3	; Restore R3
	RET
	
MIN_SaveR3	.BLKW #1 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0

MUL	 
	AND R0, R0, #0		; Clear R0
	ST R4, MUL_SaveR4	; Save R4
MU
	ADD R4, R4, #-1		; decrement R4
	BRn LEAVE			; If R4 is now negative, exit
	ADD R0, R0, R3		; ADD R3 and R0
	BR MU
LEAVE
	LD R4, MUL_SaveR4	; Restore R4
	RET

MUL_SaveR4 .BLKW #1	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 ??? R3/R4
;out R0
DIV	
	AND R0, R0, #0		; Clear R0
DI
	ST R0, DIV_SaveR0	; Caller save R0
	ST R7, DIV_SaveR7	; Caller save R7
	JSR MIN				; Subtract R3 from R4
	LD R7, DIV_SaveR7	; Restore R7
	AND R4, R4, #0		; R4 will get the difference R0	
	ADD R4, R4, R0
	LD R0, DIV_SaveR0	; Restore R0
	ADD R0, R0, #1		; Increment R0
	ADD R4, R4, #0	
	BRp DI

	RET	
	
DIV_SaveR0	.BLKW #1	;
DIV_SaveR7	.BLKW #1 	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 
;out R0
EXP
	AND R0, R0, #0		; Clear R0
	ADD R0, R0, R4		; R0 gets R4
EX
	ADD R3, R3,#-1		; decrement exponent
	BRp E
	RET	
E	ST R3, EXP_SaveR3	; Caller save R3 and R7
	ST R7, EXP_SaveR7
	AND R3, R3, #0		; clear R3
	ADD R3, R3, R0
	JSR MUL
	LD R7, EXP_SaveR7	; Restore R3 and R7
	LD R3, EXP_SaveR3
	BR EX
 

EXP_SaveR3	.BLKW #1	
EXP_SaveR7	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


STOP_PROG
	TRAP x25			; HALT

.END
