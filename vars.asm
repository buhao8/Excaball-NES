    ; Store vars in zeropage
    .rsset $0000
;;; Background and relevant pointers
ptr_16      .rs 2
bkg_ptr     .rs 2
pal_ptr     .rs 2


;;; Buttons
buttons     .rs 1
last_buttons .rs 1

;;; Game state
gamestate   .rs 1

;; Player
ball_x      .rs 1
ball_y      .rs 1
ball_vx     .rs 1
ball_vy     .rs 1

;; Coins and Gem
gem_x       .rs 1
gem_y       .rs 1
coin1_x     .rs 1
coin1_y     .rs 1
coin2_x     .rs 1
coin2_y     .rs 1

;;; Gravity
grav_tick   .rs 1
can_jump    .rs 1

;;; Collision
block_y     .rs 1   ; y', relative to Y * 64
block_x     .rs 1   ; x'
detect_y    .rs 1   ; Y
detect_x    .rs 1   ; X
; Used for Get_Pixel
pixel_y     .rs 1
pixel_x     .rs 1

;;; Other
tmp         .rs 1

;;; Score and level info
level_bin   .rs 1
score       .rs 2
level       .rs 2
level_str   .rs 9
score_str   .rs 9

;;; Graphics updates
soft2000    .rs 1
soft2001    .rs 1    
update_hud  .rs 1
update_bkg  .rs 1
update_attr .rs 1

;;; Constants
STATETITLE    = $00
STATEPLAYING  = $01
STATEGAMEOVER = $02

GRAVITY_DUR   = $03
SS_DUR        = $1A

