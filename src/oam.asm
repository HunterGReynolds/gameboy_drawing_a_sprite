    INCLUDE "hardware.inc"
    INCLUDE "oam.inc"

    ;; This needs to be aligned to an address of $XX00. This is due to the DMA call
    ;; taking the high byte of shadow_oam and then copying from $XX00 - $XX9F
    ;; ALIGN[8,0] means the 8 least significant bits need to be 0.
    SECTION "Shadow_OAM", WRAM0, ALIGN[8,0]
shadow_oam::
    ;; This is a loop that the assembler will perform, generating labels named
    ;; oam_character00 through oam_character39. The '{02d:n} is similar to printf
    ;; format, where it specifies at least 2 decimal digits, and the variable is n.
    FOR n, NUM_OAM_CHARACTERS
    oam_character{02d:n}:: ds OAM_CHARACTER_SIZE
    ENDR
shadow_oam_end::

    SECTION "dma_loader", ROM0
    ;; Note that the dma_code label is located in the ROM, along with the code below.
    ;; the dma_init label points to a location in HRAM, where we ultimately want this
    ;; code to reside.
dma_code_copy::
    ld de, dma_code
    ld hl, dma_init
    ld bc, dma_init.End - dma_init
    call mem_copy
    ret

    ;; All of the code below is still within the dma_loader section within the ROM.
    ;; Nothing is (or physically could be) written to HRAM until runtime. The dma_init
    ;; label is only pointing to the address in HRAM, it's up to us to copy it there.
dma_code:
    LOAD "dma_code", HRAM
    ;; This code needs to be timed so that the DMA transfer will complete by the time this
    ;; function returns. The timing (and the code below) is documented in the PanDocs.
dma_init::
    ld a, HIGH(shadow_oam)
    ldh [rDMA], a
    ld a, 40
.Wait:
    dec a
    jr nz, .Wait
    ret z
.End:
    ENDL
