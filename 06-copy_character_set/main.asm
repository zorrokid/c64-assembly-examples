; we're using zero-page vector (pair of bytes) for indirect-indexed access to memory locations 
; using some unused addresses here (zero-page memory map: https://www.c64-wiki.com/wiki/Zeropage):
TMP1LO	= $fb
TMP1HI  = $fC

TMP2LO  = $fd
TMP2HI  = $fe

	; Start memory location for program
	*=$0801

	jsr copy_character_set
	jsr copy_custom_characters
	jsr set_char_set_memory
	jsr print_char_set

	; wait loop
-   	
	jmp -

copy_custom_characters

	; Store start of char memory to a zero page vector
	; ...low byte
	lda #<$3000
	sta TMP2LO
	; ...high byte
	lda #>$3000
	sta TMP2HI

	; load 8 bytes
	ldx #$08
	ldy #$00
-
	lda char,y 
	sta (TMP2LO),y
	iny
	dex
	bne -
	rts


; Copy character set from ROM to memory area starting from $3000, default character set is located at $D000-$DFFF.
;
; To copy chracter set from ROM to RAM the I/O registers must be switch out and character ROM must be switch in, accessible to CPU.
; Also interrupts must be disabled when I/O is switched out since I/O registers are not available.
; After copying is done, the I/O registers must be switch back in and interrupts enabled again.
copy_character_set

	; Before swithing out I/O registers, interrupts must be disabled:
	sei

	; Switch out I/O and switch in character ROM to be accessible to CPU. 
	; $01 is processor port register, the lowest three bits are for memory area configurations
	; bit 3 is for memory area $D000-$DFFF, either character ROM is visible (0) or I/O area is visible(1)
	lda $01
	and #%11111011
	sta $01

	; Store start of char memory to a zero page vector
	; ... low byte
	lda #<$d000
	sta TMP1LO
	; ... high byte
	lda #>$d000
	sta TMP1HI

	; Store start of target memory address to a zero page vector
	; ...low byte
	lda #<$3000
	sta TMP2LO
	; ...high byte
	lda #>$3000
	sta TMP2HI

	; A full C64 character set requires 256 * 8 bytes of memory
	; (256 characters, each consisting of 8 bytes)
	; so copy eight times 256 bytes:
	ldx #$08

	; y-register is used as an index to memory
	ldy #$00
-
	lda (TMP1LO),y
	sta (TMP2LO),y
	iny
	bne -

	; y went back to zero, increase high byte of zero page vector
	; to access next 256 bytes of data:
	inc TMP1HI
	inc TMP2HI
	dex
	bne -

	; switch out character ROM and switch I/O back in
	lda $01 
	ora #%00000100
	sta $01

	; enable interrupts again
	cli
+
	rts

set_char_set_memory

	; Seting character set location:
	; - load contents of $d018 (vic memory control register) to ACC
	;   upper 4 bits in $d018 control location of the screen memory
	;   lower bits 3, 2 and 1 control location of the character set.
	;   (bit 0 is ignored)
	; - do AND 11110001 ($f1)
	; - do ORA 00001100 ($0c) to set memory bank
	;   to $3000 - $37FF
	; - store the altered value back to VICMEMCTRLREG

        LDA $d018 
        AND #%11110001
        ORA #%00001100
        STA $d018 

	rts

print_char_set

	; Store start of screen memory address $0400 to zero page vector 
	; low byte...:
	lda #<$0400
	sta TMP1LO
	; ... and high byte:
	lda #>$0400
	sta TMP1HI

	; copy all 255 characters to screen memory
	; y is used for both referencing the character value and as an index to screen memory location
	ldy #$00
-	
	tya
	sta (TMP1LO),y
	iny
	bne - 	; loop until y has 0 again

	rts

*=$2000
char	; a smiley face char :)
	!byte %00111100
	!byte %01000010
	!byte %10100101
	!byte %10000001
	!byte %10100101
	!byte %10011001
	!byte %01000010
	!byte %00111100

