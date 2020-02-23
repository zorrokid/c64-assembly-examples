; we're using zero-page vector (pair of bytes) for indirect-indexed access to screen memory
; using some unused addresses here (zero-page memory map: https://www.c64-wiki.com/wiki/Zeropage)
tmp_lo  = $fb
tmp_hi  = $fc

	; Start memory location for program
	*=$0801

	jsr print_char_set

; just a wait loop: using acme-assembler anonymous backward label feature here ('-'-label)
- 	
	jmp - 	; when referencing '-'-label, it refers to previous definition of '-'-label

print_char_set

	; Store start of screen memory address $0400 to zero page vector 
	; low byte...:
	lda #<$0400
	sta tmp_lo
	; ... and high byte:
	lda #>$0400
	sta tmp_hi

	; copy all 255 characters to screen memory
	; y is used for both referencing the character value and as an index to screen memory location
	ldy #$00
-	
	tya
	sta (tmp_lo),y
	iny
	bne - 	; loop until y has 0 again

	rts
