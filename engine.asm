GameEngine:  
    LDA gamestate
    CMP #STATETITLE
    BEQ EngineTitle
   
    LDA gamestate
    CMP #STATEGAMEOVER
    BEQ EngineGameOver
  
    LDA gamestate
    CMP #STATEPLAYING
    BEQ EnginePlaying
GameEngineDone:
    RTS
 
;;;;;;;;;
 
EngineTitle:
    ;;if start button pressed
    ;;  turn screen off
    ;;  load game screen
    ;;  go to Playing State
    ;;  turn screen on
    JMP GameEngineDone

;;;;;;;;; 
 
EngineGameOver:
    ;;if start button pressed
    ;;  turn screen off
    ;;  load title screen
    ;;  go to Title State
    ;;  turn screen on 
    JMP GameEngineDone
 
;;;;;;;;;

spike_hit:
    JSR switchMap
    JMP GameEngineDone

EnginePlaying:
    LDA ball_y
    PHA
    LDA ball_x
    PHA
    LDA #$01
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    AND $2002
    JMP ._continue

    
    
._continue
; 0 - up
; 1 - down
; 2 - apex
.override
    JMP Gravity
    
    ; Stuff here not done
    LDA #$01
    STA ballspeedy
    LDA #$01
    STA up_down
    JMP GravityStep
Gravity:
    LDA g_counter
    CMP #10
    BCC GravityStep
    LDA #0
    STA g_counter
    LDA ballspeedy
    CLC
    ADC #1
    STA ballspeedy
    CMP #$00
    BEQ .set_apex
    BCC .set_up
    LDA #$01
    STA up_down
    JMP GravityStep
.set_apex
    LDA #$02
    STA up_down
    JMP GravityStep
.set_up
    LDA #$00
    STA up_down
    JMP GravityStep
    
GravityStep:
    LDA nojump
    CMP #0
    BEQ .reset_because_on_surface
    JMP .inc_g_counter
    ;.done_gravity_step
.reset_because_on_surface
    LDA #$01
    STA g_counter
    STA ballspeedy
.inc_g_counter
    LDA ball_y
    CLC
    ADC ballspeedy
    STA ball_y
    
    LDA ballspeedy
    STA last_speed
    
    
    INC g_counter
.done_gravity_step
    ;JMP GameEngineDone
    ;JMP CheckGemCollision
    ;JMP CheckUp

    
CorrectCollisions:

; if going down, check_down. if up, check_up
; if stationary, treat it as neither up nor down
; ==> this prevents getting stuck 


.check_right:
    LDA #$00
    JSR GetPixel
    LDA current_block
    CMP #$01
    BNE .check_down_pop_x
    PLA                 ; pop ball_x
    STA ball_x
    DEC ball_x ;; is it needed?
    JMP .check_down
    
    
.check_down_pop_x
    PLA                     ; pop y because prev didn't
.check_down:
    LDA ballspeedy
    CMP #0
    BEQ .done_pop
    BCS .continue_down
    JMP .check_up
    ; Check down block
    ; If collision, then pop ball_y and reset gravity
.continue_down
    LDA #$01
    JSR GetPixel
    LDA current_block
    CMP #$01
    BNE .done_pop    ; if not ground, go to check_right (we can't check up if we got here b/c we're travelling down)
    PLA                     ; pop ball_y
    STA ball_y
    
    LDA #$00            ; reset gravity
    STA ballspeedy
    STA nojump
    STA g_counter
    JMP .done

; always check_right after check_down or check_up
; if no collision up, go to check_right.
; if done, go to check_right
.check_up:
    LDA #$03
    JSR GetPixel
    LDA current_block
    CMP #$01
    BNE .done_pop
    PLA
    STA ball_y
    ;PLA
    LDA #$00
    STA ballspeedy
    LDA #$01
    STA nojump
    ;JMP .done
   

   
.check_left:
    ;LDA #$02
    ;JSR GetPixel
    ;LDA current_block
    ;CMP #$01
    ;BNE .done_pop
    ;PLA ball_x
    ;
    ;LDA #$00
    ;STA 
    
    
    ;JSR CheckRight
    ;JSR CheckLeft
    ;JSR CheckUp
    ;JSR CheckDown
.done_pop
    PLA             ; pop x because prev didn't
.done
    JMP CheckGemCollision


;; COLLISION GEM
CheckGemCollision:
    LDX ball_x
    LDY ball_y
    CPX $020F             ; gem X
    BCC .left
.right
    TXA
    SEC
    SBC $020F
    CMP #$08
    BCC .right_collision
    JMP .done
.right_collision
    JMP .check_y
.left
    TXA
    SEC
    SBC $020F
    CMP #$F9
    BCS .left_collision
    JMP .done
.left_collision
.check_y
    CPY $020C             ; gem Y
    BCC .top
    JMP .bottom
.top
    TYA
    SEC
    SBC $020C
    CMP #$F9
    BCS .top_collision
    JMP .done
.top_collision
    JMP .clear
.bottom
    TYA
    SEC
    SBC $020C
    CMP #$08
    BCC .bottom_collision
    JMP .done
.bottom_collision
.clear    
    LDA #$00
    STA $020C
    STA $020D
    STA $020E
    STA $020F
    JSR NextRoom
    RTS
.done

CheckButtonCollision:
    LDX ball_x
    LDY ball_y
    CPX $0213             ; gem X
    BCC .left
.right
    TXA
    SEC
    SBC $0213
    CMP #$08
    BCC .right_collision
    JMP .done
.right_collision
    JMP .check_y
.left
    TXA
    SEC
    SBC $0213
    CMP #$F9
    BCS .left_collision
    JMP .done
.left_collision
.check_y
    CPY $0210             ; gem Y
    BCC .top
    JMP .bottom
.top
    TYA
    SEC
    SBC $0210
    CMP #$F9
    BCS .top_collision
    JMP .done
.top_collision
    JMP .clear
.bottom
    TYA
    SEC
    SBC $0210
    CMP #$08
    BCC .bottom_collision
    JMP .done
.bottom_collision
.clear    
    LDA #$00
    STA $0210
    STA $0211
    STA $0212
    STA $0213
    JSR Remove_doors
    RTS
.done

;; COLLISION COIN 1
CheckCoinCollision1:
    LDX ball_x
    LDY ball_y
    CPX $0207             ; coin1 X
    BCC .left
.right
    TXA
    SEC
    SBC $0207
    CMP #$08
    BCC .right_collision
    JMP .done
.right_collision
    JMP .check_y
.left
    TXA
    SEC
    SBC $0207
    CMP #$F9
    BCS .left_collision
    JMP .done
.left_collision
.check_y
    CPY $0204             ; coin1 Y
    BCC .top
    JMP .bottom
.top
    TYA
    SEC
    SBC $0204
    CMP #$F9
    BCS .top_collision
    JMP .done
.top_collision
    JMP .clear
.bottom
    TYA
    SEC
    SBC $0204
    CMP #$08
    BCC .bottom_collision
    JMP .done
.bottom_collision
.clear
    LDA #$00
    STA $0204
    STA $0205
    STA $0206
    STA $0207
    RTS
.done


;; COLLISION COIN 2
CheckCoinCollision2:
    LDX ball_x
    LDY ball_y
    CPX $020B             ; coin2 X
    BCC .left
.right
    TXA
    SEC
    SBC $020B
    CMP #$08
    BCC .right_collision
    JMP .done
.right_collision
    JMP .check_y
.left
    TXA
    SEC
    SBC $020B
    CMP #$F9
    BCS .left_collision
    JMP .done
.left_collision
.check_y
    CPY $020B             ; coin2 Y
    BCC .top
    JMP .bottom
.top
    TYA
    SEC
    SBC $0208
    CMP #$F9
    BCS .top_collision
    JMP .done
.top_collision
    JMP .clear
.bottom
    TYA
    SEC
    SBC $0208
    CMP #$08
    BCC .bottom_collision
    JMP .done
.bottom_collision
.clear
    LDA #$00
    STA $0208
    STA $0209
    STA $020A
    STA $020B
    RTS
.done

CheckDoorCollision:
    LDA #$14
    STA sprite_RAM_offset
    LDX ball_x
    LDY ball_y
    
    LDY room_num
    LDA num_doors, Y
    STA num_doors_this_room
    CMP #0
    BNE .next
    JMP .finished_door

.next    
    LDA #$00                         ;this loop updates the enemies one at a time in a loop
    STA door_number                 ;start with enemy zero
.loop
    LDA #$00
    STA door_ptrnumber
    LDX door_number
    LDA updateconstants_doors, X
    CLC
    ADC sprite_RAM_offset
    TAX

.check_right           ; ball coords
    LDA ball_y
    CMP sprite_RAM, X
    BCC .check_up
    SEC
    SBC #$0E   ; was #$10
    CMP sprite_RAM, X
    BCS .check_up
    
    LDA ball_x
    CLC
    ADC #$07
    CMP sprite_RAM+3, X
    BNE .check_left
    
    LDA sprite_RAM+3, X
    SEC
    SBC #$08
    STA ball_x
    JMP .check_up
.check_left
    ; pre-reqs for Y done by .check_right
    LDA ball_x
    SEC
    SBC #$0F
    CMP sprite_RAM+3, X
    BNE .done
    
    LDA sprite_RAM+3, X
    CLC
    ADC #$10
    STA ball_x
    JMP .check_up
.check_up                 ; ball coords
.check_down               ; ball coords
    LDA ball_x
    CLC
    ADC #$07
    CMP sprite_RAM+3, X
    BCC .done
    SEC
    SBC #$17              ; ball_x + 8 - 32 = -24
    CMP sprite_RAM+3, X
    BCS .done
    
    LDA ball_y
    CLC
    ADC #$07
    CMP sprite_RAM, X
    BCC .done
    SEC
    SBC #$08            ; ball+7-15 = -8
    BCC .done
    
    LDA sprite_RAM, X
    SEC
    SBC #$08
    STA ball_y
    LDA #$00
    STA g_counter
    STA nojump
    STA ballspeedy
    
.done
    INC door_number                 ;increment the enemy number for the next trip through the loop
    INC door_ptrnumber              ;these are addresses for the graphics data, so we need to keep it at 2x the enemy number
    INC door_ptrnumber
    LDA door_number
    CMP num_doors_this_room                         ;if it is 4, we have updated enemies 0,1,2,3 so we are done
    BEQ .finished_door
    JMP .loop
.finished_door    

    JMP GameEngineDone
    
    
    
    ; For X: check both y's, then check left-x of block for right ball
    ; For Y: check both x's, then check up-x of block for down ball
