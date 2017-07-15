include "ioregs.asm"
include "vram.asm"

Section "Stack", WRAM0

StackBottom::
	ds 128
StackTop::

section "Main", ROM0

; Actual execution starts here
Start::
	DI ; disable interrupts until we set a few things up

	xor A
	ld [SoundControl], A ; disable sound quickly to avoid weird noise

	; Set stack to top of internal RAM
	ld SP, StackTop

	; Initialize HRAM
	call InputInit

	; Disable background while we're fucking with vram
	xor A
	ld [LCDControl], A

	; Initialize VRAM
	
	call SpritesClear
	call FontLoadIntoTileMap
	call LinesClear
	call LineWriteHelloWorld
	
	; Initialize other settings
	; Set pallettes
	ld A, %11100001 ; 0 -> 2, 1 -> 0, 2 -> 1, 3 -> 3. 0 before map is transparent, so 2 after map is transparent
	ld [TileGridPalette], A
	ld [SpritePaletteTransparent], A
	ld [SpritePaletteSolid], A

	; Set up display
	ld A, %10010011 ; window off, background and sprites on, use signed tile map
	ld [LCDControl], A
	; Set timer frequency (16kHz freq = 64Hz interrupt)
	ld A, %00000111 ; enabled, mode 4 (2^14 Hz)
	ld [TimerControl], A

	; Which interrupts we want: VBlank, Timer
	ld a, %00000101
	ld [InterruptsEnabled], a

	xor a
	ld [InterruptFlags], a ; Cancel pending VBlank so interrupt doesn't fire immediately

	; ok, we're good to go
	; enable interrupts
	EI

.mainloop:
	call Update
	jp .mainloop

; Called upon vblank
Draw::
	push AF
	push BC
	push DE
	push HL
	
	call InputDraw
	
	pop HL
	pop DE
	pop BC
	pop AF

	reti
; - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Called on a timer interrupt at 64Hz. May still be interrupted by VBlank.
Update::
	call InputUpdate
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -