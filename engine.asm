
Game_Engine:
    LDA gamestate
    CMP #STATETITLE
    BEQ Engine_Title
    
    LDA gamestate
    CMP #STATEPLAYING
    BEQ Engine_Playing
    
    LDA gamestate
    CMP #STATEGAMEOVER
    BEQ Engine_Game_Over
Game_Engine_Done:
    RTS
    
Engine_Title:
    JMP Game_Engine_Done
Engine_Game_Over:
    JMP Game_Engine_Done
    
Engine_Playing:
    JSR Read_Controller
    JSR Process_Controller
    JSR Gravity
    
    JSR Update_Ball
    JSR Collision
    
    JSR Reset_User_Controlled_Vars
    JSR Update_Sprites
    JMP Game_Engine_Done
    
Gravity:
    DEC grav_tick
    BPL Gravity_End
    ; Once it goes negative
    INC ball_vy
    LDA #GRAVITY_DUR
    STA grav_tick
Gravity_End:
    RTS


Update_Ball:
    CLC
    LDA ball_x
    ADC ball_vx
    STA ball_x
    
    CLC
    LDA ball_y
    ADC ball_vy
    STA ball_y
    
    RTS
    
Reset_User_Controlled_Vars:
    LDA #$00
    STA ball_vx
    RTS
    
Update_Sprites:
    LDA ball_y
    STA $0200
    LDA ball_x
    STA $0203
    
    LDA gem_y
    STA $0204
    LDA gem_x
    STA $0207
    
    LDA coin1_y
    STA $0208
    LDA coin1_x
    STA $020B
    
    LDA coin2_y
    STA $020C
    LDA coin2_x
    STA $020F
    
    RTS
    