include "ioregs.asm"
include "font_chars.asm"

; declare how many dec, jp ops per DPad / Buttons Swap
InputWait EQU 4

Section "InputWRam", WRAM0

InputPendingCha::
DB 
InputPendingRow::
DB
InputPendingCol::
DB

Section "Input", ROM0
; - - - - - - - - - - - - - - - - - - - - - - - - - - -

InputInit::
	ld A, 0
	ld [InputPendingCha], A
	ld [InputPendingRow], A
	ld [InputPendingCol], A
	
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -	

InputUpdate::

	; skip if input already pending
	ld A, [InputPendingCha]
	ld B, 0
	cp B
	jp nz, .inputDone
	
	; listen for buttons
	call InputsListenForButtons
	
	ld A, [JoyIO]	
	bit 0, A
	jp z, .buttonAInputDetected ; pressing A button	
	;else
	jp .inputDone
	
	
.buttonAInputDetected	
	
	ld HL, InputPendingCha
	ld [HL], 3
	
	jp .inputDone
 
.inputDone
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -

InputDraw::
	; skip if no input pending
	ld A, [InputPendingCha]
	ld B, 0
	cp B
	jp z, .drawDone
	
	; grab the input info
	ld A, [InputPendingRow]
	ld D, A
	
	ld A, [InputPendingCol]
	ld E, A
	
	ld A, [InputPendingCha]
	
	; write to tiles
	call TileAWriteToDE_USES_HL
	
	; inc column
	ld A, [InputPendingCol]
	inc A
	ld [InputPendingCol], A

	; clear the input
	ld A, 0
	ld [InputPendingCha], A
	
.drawDone
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
InputsListenForDPad::

	ld HL, JoyIO
	ld [HL], JoySelectDPad

	ld b, InputWait
.waitStart
	dec b
	jp nz, .waitStart

	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
InputsListenForButtons::

	ld HL, JoyIO
	ld [HL], JoySelectButtons

	ld b, InputWait
.waitStart
	dec b
	jp nz, .waitStart

	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -