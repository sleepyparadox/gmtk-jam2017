include "vram.asm"

Section "Sprites", ROM0

SpritesClear::
	ld HL, SpriteTable
	
	ld C, 40
.nextSprite	
	
	ld B, 4
.nextByte
	ld [HL], 0
	inc HL
	
	dec B
	jp nz, .nextByte
	
	dec C
	jp nz, .nextSprite
	
	ret