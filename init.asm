Init_Data:
    LDA #$00
    STA update_hud
    STA update_bkg
    STA update_attr
Init_Player:
    LDA #$80
    STA ball_y
    LDA #$20
    STA ball_x
    LDA #$00
    STA can_jump
    
    LDA #$00        ; Tile #0
    STA $0201
    LDA #%00000000  ; No flip, in front, pal set 0
    STA $0202
Init_Gem:
    LDA #$02
    STA $0205
    LDA #%00000010
    STA $0206
Init_Coins:
    LDA #$01
    STA $0209
    STA $020D
    LDA #$00000001
    STA $020A
    STA $020E
Init_Gamestate:
    LDA #$01
    STA gamestate
Init_Gravity:
    LDA #GRAVITY_DUR
    STA grav_tick
Init_Score:
    LDA #$00
    STA score
    STA score + 1
    LDX #$00
Init_Room:
    LDA #$00
    STA level
    STA level + 1
    LDX #$00
Init_Text_Str:
    ; "SCORE   "
    LDA #$53
    STA score_str
    LDA #$43
    STA score_str + 1
    LDA #$4F
    STA score_str + 2
    LDA #$52
    STA score_str + 3
    LDA #$45
    STA score_str + 4
    LDA #$20
    STA score_str + 5
    STA score_str + 6
    STA score_str + 7
    LDA #$00
    STA score_str + 8
    ; "LEVEL   "
    LDA #$4C
    STA level_str
    LDA #$45
    STA level_str + 1
    LDA #$56
    STA level_str + 2
    LDA #$45
    STA level_str + 3
    LDA #$4C
    STA level_str + 4
    LDA #$20
    STA level_str + 5
    STA level_str + 6
    STA level_str + 7
    LDA #$00
    STA level_str + 8
Init_Level:
    LDA #$00
    STA level_bin
    LDA #$01
    STA level
    JSR Load_Level
    
Init_Data_Done:
    LDA #%10010000  ; enable NMI, bkg pat 0, spr pat 1
    STA $2000
    LDA #%00011110  ; black bkg, enable sprites, no left clip (spr + bkg)
    STA $2001
    LDA #$00        ; no scrolling
    STA $2005
    STA $2005

    RTS
