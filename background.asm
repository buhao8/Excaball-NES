    ; @param pal_ptr    pointer to palette addr
Load_Palettes:
    ; $2002 is PPU status
    ; $2006 sets PPU address
    ; $3F10 is palette start address
    ; Why do we start at $3F00???
    ; address autoincrements after write
    LDA $2002   ; read PPU status to reset latch to high
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006
    LDY #$00
Load_Palettes_Loop:
    LDA [pal_ptr], y
    STA $2007
    INY
    CPY #$20
    BNE Load_Palettes_Loop
    RTS

    ; @param bkg_ptr    pointer to bkg addr
Load_Background:
    ; $2000 is background
    LDA $2002
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006
    
    LDA bkg_ptr
    STA ptr_16
    LDA bkg_ptr + 1
    STA ptr_16 + 1
    
    LDX #$00
    LDY #$00
Load_Background_Loop:
    LDA [ptr_16], y
    STA $2007
    INY
    CPY #$00
    BNE Load_Background_Loop
    INC ptr_16 + 1
    INX
    CPX #$04    ; 256 * 4 = 1024, however we use only 32 x 30 = 960
                ; This means we write into attribute space...
                ; Attributes MUST be reloaded when loading a background
    BNE Load_Background_Loop
    RTS

    ; @param A  attribute value
    ; @param X  attribute length
    ; @param Y  attribute offset
Load_Attribute:
    ; $23C0 is $2000 + 960d
    ; Should already be here...
    PHA         ; push attr val
    LDA $2002
    LDA #$23
    STA $2006
    TYA
    CLC
    ADC #$C0    ; add offset
    STA $2006
    ;DEX
    PLA         ; pop attr val
Load_Attribute_Loop:
    STA $2007
    DEX
    BNE Load_Attribute_Loop
    RTS
