Init_player:
    ; ball
    ;LDA #20
    LDA #$70
    STA ball_y
    LDA #0
    STA ball_t
    LDA #%00100000
    STA ball_s
    LDA #$20
    STA ball_x
    LDA #0
    STA ballspeedx
    STA ballspeedy
    
    ; control
    LDA #0
    STA g_counter
    LDA #1
    STA nojump
    RTS