    ; @param None
Collision_Gem:
    ;;; x bounding box
    LDA ball_x
    CLC
    ADC #$06
    CMP gem_x
    BCC Collision_Gem_Exit ; ball_x + 8 < gem_x 
    LDA gem_x
    CLC
    ADC #$06
    CMP ball_x
    BCC Collision_Gem_Exit ; gem_x + 8 < ball_x
    ;;; y bounding box
    LDA ball_y
    CLC
    ADC #$06
    CMP gem_y
    BCC Collision_Gem_Exit ; ball_y + 8 < gem_y
    LDA gem_y
    CLC
    ADC #$06
    CMP ball_y
    BCC Collision_Gem_Exit ; gem_y + 8 < ball_y
    ;;; It's a collision
    JSR Increment_Level
    JMP Load_Level
    INC update_hud
Collision_Gem_Exit:
    JMP Collision_Coin1

    ; @param None
Collision_Coin1:
    ;;; x bounding box
    LDA ball_x
    CLC
    ADC #$06
    CMP coin1_x
    BCC Collision_Coin1_Exit ; ball_x + 8 < gem_x 
    LDA coin1_x
    CLC
    ADC #$06
    CMP ball_x
    BCC Collision_Coin1_Exit ; gem_x + 8 < ball_x
    ;;; y bounding box
    LDA ball_y
    CLC
    ADC #$06
    CMP coin1_y
    BCC Collision_Coin1_Exit ; ball_y + 8 < gem_y
    LDA coin1_y
    CLC
    ADC #$06
    CMP ball_y
    BCC Collision_Coin1_Exit ; gem_y + 8 < ball_y
    ;;; It's a collision
    JSR Increment_Score
    LDA #$F8
    STA coin1_y
    STA coin1_x
    INC update_hud
Collision_Coin1_Exit:
    JMP Collision_Coin2
    ; @param None
    
Collision_Coin2:
    ;;; x bounding box
    LDA ball_x
    CLC
    ADC #$06
    CMP coin2_x
    BCC Collision_Coin2_Exit ; ball_x + 8 < gem_x 
    LDA coin2_x
    CLC
    ADC #$06
    CMP ball_x
    BCC Collision_Coin2_Exit ; gem_x + 8 < ball_x
    ;;; y bounding box
    LDA ball_y
    CLC
    ADC #$06
    CMP coin2_y
    BCC Collision_Coin2_Exit ; ball_y + 8 < gem_y
    LDA coin2_y
    CLC
    ADC #$06
    CMP ball_y
    BCC Collision_Coin2_Exit ; gem_y + 8 < ball_y
    ;;; It's a collision
    JSR Increment_Score
    LDA #$F8
    STA coin2_y
    STA coin2_x
    INC update_hud
Collision_Coin2_Exit:
    JMP Collision_Y
    
    
; @param None
Collision:
    JMP Collision_Gem   ; this will check coins as well
Collision_Y:
    LDA ball_vy
    BEQ Collision_X_Help    ; vy == 0
    BPL Collision_Down      ; vy >= 0
    JMP Collision_Up
Collision_X_Help:
    JMP Collision_X
Collision_Up:
    LDA ball_y
    STA pixel_y
Collision_Up_Right:
    LDA ball_x
    CLC
    ADC #$06
    STA pixel_x
    
    JSR Get_Pixel
    BEQ Collision_Up_Left
    JMP Collision_Up_True
Collision_Up_Left:
    LDA ball_x
    CLC
    ADC #$01
    STA pixel_x
    JSR Get_Pixel
    BEQ Collision_X
Collision_Up_True:
    LDA ball_y
    CLC
    ADC #$05
    AND #$F8
    STA ball_y
    
    LDA #$00
    STA ball_vy
    STA can_jump
    LDA #GRAVITY_DUR
    STA grav_tick
    JMP Collision_X
Collision_Down:
    LDA ball_y
    CLC
    ADC #$07
    STA pixel_y
Collision_Down_Right:
    LDA ball_x
    CLC
    ADC #$06
    STA pixel_x
    
    JSR Get_Pixel
    BEQ Collision_Down_Left
    JMP Collision_Down_True
Collision_Down_Left:
    LDA ball_x
    CLC
    ADC #$01
    STA pixel_x
    JSR Get_Pixel   ; background block -> A
    BEQ Collision_X
Collision_Down_True:
    ; Set ball position to current % 8
    ; This should readjust ball to go up
    LDA ball_y
    AND #$F8
    STA ball_y
    
    LDA #$00
    STA ball_vy
    LDA #$01
    STA can_jump
    LDA #GRAVITY_DUR
    STA grav_tick
    
Collision_X:
    LDA ball_vx
    BEQ Collision_Done     ; vx == 0
    BPL Collision_Right ; vx >= 0
Collision_Left:
    LDA ball_x
    STA pixel_x
Collision_Left_Top:
    LDA ball_y
    CLC
    ADC #$01
    STA pixel_y
    JSR Get_Pixel
    BEQ Collision_Left_Bot
    JMP Collision_Left_True
Collision_Left_Bot:
    LDA ball_y
    CLC
    ADC #$06    ; < 8
    STA pixel_y
    JSR Get_Pixel
    BEQ Collision_Done
Collision_Left_True:
    LDA ball_x
    CLC
    ADC #$05    ; arbitrary < 8
    AND #$F8
    STA ball_x
    LDA #$00
    STA ball_vx
    JMP Collision_Done
Collision_Right:
    LDA ball_x
    CLC
    ADC #$07
    STA pixel_x
Collision_Right_Top:
    LDA ball_y
    CLC
    ADC #$01
    STA pixel_y
    JSR Get_Pixel
    BEQ Collision_Right_Bot
    JMP Collision_Right_True
Collision_Right_Bot:
    LDA ball_y
    CLC
    ADC #$06    ; < 8
    STA pixel_y
    JSR Get_Pixel
    BEQ Collision_Done
Collision_Right_True:
    LDA ball_x
    AND #$F8
    STA ball_x
    LDA #$00
    STA ball_vx
    ;JMP Collision_Y
Collision_Done:
    RTS
    
    
    
    ; @param pixel_y    y in screen pixels
    ; @param pixel_x    x in screen pixels
Get_Pixel:
    ; Check Bottom left and Bottom right
    ; Calculate Y from bottom of ball
    ; Y = y px / (64 px / quarter-block)
    LDA pixel_y
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    STA detect_y    ; # quarter-block
    TAY
    
    ; Calculate X from ball left
    ; X = diff from quarterbound / (8 px / bkg-block) * 32 bkg-block width + x'
    ; Calculate x' = x / 8
    LDA pixel_x
    LSR A
    LSR A
    LSR A
    STA block_x
    
    ; (y - Y * 64) / 8 * 32
    LDA detect_y
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    STA tmp
    LDA pixel_y
    SEC
    SBC tmp
    LSR A
    LSR A
    LSR A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ; x' +
    CLC
    ADC block_x
    STA detect_x
    TAX    
    
    LDA bkg_ptr
    TXA
    CLC
    ADC bkg_ptr
    STA ptr_16
    
    LDA bkg_ptr + 1
    TYA
    CLC
    ADC bkg_ptr + 1
    STA ptr_16 + 1
    
    LDY #$0
    LDA [ptr_16], y
    RTS
    