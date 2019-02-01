    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; mapper 0 = NROM, no bank swapping
    .inesmir 2   ; single screen
    
  
    .bank 1
    .org $FFFA     ;first of the three vectors starts here
    .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
    .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
    .dw 0          ;external interrupt IRQ is not used
;;;;;;;;;;;;;;  
    .bank 0
    .org $0200 ; OAM Copy location $0200
ball_y:      .db  0   ; Y value
ball_t:      .db  0   ; Tile Number
ball_s:      .db  0   ; special byte
ball_x:      .db  0   ; X value
;;;;;;;;;;;;;;;;;;


    .org $8000 

RESET:
    SEI          ; disable IRQs
    CLD          ; disable decimal mode
    LDX #$40
    STX $4017    ; disable APU frame IRQ
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    STX $2000    ; disable NMI
    STX $2001    ; disable rendering
    STX $4010    ; disable DMC IRQs


;;;;;;;;;;;;;;  
vblankwait1:
    BIT $2002
    BPL vblankwait1
;;;;;;;;;;;;;;

clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    DEX
    CPX #$00
    BNE clrmem
;;;;;;;;;;;;;;  
vblankwait2:
    BIT $2002
    BPL vblankwait2
;;;;;;;;;;;;;;
    
LoadPPU:

LoadPalettes:
    LDA $2002             ; read PPU status to reset the high/low latch
    LDA #$3F
    STA $2006             ; write the high byte of $3F00 address
    LDA #$00
    STA $2006             ; write the low byte of $3F00 address
    LDX #$00
LoadPalettesLoop:         ; palette entry #0 is GOD and copied every 4 bytes
    LDA ourpal, X
    STA $2007             ; write to PPU
    INX
    CPX #$20              ; Compare X to hex $20, decimal 32 - copying 32 bytes = 8 sprites
    BNE LoadPalettesLoop

InitVars:

    ; Init meta-sprites FIRST THING
    ; meta-sprite pointers
    LDA #LOW(door_graphics)
    STA door_pointer
    LDA #HIGH(door_graphics)
    STA door_pointer+1
    
    
    
    
    LDA #$00
    STA room_num
    JSR switchMap
    
    ; controller
    STA a_pressed
    STA start_pressed
    
    
    

;;:Set starting game state
    LDA #STATEPLAYING
    STA gamestate 
    
SetupNMI:
    LDA #%10001000   ; enable NMI, sprites from Pattern Table 1, background from Pattern Table 0
    STA $2000
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side, no color bias
    STA $2001
    
    LDA #$01
    STA NMI_flag     ; Enable (user-defined) NMI flag

Forever:
    JMP Forever
 

NMI:
LoadAndWriteSprites:    
    LDA #0
    STA $2003       ; set the low byte (00) of the RAM address
    LDA #2
    STA $4014       ; set the high byte (02) of the RAM address, start the transfer
   
    ; push AXY to stack
    PHA
    TXA
    PHA
    TYA
    PHA
    
    ; if (NMI_flag) do_graphics else game_engine
    LDX NMI_flag
    CPX #$01
    BNE FlagClear
    
FlagSet:
    LDA #$00              ; disable rendering
    STA $2001


LoadNames:
    LDA $2002             ; reset PPU latch
    LDA #$20              ; start at $2000
    STA $2006
    LDA #$00
    STA $2006
    
    LDX #$04
    LDY #$00
    LDA pointerHi
    PHA
    
    ; 256pixels/row * 1block/8pixels = 32 blocks/row
    ; 240pixels/column * 1block/8pixels = 30 blocks/column
    ; If we consider loading linearly left to write, we overflow 8bits at 256.
    ; So we have 8 blocks until overflow in pointerLo
    ; This means we need 3.75x pointerLo of loading into $2007
    ; We do this by incrementing pointerHi each overflow 4x >= 3.75
    
LoadNamesLoop:
    LDA [pointerLo], y
    STA $2007
    INY
    BNE LoadNamesLoop
    INC pointerHi
    DEX
    BNE LoadNamesLoop

BackgroundLoopDone:
    PLA
    STA pointerHi
    LDA #$00
    STA NMI_flag
    JMP EndNMI  ; drawing is done
    
FlagClear:
    JSR ReadController     ; do the game engine
    JSR GameEngine         ; PPU already written to previously
    LDA #%00011110         ; re-enable rendering
    STA $2001

    
EndNMI:
    ; pop restore AXY
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
    
;;;;;;;;;;;;;;
    .include "player.asm"
    .include "coins.asm"
    .include "engine.asm"
    .include "controller.asm"
    .include "includes.asm"
    .include "maps.asm"
    .include "sprites.asm"
    .include "doors.asm"
;;;;;;;;;;;;;;

ourpal: .incbin "exca.pal"
firstmap: 
    .incbin "rooms\room1.map"
secondmap: 
    .incbin "rooms\room2.map"
thirdmap: 
    .incbin "rooms\room3.map"
    
;;;;;;;;;;;;;;
    .bank 2
    .org $0000

    .incbin "CHR\bkg.chr"
    .incbin "CHR\spr.chr"