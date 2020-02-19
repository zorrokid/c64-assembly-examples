; we're using zero-page vector (pair of bytes) for indirect-indexed access to screen memory:
tmp2lo  = $37
tmp2hi  = $38

	; Start memory location for program
	*=$0801

	jsr print_char_set

loop: 	; just a wait loop	
	jmp  loop

print_char_set:

	; store start of screen memory address $0400 to zero page vector 
	; low byte:
	lda #<$0400
	sta tmp2lo
	; high byte:
	lda #>$0400
	sta tmp2hi

	; copy all 255 characters to screen memory
	; y is used for both referencing the character value and as an index for screen memory location
	ldy #$00
.copyloop
	tya
	sta (tmp2lo),y
	iny
	bne .copyloop 	; loop until y has 0 again

	rts
