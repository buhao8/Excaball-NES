    ; Port 1 - $4016
    ; Port 2 - $4017
    ; Write #$01 then #$00 to $4016 to latch buttons
    ; A, B, Sel, Start, U, D, L, R    
Read_Controller:    
    LDA buttons
    STA last_buttons
    
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016
    LDX #$08
        
Read_Controller_Loop:
    LDA $4016
    LSR A       ; Capture bit 0 in carry
    ROL buttons ; Shift data left and add carry
    DEX
    BNE Read_Controller_Loop

    RTS
    
;;; CONTROLLER LOGIC ;;;
Process_Controller:
Read_A:
    LDA buttons
    AND #$80
    BEQ Read_B
    LDA can_jump
    BEQ Read_B
    DEC can_jump
    ; Jumping means we've landed, do NOT do this in Collision_Down
    ; Scenario: We've been on the ground for awhile, gravity_tick keeps
    ;           ping-ponging between GRAVITY_DUR and GRAVITY_DUR - 1
    LDA #GRAVITY_DUR
    STA grav_tick
    LDA #$FC
    STA ball_vy
Read_B:
    ;LDA buttons
    ;AND #$40
    ;BEQ Read_Start
Read_Select:
    LDA buttons
    AND #$20
    BEQ Read_Start
    LDA last_buttons
    AND #$20
    BNE Read_Start
    JSR Increment_Level
    INC update_hud
    JSR Load_Level
    ;LDA last_sel
    ;BNE Read_Up
    ;JSR Increment_Level
Read_Start:
    LDA buttons
    AND #$10
    BEQ Read_Up
    LDA last_buttons
    AND #$10
    BNE Read_Up
    JSR Increment_Score
    INC update_hud
Read_Up:
    ;LDA buttons
    ;AND #$08
    ;BEQ Read_Down
Read_Down:
    LDA buttons
    AND #$04
    BEQ Read_Left
Read_Left:
    LDA buttons
    AND #$02
    BEQ Read_Right
    LDA #$FF
    STA ball_vx
Read_Right:
    LDA buttons
    AND #$01
    BEQ Read_Done
    LDA #$01
    STA ball_vx
Read_Done:
    RTS
