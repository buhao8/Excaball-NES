Load_Level:
Load_Level_Map:
    LDA #$00
    STA bkg_ptr
    LDA level_bin
    ASL A
    ASL A
    CLC
    ADC #HIGH(room0)
    STA bkg_ptr + 1
    
    LDA #%00000110
    STA $2001
    JSR Load_Background
    
    LDA #$FF
    LDX #$08
    LDY #$00
    JSR Load_Attribute
    ; red "level"
    LDA #$A0
    LDX #$08
    LDY #$08
    JSR Load_Attribute
    ; blue "score"
    LDA #$FF
    LDX #$30
    LDY #$10
    JSR Load_Attribute
Load_Level_Gem:
    LDA level_bin
    ASL A
    TAY
    LDA gems, y
    STA gem_y
    INY
    LDA gems, y
    STA gem_x
Load_Level_Coin1:
    LDA level_bin
    ASL A
    ASL A
    TAY
    LDA coins, y
    STA coin1_y
    INY
    LDA coins, y
    STA coin1_x
    INY
    LDA coins, y
    STA coin2_y
    INY
    LDA coins, y
    STA coin2_x
Load_Level_Player:
    LDA level_bin
    ASL A
    TAY
    LDA player, y
    STA ball_y
    INY
    LDA player, y
    STA ball_x
    LDA #$00
    STA ball_vx
    STA ball_vy
    STA can_jump
    LDA #GRAVITY_DUR
    STA grav_tick
Load_Level_Done:
    INC update_hud
    RTS