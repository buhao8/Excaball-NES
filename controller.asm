ReadController:
    ; clear remote status
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016
  
  
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA $4016 ; A
    AND #1
    BNE APressed
    LDA #0
    STA a_pressed
EndA:
    
    LDA $4016 ; B
    LDA $4016 ; SEL
    LDA $4016 ; START
    AND #1
    BNE StartPressed
    LDA #0
    STA start_pressed
EndStart:

    LDA $4016 ; UP
    LDA $4016 ; DOWN
  
    LDA $4016 ; LEFT
    AND #1
    BNE LeftPressed
EndLeft:  

    LDA $4016 ; RIGHT
    AND #1
    BNE RightPressed
EndRight:    
    
    JMP EndPressed
  
; Only jumps if !nojump, set by Collision with floor
APressed:
    ;LDA a_pressed
    ;ORA nojump
    LDA nojump
    CMP #0
    BNE EndA
    
    LDA #1
    STA nojump
    
    LDA #1
    STA a_pressed
    LDA #-2
    STA ballspeedy
    
    ;LDA ball_y
    ;SEC
    ;SBC #$01
    ;STA ball_y       ; needed to remove collision from ground before jump
    
    LDA #$00
    STA g_counter
    
    JMP EndA
    
  
LeftPressed:
    LDA ball_x
    SEC
    SBC #1
    STA ball_x
    JMP EndLeft
    
RightPressed:
    LDA ball_x
    CLC
    ADC #1
    STA ball_x
    JMP EndRight

StartPressed:
    LDA start_pressed
    CMP #$01
    BEQ EndStart
    JSR NextRoom
    LDA #$01
    STA start_pressed
    JMP EndStart

 
EndPressed:
    RTS   