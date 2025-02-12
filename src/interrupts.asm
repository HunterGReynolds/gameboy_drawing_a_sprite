    SECTION "interrupt_handler",ROM0[$0040]
vblank_interrupt::
    reti
    ds ALIGN[3]
stat_interrupt::
    rst $38
    ds ALIGN[3]
timer_interrupt::
    rst $38
    ds ALIGN[3]
serial_interrupt::
    rst $38
    ds ALIGN[3]
joypad_interrupt::
    rst $38
    ds ALIGN[3]
