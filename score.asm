    ; @param ptr_16     16-bit ptr to number
Increment_16:
    ; Increment 1's column
    ; If overflow, check 10's column
    ; If 10's column == 9, then set 1's to 9
    ; else increment 10's and set 1's to 0
    LDY #$00
    LDA [ptr_16], y
    CLC
    ADC #$01
    STA [ptr_16], y
    CMP #$0A
    BCC Increment_16_Done
    LDY #$01
    LDA [ptr_16], y
    CMP #$09
    BCS Increment_16_Set_Ones_Nine
    CLC
    ADC #$01
    STA [ptr_16], y
    LDA #$00
    LDY #$00
    STA [ptr_16], y
    JMP Increment_16_Done
Increment_16_Set_Ones_Nine:
    LDY #$00
    LDA #$09
    STA [ptr_16], y
Increment_16_Done:
    RTS
    
Increment_Level:
    INC level_bin
    LDA #LOW(level)
    STA ptr_16
    LDA #HIGH(level)
    STA ptr_16 + 1
    JMP Increment_16    ; Eliminate JSR + RTS
    
    
Increment_Score:
    LDA #LOW(score)
    STA ptr_16
    LDA #HIGH(score)
    STA ptr_16 + 1
    JMP Increment_16    ; Eliminate JSR + RTS
    