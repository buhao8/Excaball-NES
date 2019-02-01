UpdateCOINS:
    LDY room_num
    LDA num_coins, Y
    STA num_coins_this_room
    CMP #0
    BEQ .end
    
    LDA #$00                         ;this loop updates the enemies one at a time in a loop
    STA coin_number                 ;start with enemy zero
.loop
    JSR coin_update                 ; location with no image info

    INC coin_number                 ;increment the enemy number for the next trip through the loop
    LDA coin_number
    CMP num_coins_this_room                         ;if it is 4, we have updated enemies 0,1,2,3 so we are done
    BNE .loop
.end
    LDA #$0C
    STA sprite_RAM_offset           ; after coins are done, spikes are placed at $0210
    JSR gem_update
    LDA #$10
    STA sprite_RAM_offset
    JSR button_update
    LDA #$14
    STA sprite_RAM_offset
    RTS
    
coin_update: ; individual meta-sprite
    LDX coin_number
    LDY updateconstants_coins, X
    
    TYA
    CLC
    ADC sprite_RAM_offset
    TAY
    
    ; for (int i = 0; i < room_num; ++i) {
    ;     tmp += updateconstants_coins[i];
    ; }
    LDX #$00
    LDA coin_number
    CLC
    ADC coin_number
.loop
    CPX room_num
    BEQ .end
    CLC
    ADC num_coins, X
    CLC
    ADC num_coins, X
    INX
    JMP .loop
.end
    TAX
    
    
    ; location for each coin = sum[0, room_num) + locations_coin + x (where x is coin_num)
    
    LDA locations_coins, X         ; X holds coin_number
    STA sprite_RAM, Y              ; Y
    LDA locations_coins+1, X       ; locations_coins+1+X = X
    STA sprite_RAM+3, Y
    LDA #$01
    STA sprite_RAM+1, Y      ; tile #
    STA sprite_RAM+2, Y      ; attr #
    RTS
    
gem_update:
    LDY sprite_RAM_offset
    LDA #$00
    CLC
    ADC room_num
    ADC room_num
    TAX
    LDA locations_gem, X
    STA sprite_RAM, Y
    LDA locations_gem+1, X
    STA sprite_RAM+3, Y
    LDA #$02
    STA sprite_RAM+1, Y
    STA sprite_RAM+2, Y
    RTS
   
   
button_update:
    LDY sprite_RAM_offset
    LDA #$00
    CLC
    ADC room_num
    ADC room_num
    TAX
    LDA locations_button, X
    STA sprite_RAM, Y
    LDA locations_button+1, X
    STA sprite_RAM+3, Y
    LDA #$04
    STA sprite_RAM+1, Y
    LDA #$00
    STA sprite_RAM+2, Y
    RTS
    
locations_gem:
    .db $A6,$D0             ; room_0
    .db $A6,$A0             ; room_1
    
locations_coins:
    .db $96,$58,$A3,$90     ; room_0
    .db $90,$40,$90,$88     ; room_1

updateconstants_coins:
    .db $00,$04
    
num_coins:
    .db $02, $02
    
locations_button:
    .db $FF,$FF             ; room_0
    .db $A6,$60             ; room_1 
    