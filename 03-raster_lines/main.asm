	; Start memory location for program
	*=$0801

REG_VIC_CTRLBITS= $d011
REG_RASTERLINE	= $d012
REG_BORDERCOLOR	= $d020
REG_BACKGRCOLOR	= $d021
	
loop
	jsr set_color 
	jmp loop

	; Note 1:
	; C64 PAL has 312 raster lines
	; C64 NTSC has 262 raster lines

	; Note 2:
	; When running this there's some flickering in the edge
	; of different color areas, since here we don't take into 
	; account the actual location of raster beam on the raster line 
	; If we would update the colour only when raster beam is 	
	; at certain point of raster line then there would be no flickering.
set_color
	; check first if rasterline if above 255
	; Bit 7 (weight 128) in $d011 is the most significant bit of 
	; the VIC's nine-bit raster register 
	lda REG_VIC_CTRLBITS
	and #$80; check if bit 7 (10000000) is set
	bne .set_color_2; if the result was not zero it's set

	lda REG_RASTERLINE
	cmp #$50
	; branch if carry set
	bcs .set_color_1

	lda #$00
	sta REG_BORDERCOLOR
	sta REG_BACKGRCOLOR
	rts

.set_color_1
	lda #$01
	STA REG_BORDERCOLOR
	sta REG_BACKGRCOLOR
	rts

.set_color_2
	lda #$02
	STA REG_BORDERCOLOR
	sta REG_BACKGRCOLOR
	rts

