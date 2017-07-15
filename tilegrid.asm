include "vram.asm"

Section "TileGrid", ROM0

; A little hacky but useful for quick lookup
TileGridRow0 EQU $9800
TileGridRow1 EQU $9820
TileGridRow2 EQU $9840
TileGridRow3 EQU $9880
TileGridRow4 EQU $98a0
TileGridRow5 EQU $98c0
TileGridRow6 EQU $98e0
TileGridRow7 EQU $9900
TileGridRow8 EQU $9920
TileGridRow9 EQU $9940
TileGridRow10 EQU $9980
TileGridRow11 EQU $99a0
TileGridRow12 EQU $99c0
TileGridRow13 EQU $99e0
TileGridRow14 EQU $9a00
TileGridRow15 EQU $9a20

StartTileRowPointers:
dw TileGridRow0
dw TileGridRow1
dw TileGridRow2
dw TileGridRow3
dw TileGridRow4
dw TileGridRow5
dw TileGridRow6
dw TileGridRow7
dw TileGridRow8
dw TileGridRow9
dw TileGridRow10
dw TileGridRow11
dw TileGridRow12
dw TileGridRow13
dw TileGridRow14
dw TileGridRow15
EndTileRowPoi

WriteAToHLTile::
	push BC
	push DE
	call WriteAToHLTile_USE_BC_DE
	pop DE
	pop BC
	ret
	
WriteAToHLTile_USE_BC_DE::
	
	
	; We don't actually need A until the write
	push AF
	
	; Let's find row pointer
	ld DE, StartTileRowPointers
	ld A, 0
.LTileStart		
	
	; is DE correct?
	cp L
	jp z, .LTileDone
	
	; look at next pointer
	inc A
	inc DE
	inc DE
	jp .LTileStart
	
.LTileDone
	
	; dereference row pointer
	
	; stash pointer D
	ld A, [DE]
	ld C, A
	; look at pointer E
	inc DE
	ld A, [DE]
	; populate DE
	ld D, C
	ld E, A

	; Let's find tile
	ld A, 0
.HTileStart		
	
	; is DE correct?
	cp H
	jp z, .HTileDone
	
	;look at next tile
	inc A
	inc DE
	jp .HTileStart
	
.HTileDone	
	
	; write A to tile
	pop AF
	ld [DE], A
	
	ret