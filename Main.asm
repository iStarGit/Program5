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
	
	LD R4, started
	BRnp checkEnd

	LD R4, A
	ADD R4, R0, R4
	BRz if_A
	
	LD R4, U
	ADD R4, R0, R4
	BRz if_U

	LD R4, C
	ADD R4, R0, R4
	BRz if_C

	LD R4, G
	ADD R4, R0, R4
	BRz if_G

if_A
	ST R0, sCodonA
	BR enter
if_U
	LD R4, sCodonA
	BRz enter
	LD R4, sCodonU
	BRz store
	ST R3, sCodonA
	ST R3, sCodonU
	BR enter
	store ST R0, sCodonU
	BR enter

if_C
	ST R3, sCodonA
	ST R3, sCodonU
	BR enter

if_G
	LD R4, sCodonA
	BRz enter
	LD R4, sCodonU
	BRnp start
	ST R3, sCodonA
	BR enter


start 
	LEA R0, codStr
	TRAP x22
	ADD R4, R3, #1
	ST R4 started

enter	STI R3, InLoc
	BR loop

checkEnd

	LD R4, A
	ADD R4, R0, R4
	BRz Eif_A
	
	LD R4, U
	ADD R4, R0, R4
	BRz Eif_U

	LD R4, C
	ADD R4, R0, R4
	BRz Eif_C

	LD R4, G
	ADD R4, R0, R4
	BRz Eif_G

Eif_A
	LD R4, eCodon1
	BRz enter
	LD R4, eCodon2	
	BRnp comp
	ST R0, eCodon2
	BR enter
Eif_U
	LD R4, eCodon2
	ST R0, eCodon1
	BR enter 
 	

Eif_C
	ST R3, eCodon1
	ST R3, eCodon2
	BR enter

Eif_G
	LD R4, eCodon1
	BRz enter
	ST R0, eCodon2
	BR enter



comp	STI R3, InLoc
	ST R3, started
	ST R3, sCodonA
	ST R3, sCodonU
	ST R3, eCodon1
	ST R3, eCodon2
	TRAP x25


;If_U, check if 2nd end codon is not zero, therefore you know to reset that bit.


;Check if it is an A 
	
	
sCodonA	.blkw 1
sCodonU .blkw 1
sCodonG	.blkw 1


started	.blkw 1
check	.blkw 1


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
