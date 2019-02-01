update_door_sprites:  ; parts of meta-sprite

    LDX door_number
    LDA updateconstants_doors, X
   ; TAX

    CLC
    ADC sprite_RAM_offset
    TAX
    
    LDA sprite_RAM, X
    STA sprite_RAM+4, X
    CLC
    ADC #$08
    STA sprite_RAM+8, X
    STA sprite_RAM+12, X
    LDA sprite_RAM+3, X
    STA sprite_RAM+11, X
    CLC
    ADC #$08
    STA sprite_RAM+7, X
    STA sprite_RAM+15, X
    
    RTS
    

door_update: ; individual meta-sprite
    LDX door_number
    LDY updateconstants_doors, X
    
    TYA
    CLC
    ADC sprite_RAM_offset
    TAY
    
    LDX #$00
    LDA door_number
    CLC
    ADC door_number
.loop
    CPX room_num
    BEQ .end
    CLC
    ADC num_doors, X
    CLC
    ADC num_doors, X
    INX
    JMP .loop
.end
    TAX
    
    
    LDA locations, X         ; X holds door_number
    STA sprite_RAM, Y        ; Y-coord
    LDA locations+1, X       ; locations+1+X = x-coord
    STA sprite_RAM+3, Y
    RTS

; called from MAIN loop
UpdateDOORS:
    LDY room_num
    LDA num_doors, Y
    STA num_doors_this_room
    CMP #0
    BEQ .end
    
    LDA #$00                         ;this loop updates the enemies one at a time in a loop
    STA door_number                 ;start with enemy zero
.loop
    LDA #$00
    STA door_ptrnumber
    JSR door_update                 ; location with no image info
    JSR update_door_sprites         ;find out which frame the enemy animation is on
    JSR door_sprites_update

    INC door_number                 ;increment the enemy number for the next trip through the loop
    INC door_ptrnumber              ;these are addresses for the graphics data, so we need to keep it at 2x the enemy number
    INC door_ptrnumber
    LDA door_number
    CMP num_doors_this_room                         ;if it is 4, we have updated enemies 0,1,2,3 so we are done
    BNE .loop
.end
    RTS
  
door_sprites_update:
    LDX door_ptrnumber
    LDA door_pointer, X
    STA doorgraphicspointer
    INX
    LDA door_pointer, X
    STA doorgraphicspointer+1
    
sub_door_sprites_update:
    LDX door_number
    LDA updateconstants_doors, X
    ;TAX
    CLC
    ADC sprite_RAM_offset
    TAX
    LDY #0
    
    ; tile for #1
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+1, X             ; Tile #, but in sprites.asm it's the whole of door
    INY
    ; tile for #2
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+5, X
    INY
    ; tile for #3
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+9, X             ; Tile #, but in sprites.asm it's the whole of door
    INY
    ; tile for #4
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+13, X
    INY
    
    ; attr for #1
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+2, X             ; attr #, but in sprites.asm it's the whole of door
    INY
    ; attr for #2
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+6, X
    INY
    ; attr for #3
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+10, X             ; attr #, but in sprites.asm it's the whole of door
    INY
    ; attr for #4
    LDA [doorgraphicspointer], Y
    STA sprite_RAM+14, X
    RTS
    
Remove_doors:
    LDY room_num
    LDA num_doors, Y
    STA num_doors_this_room
    CMP #0
    BEQ .end
    
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
.zero
    LDA #$00
    STA sprite_RAM, X
    STA sprite_RAM+1, X
    STA sprite_RAM+2, X
    STA sprite_RAM+3, X
    STA sprite_RAM+4, X
    STA sprite_RAM+5, X
    STA sprite_RAM+6, X
    STA sprite_RAM+7, X
    STA sprite_RAM+8, X
    STA sprite_RAM+9, X
    STA sprite_RAM+10, X
    STA sprite_RAM+11, X
    STA sprite_RAM+12, X
    STA sprite_RAM+13, X
    STA sprite_RAM+14, X
    STA sprite_RAM+15, X
.done
    INC door_number                 ;increment the enemy number for the next trip through the loop
    INC door_ptrnumber              ;these are addresses for the graphics data, so we need to keep it at 2x the enemy number
    INC door_ptrnumber
    LDA door_number
    CMP num_doors_this_room                         ;if it is 4, we have updated enemies 0,1,2,3 so we are done
    BNE .loop
.end
    RTS
  
  
  
locations:
                        ; room_0
    .db $9D,$90         ; room_1

updateconstants_doors:
    .db $00,$10,$20,$30
    
num_doors:
    .db $00, $01

