include "vram.asm"

Section "TileGrid", ROM0

; failed experiment
;RowPointersStart:
;dw TileGridRow0
;dw TileGridRow1
;dw TileGridRow2
;dw TileGridRow3
;dw TileGridRow4
;dw TileGridRow5
;dw TileGridRow6
;dw TileGridRow7
;dw TileGridRow8
;dw TileGridRow9
;dw TileGridRow10
;dw TileGridRow11
;dw TileGridRow12
;dw TileGridRow13
;dw TileGridRow14
;dw TileGridRow15

TileAWriteToDE::
	push HL
	call TileAWriteToDE_USES_HL
	pop HL
	
	ret
	
; this method makes me so sad
; but I don't have time to get my pointers working
; besides the clear line should be pretty handy for what I have planned
	
TileAWriteToDE_USES_HL::
	
	; We don't actually need A until the write
	push AF
	
	
	; I really hate this solution
	ld A, 17
	cp D
	jp z, .useRow17
	
	dec A
	cp D
	jp z, .useRow16
	
	dec A
	cp D
	jp z, .useRow15
	
	dec A
	cp D
	jp z, .useRow14
	
	dec A
	cp D
	jp z, .useRow13
	
	dec A
	cp D
	jp z, .useRow12
	
	dec A
	cp D
	jp z, .useRow11
	
	dec A
	cp D
	jp z, .useRow10
	
	dec A
	cp D
	jp z, .useRow9
	
	dec A
	cp D
	jp z, .useRow8
	
	dec A
	cp D
	jp z, .useRow7
	
	dec A
	cp D
	jp z, .useRow6
	
	dec A
	cp D
	jp z, .useRow5
	
	dec A
	cp D
	jp z, .useRow4
	
	dec A
	cp D
	jp z, .useRow3
	
	dec A
	cp D
	jp z, .useRow2
	
	dec A
	cp D
	jp z, .useRow1
	
;useRow0
	ld HL, TileGridRow0
	jp .useRow
.useRow1
	ld HL, TileGridRow1
	jp .useRow	
.useRow2
	ld HL, TileGridRow2
	jp .useRow	
.useRow3
	ld HL, TileGridRow3
	jp .useRow	
.useRow4
	ld HL, TileGridRow4
	jp .useRow	
.useRow5
	ld HL, TileGridRow5
	jp .useRow	
.useRow6
	ld HL, TileGridRow6
	jp .useRow	
.useRow7
	ld HL, TileGridRow7
	jp .useRow	
.useRow8
	ld HL, TileGridRow8
	jp .useRow	
.useRow9
	ld HL, TileGridRow9
	jp .useRow	
.useRow10
	ld HL, TileGridRow10
	jp .useRow	
.useRow11
	ld HL, TileGridRow11
	jp .useRow	
.useRow12
	ld HL, TileGridRow12
	jp .useRow	
.useRow13
	ld HL, TileGridRow13
	jp .useRow	
.useRow14
	ld HL, TileGridRow14
	jp .useRow	
.useRow15
	ld HL, TileGridRow15
	jp .useRow	
.useRow16
	ld HL, TileGridRow16
	jp .useRow	
.useRow17
	ld HL, TileGridRow17
	jp .useRow	
	
.useRow
	
	; Let's find tile
	ld A, 0
.HTileStart		
	
	; is HL at correct E?
	cp E
	jp z, .HTileDone
	
	;look at next tile
	inc A
	inc HL
	jp .HTileStart
	
.HTileDone	
	
	; write origonal A to tile
	pop AF
	ld [HL], A
	
	ret
