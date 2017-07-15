
# avoid implicit rules for clarity
.SUFFIXES: .asm .o .gb
.PHONY: clean start assets

ASMS := $(wildcard *.asm)
OBJS := $(ASMS:.asm=.o)
INCLUDES := $(wildcard include/*.asm)

assets:
	SpriteBuilder.exe assets/font.png 26 1 0 include/font_data.asm

%.o: %.asm $(INCLUDES)
	rgbasm -i include/ -v -o $@ $<

game.gb: $(OBJS)
	rgblink -n game.sym -o $@ $^
	rgbfix -v -p 0 $@

bgb: game.gb
	bgb $<

clean:
	rm *.o *.sym game.gb
	
all: game.gb
