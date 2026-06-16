; Majority Gate - AVR Assembly for Arduino Uno (ATmega328P)
; Pins: D2=PD2(X), D3=PD3(Y), D4=PD4(Z), D5=PD5(F/LED)

.include "m328Pdef.inc"

.org 0x0000
    rjmp SETUP

; ─────────────────────────────────────
SETUP:
    ; Stack pointer init
    ldi r16, hi(RAMEND)
    out SPH, r16
    ldi r16, lo(RAMEND)
    out SPL, r16

    ; DDRD: PD2,PD3,PD4 as INPUT, PD5 as OUTPUT
    in  r16, DDRD
    andi r16, 0b11001111   ; clear PD4,PD3,PD2 → input... wait
    ; Clear PD2, PD3, PD4 (inputs)
    andi r16, ~((1<<PD2)|(1<<PD3)|(1<<PD4))
    ; Set PD5 (output)
    ori  r16, (1<<PD5)
    out  DDRD, r16

; ─────────────────────────────────────
LOOP:
    ; Read PIND
    in  r16, PIND

    ; Extract X (PD2), Y (PD3), Z (PD4) into r17, r18, r19
    mov r17, r16
    lsr r17
    lsr r17
    andi r17, 0x01          ; r17 = X

    mov r18, r16
    lsr r18
    lsr r18
    lsr r18
    andi r18, 0x01          ; r18 = Y

    mov r19, r16
    lsr r19
    lsr r19
    lsr r19
    lsr r19
    andi r19, 0x01          ; r19 = Z

    ; Majority: F = (X&Y) | (Y&Z) | (Z&X)
    mov r20, r17
    and r20, r18            ; r20 = X & Y

    mov r21, r18
    and r21, r19            ; r21 = Y & Z

    mov r22, r19
    and r22, r17            ; r22 = Z & X

    or  r20, r21            ; r20 = (X&Y)|(Y&Z)
    or  r20, r22            ; r20 = F

    ; Write F to PD5
    in  r16, PORTD
    tst r20
    breq CLEAR_LED

SET_LED:
    ori  r16, (1<<PD5)
    out  PORTD, r16
    rjmp DELAY

CLEAR_LED:
    andi r16, ~(1<<PD5)
    out  PORTD, r16

; ─────────────────────────────────────
DELAY:
    ; ~200ms delay at 16MHz
    ldi r23, 200            ; outer loop
DELAY_OUTER:
    ldi r24, 0xFF           ; middle loop
DELAY_MIDDLE:
    ldi r25, 0x14           ; inner loop
DELAY_INNER:
    dec r25
    brne DELAY_INNER
    dec r24
    brne DELAY_MIDDLE
    dec r23
    brne DELAY_OUTER

    rjmp LOOP