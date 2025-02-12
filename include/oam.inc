                                ; -*- mode:asm -*-
    rsreset
    DEF OAM_CHARACTER_Y_POS  rb
    DEF OAM_CHARACTER_X_POS  rb
    DEF OAM_CHARACTER_TILE   rb
    DEF OAM_CHARACTER_ATTRIB rb
    DEF OAM_CHARACTER_SIZE EQU _RS
    
    DEF NUM_OAM_CHARACTERS EQU 40

    DEF OAM_FLAG_HORIZ_FLIP EQU $20
