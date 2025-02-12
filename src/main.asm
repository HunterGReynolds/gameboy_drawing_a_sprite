    INCLUDE "hardware.inc"
    INCLUDE "oam.inc"
    INCLUDE "vram.inc"

    SECTION "data", WRAM0
frame_counter::
    db
    
    SECTION "main", ROM0
entry_point::
    ;; First thing we need to do is wait for Vblank so we can disable the LCD/PPU
    ;; this will allow us access to the VRAM without interruption. We enable the
    ;; interrupt flag here.
    ld a, IEF_VBLANK
    ldh [rIE], a
    ;; and then enable interrupts here. You don't want to do a halt immediately following
    ;; ei due to a bug, so we zero out a since we needed to anyway
    ei
    xor a
    halt

    ;; turn off the LCD/PPU
    ld [rLCDC], a
    ;; turn off the sound system. Recommended to do if it's not being used
    ld [rNR52], a
    ld [frame_counter], a

    ;; Clear the shadow OAM as well as the real OAM, otherwise we'll see a bunch of garbage
    ld bc, oam_size
    ld hl, shadow_oam
    call zero_mem
    call clear_OAM

    ;; load the DMA code into HRAM for use
    call dma_code_copy
    ;; this code will also load the sprite tiles
    call load_graphics
    ;; we need to initialize the sprite, setting its tiles, positioning it in the top-left corner of the screen,
    ;; and giving it an initial draw to the shadow_oam
    call init_example_sprite

    ;; load the palatte colors for the background
    ;; $E4 = 11 10 01 00 -- black, dark gray, light gray, white
    ld a, $E4
    ld [rBGP], a
    ;; also load the object palatte, which for this can just be the exact same as the background.
    ld [rOBP0], a

    ;; We've got the graphics loaded and everything ready to go, so let's turn the LCD
    ;; back on and run our main loop.

    ;; We add the LCDCF_OBJON flag here to enable object drawing
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [rLCDC], a

main_loop:
    halt
    ;; halt the cpu and wait for an interrupt to occur

    ;; update the shadow OAM with the current sprite data, not that it will be changing in this
    ;; example, but we'll probably want to change it in most cases.
    call draw_example_sprite
    
    ;; commit the state of objects to OAM, this will cause it to actually appear on the screen the
    ;; next time the screen is drawn.
    call dma_init
    
    ld a, [frame_counter]
    inc a
    ld [frame_counter], a
    
    jp main_loop
