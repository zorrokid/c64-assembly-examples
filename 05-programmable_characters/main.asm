; we're using zero-page vector (pair of bytes) for indirect-indexed access to memory locations 
; using some unused addresses here (zero-page memory map: https://www.c64-wiki.com/wiki/Zeropage):
TMP1LO	= $fb
TMP1HI  = $fC

TMP2LO  = $fd
TMP2HI  = $fe

; start of screen memory
SCR_MEM_START = $0400

; Kernal function to clear the screen
CLEAR_SCREEN = $e544

	; Start memory location for program
	*=$0801

	jsr CLEAR_SCREEN 

	jsr copy_chr_data
	jsr set_chr_memory
	jsr print_char

	; wait loop
-   	
	jmp -

; copy cutom character (smiley face) to custome character memory location starting from $3000
copy_chr_data

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

; set character memory to point to custom location at $3000
set_chr_memory

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

; print one smiley at the start of screen memory (top left corner of screen)
print_char

	lda #$00
	sta SCR_MEM_START 

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

