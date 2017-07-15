include "vram.asm"
Section "Font", ROM0

FontCells EQU 26
FontCellBytes EQU 16

StartFontData:
include "font_data.asm"
EndFontData:

; Copies into tileset
LoadFontIntoTiles::
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