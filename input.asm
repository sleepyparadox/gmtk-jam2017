include "ioregs.asm"
include "font_chars.asm"

; declare how many dec, jp ops per DPad / Buttons Swap
InputWait EQU 4

ActionNone EQU 0
ActionUpdate EQU 1
ActionPush EQU 2


Section "InputWRam", WRAM0
InputPendingAction::
DB 
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
	ld [InputPendingAction], A
	ld [InputPendingCha], A
	ld [InputPendingRow], A
	ld [InputPendingCol], A
	
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -	

InputUpdate::

	; skip if input already pending
	ld A, [InputPendingAction]
	ld B, ActionNone
	cp B
	jp nz, .inputDone
	
	; listen for buttons
	call InputsListenForButtons
	
	ld A, [JoyIO]	
	; if A pressed
	bit 0, A
	jp z, .buttonAInputDetected 
	; else if B press
	bit 1, A
	jp z, .buttonBInputDetected
	; else
	jp .inputDone
	
	
.buttonAInputDetected	
	
	ld HL, InputPendingCha
	ld [HL], FontA
	
	ld HL, InputPendingAction
	ld [HL], ActionUpdate
	
	jp .inputDone

.buttonBInputDetected	
	
	ld HL, InputPendingCha
	ld [HL], FontB
	
	ld HL, InputPendingAction
	ld [HL], ActionPush
	
	jp .inputDone

	
.inputDone
	ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - -

InputDraw::
	; skip if no input pending
	ld A, [InputPendingAction]
	ld B, ActionNone
	cp B
	jp z, .drawDone
	
	; grab the action info
	ld A, [InputPendingRow]
	ld D, A
	
	ld A, [InputPendingCol]
	ld E, A
	
	ld A, [InputPendingCha]
	
	; write to tiles
	call TileAWriteToDE_USES_HL
	
	; check if character is pushed
	ld A, [InputPendingAction]
	ld B, ActionPush
	cp B
	jp z, .clearAction
	
	; push character
	ld A, [InputPendingCol]
	inc A
	ld [InputPendingCol], A

.clearAction
	; clear the action
	ld A, ActionNone
	ld [InputPendingAction], A
	
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