    DEF NUM_RST_VECTORS EQU 8
    
    SECTION "rst_vectors", ROM0[$0000]
    FOR n, NUM_RST_VECTORS
    rst_vector{d:n}::
    rst $38
    ds ALIGN[3]
    ENDR    
