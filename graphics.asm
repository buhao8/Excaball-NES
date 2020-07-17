Update_Graphics:
    ; Sprite DMA transfer
    ; Addresses $0200-$02FF
    ; 64 sprites * 4 bytes each = 256 bytes
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014   ; start transfer
    LDA update_hud
    BEQ Update_Graphics_Done
    JSR Draw_HUD
    DEC update_hud
Update_Graphics_Done:
    RTS
    
    
Draw_HUD:
    JSR Draw_Level
    JMP Draw_Score
    
    
Draw_Level:
    LDA #LOW(level_str)
    STA ptr_16
    LDA #HIGH(level_str)
    STA ptr_16 + 1
    
    LDY #$06
    LDA level + 1
    BEQ Draw_Level_Single_Digit
    CLC
    ADC #$30
    STA [ptr_16], y
    INY
Draw_Level_Single_Digit:
    LDA level
    CLC
    ADC #$30
    STA [ptr_16], y
    ; Attr #$A0, offset #$C2
    LDX #$A0
    LDA #$82
    JMP Draw_Text
    
Draw_Score:
    LDA #LOW(score_str)
    STA ptr_16
    LDA #HIGH(score_str)
    STA ptr_16 + 1
    
    LDY #$06
    LDA score + 1
    BEQ Draw_Score_Single_Digit
    CLC
    ADC #$30
    STA [ptr_16], y
    INY
Draw_Score_Single_Digit:
    LDA score
    CLC
    ADC #$30
    STA [ptr_16], y
    ; Attr #$A0, offset #$C2
    LDX #$A0
    LDA #$C2
    JMP Draw_Text
    
    
    ; @param A          nametable offset
    ; @param ptr_16     pointer to str addr
    ; @param X          Attr value
Draw_Text:
    PHA         ; offset in nametable
    LDA $2002
    LDA #$20
    STA $2006
    PLA
    STA $2006
    PHA
    LDY #$00
Draw_Text_Loop:
    LDA [ptr_16], y
    BEQ Draw_Text_Attr
    STA $2007
    INY
    JMP Draw_Text_Loop
Draw_Text_Attr:
    ; Attr line start = nametable_off / 128 * 8
    ; This will effectively block out the whole 4 rows
    PLA
    RTS
    
    
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ASL A
    ASL A
    ASL A
    TAY
    TXA
    LDX #$04
    JMP Load_Attribute
    