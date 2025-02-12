INCLUDE "vram.inc"
    
    SECTION "graphics_functions", ROM0
load_graphics::
    ;; de = data source
    ;; hl = destination
    ;; bc = length
    ld de, bg_tile_data
    ld hl, vram_tile_block2
    ld bc, bg_tile_data_end - bg_tile_data
    call mem_copy

    ld de, tilemap
    ld hl, vram_tilemap_set0
    ld bc, tilemap_end - tilemap
    call mem_copy
    
    ld de, example_sprite_data
    ld hl, vram_tile_block0
    ld bc, example_sprite_data_end - example_sprite_data
    call mem_copy
    ret
    
    SECTION "graphics_data", ROM0
bg_tile_data:
    INCBIN "assets/font.2bpp"
bg_tile_data_end:
example_sprite_data:
    INCBIN "assets/little_fella.2bpp"
example_sprite_data_end:    
