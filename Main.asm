; Main.asm
; Name:
; UTEid: 
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer
 	LD R6, Stack	;R6 due to that register being used to write to stack



; set up the keyboard interrupt vector table entry
	LD R1 ISR	;Address of location of ISR
	STI R1, IVT



; enable keyboard interrupts
	LD R1, Enable
	STI R1, KBSR

; start of actual program
	AND R3, R3, 0
	LDI R3, InLoc

	loop LDI R0, InLoc
	BRz loop
;If not zero, then new input, output letter 
	TRAP x21
	
	STI R3, InLoc
	BR loop


;If_U, check if 2nd end codon is not zero, therefore you know to reset that bit.


;Check if it is an A 
	

IVT	.FILL x180
ISR	.FILL x2600
KBSR	.FILL xFE00
Enable	.FILL x4000
Stack	.FILL x4000
InLoc	.FILL x4600
A	.FILL x-41
U	.FILL x-55
G	.FILL x-47
C	.FILL x-43
codStr	.STRINGZ " | "
		.END
