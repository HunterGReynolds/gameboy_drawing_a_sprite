    INCLUDE "hardware.inc"
    SECTION "memory_funcs", ROM0
    
    ;; de = source location
    ;; bc = number of bytes to copy
    ;; hl = destination location
mem_copy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, mem_copy
    ret    

    ;; bc = number of bytes to write
    ;; hl = destination
zero_mem::
    xor a
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, zero_mem
    ret    

    ;; no parameters
clear_OAM::
    ld bc, 160
    ld hl, _OAMRAM
    call zero_mem
    ret
