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

	; Store to screen memory from accu
	sta $0400,x

	; Increase value in x-register
	inx

	; Compare value in x-register to 11 (length of string in "text")
	; if content in x-register is equal, zero-flag is set.
	cpx #11
	; If result is not equal (zero-flag is not set), branch to label "loop"
	bne loop

	; Wait loop
wait: 
	jmp wait

text:
	!scr "hello world"
