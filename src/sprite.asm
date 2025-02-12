    INCLUDE "hardware.inc"
    INCLUDE "oam.inc"

    SECTION "example_sprite", ROM0
    ;; We want to draw the 4 tiles of the character. I do this using offsets from the first (top-left)
    ;; tile. Then I loop 4 times, adding an offset as appropriate to the X or Y of the tile. The X
    ;; offset is stored in d, and the y offset is stored in c. Something like this:
    ;; 
    ;; | iter | x | y |
    ;; |------+---+---|
    ;; |    0 | 0 | 0 |
    ;; |    1 | 1 | 0 |
    ;; |    2 | 0 | 1 |
    ;; |    3 | 1 | 1 |

draw_example_sprite::
    ld b, 0
    ld hl, oam_character00
.loop:
    ld c, 0
    ld d, 0
    ld a, b
    ;; The comparison below sets the carry flag when a < 2, and doesn't set it once a >= 2.
    cp a, 2
    jr c, .skip_y_inc
    ld c, 8
.skip_y_inc:
    ;; The operation below will set the zero flag when a is odd
    and a, 1
    jr z, .skip_x_inc
    ld d, 8
.skip_x_inc:
    ld a, [oam_character00 + OAM_CHARACTER_Y_POS]
    add a, c
    ld [hli], a
    ld a, [oam_character00 + OAM_CHARACTER_X_POS]
    add a, d
    ld [hli], a
    ld a, [oam_character00 + OAM_CHARACTER_TILE]
    add a, b
    ld [hli], a
    ld a, [oam_character00 + OAM_CHARACTER_ATTRIB]
    ld [hli], a
    inc b
    ld a, b
    cp a, 4
    jr nz, .loop
    ret
    
init_example_sprite::
    ld a, $10
    ld [oam_character00 + OAM_CHARACTER_Y_POS], a
    srl a
    ld [oam_character00 + OAM_CHARACTER_X_POS], a
    xor a
    ld [oam_character00 + OAM_CHARACTER_TILE], a
    ld [oam_character00 + OAM_CHARACTER_ATTRIB], a
    call draw_example_sprite
    ret
    
