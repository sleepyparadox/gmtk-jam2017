
; Tile map is a array 0 to 255 of 16-byte tile images from $8000-$8fff
; Alt tile map is a array -128 to 127 from $8800-$97ff (0 is at $9000)
; You can switch whether the background map uses TileMap or AltTileMap using LCDC register
; Here we define the base, the overlapping region, and the start of the non-overlapping alt part
BaseTileMap EQU $8000
OverlapTileMap EQU $8800
AltTileMap EQU $9000
; Tile data is 32x32 grid of tile numbers from $9800-$9bff
; Background and Window are windows into this area
TileGrid EQU $9800
; You can switch between which TileGrid is used by background or window using LCDC register
AltTileGrid EQU $9c00

SpriteTable EQU $fe00

; How many working sprite slots to have
NumSprites EQU 3

; A little hacky but useful for quick lookup
TileGridRow0 EQU $9800
TileGridRow1 EQU $9820
TileGridRow2 EQU $9840
TileGridRow3 EQU $9860
TileGridRow4 EQU $9880
TileGridRow5 EQU $98a0
TileGridRow6 EQU $98c0
TileGridRow7 EQU $98e0
TileGridRow8 EQU $9900
TileGridRow9 EQU $9920
TileGridRow10 EQU $9940
TileGridRow11 EQU $9960
TileGridRow12 EQU $9980
TileGridRow13 EQU $99a0
TileGridRow14 EQU $99c0
TileGridRow15 EQU $99e0
TileGridRow16 EQU $9a00
TileGridRow17 EQU $9a20