
;; DECLARE SOME VARIABLES HERE
    .rsset $0000  ;;start variables at ram location 0

room_num    .rs 1  ; room number pointer

gamestate   .rs 1  ; .rs 1 means reserve one byte of space
ballmove    .rs 1  ; ball is being moved by player
ballspeedx  .rs 1  ; ball horizontal speed per frame
ballspeedy  .rs 1  ; ball vertical speed per frame
score       .rs 1  ; player 1 score, 0-15
deaths      .rs 1  ; player 2 score, 0-15

a_pressed   .rs 1  ; has a been pressed?
start_pressed   .rs 1  ; has a been pressed?
g_counter   .rs 1  ; only increase gravity every X cycles
nojump      .rs 1  ; set true when hits ground

pointerLo   .rs 1  ; Low pointer of bkg
pointerHi   .rs 1  ; High pointer of bkg

NMI_flag    .rs 1  ; NMI_FLAG


sprite_RAM_offset   .rs 1

; doors
door_number     .rs 1        ;enemy number for direction routine 0=Crewman, 1=punisher, 2=McBoobins, 3=ArseFace
door_ptrnumber  .rs 1        ;enemy pointer number (i.e. 2x the enemy number, 0=Crewman, 2=punisher, 4=McBoobins, 6=ArseFace)
door_pointer    .rs 2
doorgraphicspointer .rs 2
num_doors_this_room .rs 1

; coins
coin_number         .rs 1
coin_pointer        .rs 2
num_coins_this_room .rs 1

num_buttons_this_room .rs 1

; control for maps
temp_maps           .rs 1
maps_dir            .rs 1   ; up down left right
current_block       .rs 1
block_right         .rs 1   ; are these needed?
block_down          .rs 1
block_left          .rs 1
block_up            .rs 1
temp_y              .rs 1
temp_x              .rs 1

temp_var			.rs 1

;control for collisions
door_temp           .rs 1
door_temp2          .rs 1
door_down           .rs 1
door_right          .rs 1

math_temp           .rs 1

up_down             .rs 1         ; ball y direction, 0 = up 1 = down 2 = apex

last_speed          .rs 1


sprite_RAM     = $0200




;; DECLARE SOME CONSTANTS HERE
STATETITLE     = $00  ; displaying title screen
STATEPLAYING   = $01  ; move ball, check for collisions
STATEGAMEOVER  = $02  ; displaying game over screen

RIGHTWALL      = $FF  ; used to be $D0 used to be $F5 when ball reaches one of these, do something
TOPWALL        = $08
BOTTOMWALL     = $A6  ; used to be $A6  [old:]$D0
LEFTWALL       = $18  ; used to be $03

;sprite_RAM = $0204