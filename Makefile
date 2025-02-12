RGBDS_ROOT := ../rgbds-v0.8.0/
RGBASM  := ${RGBDS_ROOT}rgbasm
RGBLINK := ${RGBDS_ROOT}rgblink
RGBFIX  := ${RGBDS_ROOT}rgbfix
RGBGFX  := ${RGBDS_ROOT}rgbgfx

SRC	= $(wildcard src/*.asm)
OBJ	= $(patsubst src/%.asm,obj/%.o,$(SRC))
IMG_SRC = $(wildcard assets/*.png)
IMG = $(patsubst assets/%.png,assets/%.2bpp,$(IMG_SRC))

SRCD := src
OBJD := obj
INCD := include
IMGD := assets

ROMS := sprite.gb

all: $(ROMS)

%.gb: $(IMG) $(OBJ)
	$(RGBLINK) -m $(*F).map -n $(*F).sym -o $@ $(OBJ)
	$(RGBFIX) -v -p 0xFF $@

assets/%.2bpp: $(IMGD)/%.png
	$(RGBGFX) -u -o $@ $^

$(OBJD)/%.o: $(SRCD)/%.asm $(IMG)
	@mkdir -p $(OBJD)
	$(RGBASM) -o $@ $< -I $(INCD)

.PHONY: clean

clean:
	@rm $(OBJD)/*.o
	@rm $(IMGD)/*.2bpp
	@rm *.{gb,map,sym}
	@rmdir $(OBJD)
