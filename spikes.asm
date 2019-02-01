update_spike_sprites:  ; parts of meta-sprite

    LDX spike_number
    LDA updateconstants_spikes, X
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
    

spike_update: ; individual meta-sprite
    LDX spike_number
    LDY updateconstants_spikes, X
    
    TYA
    CLC
    ADC sprite_RAM_offset
    TAY
    
    LDX #$00
    LDA spike_number
    CLC
    ADC spike_number
.loop
    CPX room_num
    BEQ .end
    CLC
    ADC num_spikes, X
    CLC
    ADC num_spikes, X
    INX
    JMP .loop
.end
    TAX
    
    
    LDA locations, X         ; X holds spike_number
    STA sprite_RAM, Y        ; Y-coord
    LDA locations+1, X       ; locations+1+X = x-coord
    STA sprite_RAM+3, Y
    RTS

; called from MAIN loop
UpdateSPIKES:
    LDY room_num
    LDA num_spikes, Y
    STA num_spikes_this_room
    CMP #0
    BEQ .end
    
    LDA #$00                         ;this loop updates the enemies one at a time in a loop
    STA spike_number                 ;start with enemy zero
.loop
    LDA #$00
    STA spike_ptrnumber
    JSR spike_update                 ; location with no image info
    JSR update_spike_sprites         ;find out which frame the enemy animation is on
    JSR spike_sprites_update

    INC spike_number                 ;increment the enemy number for the next trip through the loop
    INC spike_ptrnumber              ;these are addresses for the graphics data, so we need to keep it at 2x the enemy number
    INC spike_ptrnumber
    LDA spike_number
    CMP num_spikes_this_room                         ;if it is 4, we have updated enemies 0,1,2,3 so we are done
    BNE .loop
.end
    RTS
  
spike_sprites_update:
    LDX spike_ptrnumber
    LDA spike_pointer, X
    STA spikegraphicspointer
    INX
    LDA spike_pointer, X
    STA spikegraphicspointer+1
    
sub_enemy_sprites_update:
    LDX spike_number
    LDA updateconstants_spikes, X
    ;TAX
    CLC
    ADC sprite_RAM_offset
    TAX
    LDY #0
    
    ; tile for #1
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+1, X             ; Tile #, but in sprites.asm it's the whole of spike
    INY
    ; tile for #2
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+5, X
    INY
    ; tile for #3
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+9, X             ; Tile #, but in sprites.asm it's the whole of spike
    INY
    ; tile for #4
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+13, X
    INY
    
    ; attr for #1
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+2, X             ; attr #, but in sprites.asm it's the whole of spike
    INY
    ; attr for #2
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+6, X
    INY
    ; attr for #3
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+10, X             ; attr #, but in sprites.asm it's the whole of spike
    INY
    ; attr for #4
    LDA [spikegraphicspointer], Y
    STA sprite_RAM+14, X
    
    
    RTS
  
  
  
locations:
    .db $95,$80,$95,$70,$95,$60
    .db $95,$50,$95,$80

updateconstants_spikes:
    .db $00,$10,$20,$30
    
num_spikes:
    .db $03, $02

