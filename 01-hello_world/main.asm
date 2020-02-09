	; Start memory location for program
	*=$0801
	
	; Kernal function to clear the screen
	jsr $e544

	; X-register is used as index to read values
	; starting from memory location with label "text"
	; and storing values to screen memory.

	; Load 0 to x-register
	ldx #$00
loop:
	; Load value from memory location "text+x" to accu
	lda text,x
	; End if result from previous was 0 (end of text data)
	beq wait

	; Store to screen memory from accu
	sta $0400,x

	; Increase value in x-register
	inx

	bne loop

wait: 
	jmp wait

text:
	!scr "hell0 w0rld",0
