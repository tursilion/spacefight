; This is a 2-line kernel!
; Options no_blank_lines and pfcolors set
; standard kernel with the undef'd stuff removed so I can see what it does
; modified by M.Brent
; still a line problem with pfcolors, and the top line isn't perfect either

kernel
 sta WSYNC
 lda #255
 sta TIM64T

 lda #1
 sta VDELBL
 sta VDELP0

 ldx ballheight
 inx
 inx
 stx temp4

 lda player1y
 sta temp3

 ldx missile0height
 inx
 inx
 stx stack1

 lda bally	
 sta stack2	

 lda player0y
 ldx #0
 sta WSYNC
 stx GRP0
 stx GRP1
 stx PF1
 stx PF2
 stx CXCLR
 ;sleep 3
 stx COLUPF		; black fg for first row

 sta temp2,x

 ;store these so they can be retrieved later
 ldx #128-44

 inc player1y

; lda missile0y		; 2
; sta temp5			; 3

 lda missile1y
 sta temp6

 lda playfieldpos
 sta temp1
 
 lda #10
 clc
 sbc playfieldpos
 sta playfieldpos
 
; jmp .startkernel0	; 3
 
 ; need 8 cycles to target
 lda z				; 2
 bne .startkernelX	; 3 if taken, else 2 (4 if page is crossed!)
 
 ; four so far, need four more
 nop
 nop
 
; ------------
; initial kernel - first 8 lines is very dumb, we just
; do nothing, we want background color and no players!
; we do decrement the counters to be nice ;)

; why does this work? Just timing?
.startkernel0
   lda #0
   sta PF1 ;3
   sta PF2 ;3
   
   dcp bally
   sta ENABL 

   dcp player1y
   sta GRP1

   dcp missile1y ;5
   sta ENAM1 ;3

   dcp player0y
   sta GRP0

   dec temp1
   beq altkernel2
   jmp .startkernel0
; ------------

.skipDrawP0
 lda #0
 tay
 jmp .continueP0

.skipDrawP1
 lda #0
 tay
 jmp .continueP1

.startkernelX
 jmp .startkernel		; 3 more
 
.kerloop ; enter at cycle 59??

continuekernel
 sleep 2

 lda ballheight
 
 ldy playfield+44-128,x ;4
 sty PF1 ;3
 ldy playfield+45-128,x ;4
 sty PF2 ;3
 ldy playfield+47-128,x ;4
 sty PF1 ; 3 too early?
 ldy playfield+46-128,x;4
 sty PF2 ;3

 dcp bally
 rol
 rol
 sta ENABL 

.startkernel

 lda player1height ;3
 dcp player1y ;5
 bcc .skipDrawP1 ;2
 
 ldy player1y ;3
 lda (player1pointer),y ;5	; player0pointer must be selected carefully by the compiler
							; so it doesn't cross a page boundary!

.continueP1
 sta GRP1 ;3

 lda missile1height ;3
 dcp missile1y ;5
 rol;2
 rol;2
 sta ENAM1 ;3

 lda playfield+44-128,x ;4
 sta PF1 ;3
 lda playfield+45-128,x ;4
 sta PF2 ;3
 lda playfield+47-128,x ;4
 sta PF1 ; 3 too early?
 lda playfield+46-128,x;4
 sta PF2 ;3

 lda player0height
 dcp player0y
 bcc .skipDrawP0
 
 ldy player0y
 lda (player0pointer),y
 
.continueP0
 sta GRP0

; ifconst no_blank_lines
   dec temp1
   beq altkernel2
   txa
   tay
   lda (pfcolortable),y
   sta COLUPF
   jmp continuekernel

altkernel2
   txa
   sbx #252				; add 4 without carry etc (x and a must be identical)
   bmi lastkernelline	; x starts at 128-44, when it reaches 128, we're done
   lda #8
   sta temp1
   jmp continuekernel

; ifconst no_blank_lines
lastkernelline
 
   ldx playfieldpos
   sleep 3

   cpx #1
   bne .enterfromNBL
   jmp no_blank_lines_bailout

 if ((<*)>$d5)
 align 256
 endif
 ; this is a kludge to prevent page wrapping - fix!!!

.skipDrawlastP1
 sleep 2
 lda #0
 jmp .continuelastP1

.endkerloop ; enter at cycle 59??
 nop

.enterfromNBL
 ldy.w playfield+44
 sty PF1 ;3
 ldy.w playfield+45
 sty PF2 ;3
 ldy.w playfield+47
 sty PF1 ; possibly too early?
 ldy.w playfield+46
 sty PF2 ;3

enterlastkernel
 lda ballheight

 dcp bally

 rol
 rol
 sta ENABL 

 lda player1height ;3
 dcp player1y ;5
 bcc .skipDrawlastP1
 
 ldy player1y ;3
 lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
			; so it doesn't cross a page boundary!

.continuelastP1
 sta GRP1 ;3

 lda missile1height ;3
 dcp missile1y ;5

 dex
 beq endkernel

 ldy.w playfield+44
 sty PF1 ;3
 ldy.w playfield+45
 sty PF2 ;3
 ldy.w playfield+47
 sty PF1 ; possibly too early?
 ldy.w playfield+46
 sty PF2 ;3

   rol;2
   rol;2
   sta ENAM1 ;3
 
 lda.w player0height
 dcp player0y
 bcc .skipDrawlastP0
 ldy player0y
 lda (player0pointer),y
.continuelastP0
 sta GRP0

; ifconst no_blank_lines
 sleep 14
 jmp .endkerloop

.skipDrawlastP0
 sleep 2
 lda #0
 jmp .continuelastP0

; no_blank_lines
no_blank_lines_bailout
 ldx #0

endkernel
 ; 6 digit score routine
 stx PF1
 stx PF2
 stx PF0
 clc

 lda #10

 sbc playfieldpos
 sta playfieldpos
 txa

   sta WSYNC,x

 sta REFP0
 sta REFP1
                STA GRP0
                STA GRP1
 sta HMCLR
 sta ENAM0
 sta ENAM1
 sta ENABL

 lda temp2 ;restore variables that were obliterated by kernel
 sta player0y
 lda temp3
 sta player1y
   lda temp6
   sta missile1y

   lda temp5
   sta missile0y

 lda stack2
 sta bally

 sta WSYNC

 lda INTIM
 clc

 adc #43+12+87

 sta TIM64T

 ; now reassign temp vars for score pointers

; score pointers contain:
; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
; swap lo2->temp1
; swap lo4->temp3
; swap lo6->temp5
 lda scorepointers+1
 sta temp1

 lda scorepointers+3
 sta temp3

 sta HMCLR
 tsx
 stx stack1 
 ldx #$10
 stx HMP0

 sta WSYNC
 ldx #0
                STx GRP0
                STx GRP1 ; seems to be needed because of vdel

 lda scorepointers+5
 sta temp5,x
 lda #>scoretable
 sta scorepointers+1
 sta scorepointers+3
 sta scorepointers+5,x
 sta temp2,x
 sta temp4,x
 sta temp6,x
                LDY #7
                STA RESP0
                STA RESP1


        LDA #$03
        STA NUSIZ0
        STA NUSIZ1,x
        STA VDELP0
        STA VDELP1
        LDA #$20
        STA HMP1
               LDA scorecolor 
                STA HMOVE ; cycle 73 ?

                STA COLUP0
                STA COLUP1
 lda  (scorepointers),y
 sta  GRP0
 
 lda pfscorecolor
 sta COLUPF

 lda  (scorepointers+8),y
 sta WSYNC
 sleep 2
 jmp beginscore

 if ((<*)>$d4)
 align 256 ; kludge that potentially wastes space!  should be fixed!
 endif

loop2
 lda  (scorepointers),y     ;+5  68  204
 sta  GRP0            ;+3  71  213      D1     --      --     --

 lda.w pfscore1
 sta PF1

 ; cycle 0
 lda  (scorepointers+$8),y  ;+5   5   15
beginscore
 sta  GRP1            ;+3   8   24      D1     D1      D2     --
 lda  (scorepointers+$6),y  ;+5  13   39
 sta  GRP0            ;+3  16   48      D3     D1      D2     D2
 lax  (scorepointers+$2),y  ;+5  29   87
 txs
 lax  (scorepointers+$4),y  ;+5  36  108
 sleep 3

 lda pfscore2
 sta PF1

 lda  (scorepointers+$A),y  ;+5  21   63
 stx  GRP1            ;+3  44  132      D3     D3      D4     D2!
 tsx
 stx  GRP0            ;+3  47  141      D5     D3!     D4     D4
 sta  GRP1            ;+3  50  150      D5     D5      D6     D4!
 sty  GRP0            ;+3  53  159      D4*    D5!     D6     D6
 dey
 bpl  loop2           ;+2  60  180

 ldx stack1 
 txs

 ldy temp1
 sty scorepointers+1

                LDA #0   
 sta PF1
               STA GRP0
                STA GRP1
        STA VDELP0
        STA VDELP1;do we need these
        STA NUSIZ0
        STA NUSIZ1

 ldy temp3
 sty scorepointers+3

 ldy temp5
 sty scorepointers+5

 LDA #%11000010
 sta WSYNC
 STA VBLANK
 RETURN

