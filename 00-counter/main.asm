	; Start memory location for program
	*=$0801
	
	; Load 0 to x-register
	ldx #$00
loop:   
	; Increase value in  x-register
	inx

	; If the result of previous was zero (zero-flag set) continue
	; otherwise back to loop
	bne loop

	; Increase value in  background colour register
	inc $d020

	jmp  loop
