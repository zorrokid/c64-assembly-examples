	; Start memory location for program
*	=$0801
	
	; Kernal function to clear the screen
	jsr $e544

	; Set sprite #0 memory pointer

	; We locate Sprite data starting from $2000 (see sprdata)
	; The memory location passed to sprite data pointer is
	; memory address divided by 64 
	; since $2000 is 8192 in decimal:
	; 8192 / 64 = 128 ($80) 
	; so we set sprite #0 memory pointer to $80.

	lda #$80
	sta $07f8

	; enable sprite #0
	lda #01
	sta $d015

	; set sprite #0 location
	lda #$40
	; x-location
	sta $d000
	; y-location
	sta $d001

	; Wait loop
wait: 
	jmp wait

; sprite is 24 bits X 21 bits (63 bytes) 

;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00
;00000000 11111111 00000000 => $00 $FF $00

	; sprite data pointer value must be set to a memory 
	; address dividable with 64 so here we locate sprite data
	; to $2000 which is 8192 in decimal

*	= $2000 
sprdata	
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
	!byte $00,$ff,$00
