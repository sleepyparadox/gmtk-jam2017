include "vram.asm"
include "font_chars.asm"

Section "Font", ROM0

FontCells EQU 26
FontCellBytes EQU 16

StartFontData:
include "font_data.asm"
EndFontData:

LineWriteHelloWorld::
	ld HL, TileGridRow0
	call LineHLClear
	
	ld A, FontH
	ld DE, $00
	call TileAWriteToDE_USES_HL
	
	ld A, FontE
	ld DE, $01
	call TileAWriteToDE_USES_HL
	
	ld A, FontL
	ld DE, $02
	call TileAWriteToDE_USES_HL
	ld DE, $03
	call TileAWriteToDE_USES_HL
	
	ld A, FontO
	ld DE, $04
	call TileAWriteToDE_USES_HL
	
	ld A, Font_
	ld DE, $05
	call TileAWriteToDE_USES_HL
	
	ld A, FontW
	ld DE, $06
	call TileAWriteToDE_USES_HL
	
	ld A, FontO
	ld DE, $07
	call TileAWriteToDE_USES_HL
	
	ld A, FontR
	ld DE, $08
	call TileAWriteToDE_USES_HL
	
	ld A, FontL
	ld DE, $09
	call TileAWriteToDE_USES_HL
	
	ld A, FontD
	ld DE, $0A
	call TileAWriteToDE_USES_HL
ret


LineHLClear::
	
	ld C, 20

.writeNextTile
	
	ld [HL], Font_
	
	inc HL
	dec C
	jp nz, .writeNextTile
	
	ret
	
; this method makes me so sad
; but I don't have time to get my pointers working
LinesClear::
	ld HL, TileGridRow0
	call LineHLClear

	ld HL, TileGridRow1
	call LineHLClear

	ld HL, TileGridRow2
	call LineHLClear

	ld HL, TileGridRow3
	call LineHLClear

	ld HL, TileGridRow4
	call LineHLClear

	ld HL, TileGridRow5
	call LineHLClear

	ld HL, TileGridRow6
	call LineHLClear

	ld HL, TileGridRow7
	call LineHLClear

	ld HL, TileGridRow8
	call LineHLClear

	ld HL, TileGridRow9
	call LineHLClear

	ld HL, TileGridRow10
	call LineHLClear

	ld HL, TileGridRow11
	call LineHLClear

	ld HL, TileGridRow12
	call LineHLClear

	ld HL, TileGridRow13
	call LineHLClear

	ld HL, TileGridRow14
	call LineHLClear

	ld HL, TileGridRow15
	call LineHLClear
	
	ld HL, TileGridRow16
	call LineHLClear
	
	ld HL, TileGridRow17
	call LineHLClear
	
	ret
	
; Copies into tileset
FontLoadIntoTileMap::
	ld HL, StartFontData
	ld DE, BaseTileMap
	
	ld B, FontCellBytes
	ld C, FontCells
.loop
		
	ld A, [HL]
	ld [DE], A
	
	inc HL
	inc DE
	
	; is this cell done?
	dec B
	jp nz, .loop
	
	; start copy next cell
	ld B, FontCellBytes
	dec C
	jp nz, .loop
	
	;; all done!
ret