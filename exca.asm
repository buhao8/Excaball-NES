    .inesprg 1  ; 1x 16KB bank of PRG
    .ineschr 1  ; 1x 8KB bank of CHR
    .inesmap 0  ; mapper 0 = NROM, no bank swapping
    .inesmir 2  ; background mirroring

    .include "vars.asm"
    
    ; Define vectors
    .bank 1
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw 0       ; external IRQ
    
    ; Reset code
    .bank 0
    .org $C000
RESET:
    SEI         ; disable IRQs
    CLD         ; disable decimal mode, not supported on NES
    LDX #$40
    STX $4017   ; disable APU frame IRQ
    LDX #$FF
    TXS         ; Set up stack
    INX         ; now X = 0
    STX $2000   ; disable NMI
    STX $2001   ; disable rendering
    STX $4010   ; disable DMC IRQs
    JSR VBLANK

CLRMEM:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    LDA #$FE
    STA $0200, x    ;move all sprites off screen
    INX
    BNE CLRMEM
    JSR VBLANK
    JMP Load_PPU
    
VBLANK:    ; First wait for vblank to make sure PPU is ready
    BIT $2002
    BPL VBLANK
    RTS

Load_PPU:
    ;LDA #%00000110
    ;STA $2001
    LDA #LOW(pal)
    STA pal_ptr
    LDA #HIGH(pal)
    STA pal_ptr + 1
    JSR Load_Palettes

    JSR Init_Data
    
    LDA #$01
    STA update_hud
    
Forever:
    JMP Forever

NMI:
    PHA
    TXA
    PHA
    TYA
    PHA
    
    ; Reset flip flop and clear VBlank flag
    LDA $2002
    JSR Update_Graphics
    
    JSR Game_Engine

End_NMI:
    LDA #%10010000  ; enable NMI, bkg pat 0, spr pat 1
    STA $2000
    LDA #%00011110  ; black bkg, enable sprites, no left clip (spr + bkg)
    STA $2001
    LDA #$00        ; no scrolling
    STA $2005
    STA $2005
    
    PLA
    TAY
    PLA
    TAX
    PLA
    
    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .include "controller.asm"
    .include "engine.asm"
    .include "collision.asm"
    .include "score.asm"
    .include "background.asm"
    .include "init.asm"
    .include "graphics.asm"
    .include "level.asm"
    .include "coins.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
pal:
    .incbin "pal/exca.pal"

    ; We need to align to $00 for loop to work
    .bank 1
    .org $E000
room0:
    .incbin "rooms/room1.map"
    .incbin "rooms/room2.map"
    .incbin "rooms/room3.map"
    
    .bank 2
    .org $0000
    .incbin "chr/spr.chr"
    .incbin "chr/bkg.chr"
