 rem 'Space Fighter' by Mike Brent
 rem port from TI BASIC to Batari 2600 BASIC
 rem (C) 2009 by Mike Brent
 rem This program is not public domain and may
 rem not be sold without prior arrangement.
 rem It may not be distributed on images sold
 rem for a 'copy fee' either.
 rem Getting permission is easy: mbrent@harmlesslion.com
 rem 9 May 2009

 rem wish list:
 rem plot stars in the window??
 rem get diagonals on the window frame??
  
 rem set tv pal
 rem NTSC: $82. PAL: $D2 - Other colors are fine
 COLUBK=$82

 set kernel_options no_blank_lines pfcolors
 set smartbranching on
 const pfscore=1
 rem p1 is always one scanline later than p0, so the kernel normally
 rem delays p0 to make them line up. This prevents the delay, but if you
 rem want p0 and p1 to line up, you have to work with player1y 1 lower than usual
 const dontdelayplayer0=1

 rem set up colors and patterns
 rem Background is blue, foreground is black!
 
 dim fuel=a.b
 dim shield=c
 dim speed=d
 dim temper=e
 dim level=f
 dim frame=g
 dim lp=h
 dim lp2=i
 dim ship=j
 dim flag=k
 dim rand16=l
 dim sc1=score
 dim sc2=score+1
 dim sc3=score+2
 
 const ypos=28
 
restart
 pfscorecolor=64
 scorecolor=14
 gosub resetaudio

 rem Draw Screen - 32x11!
 playfield:
 ................................
 .........X.XXXXXXXXXX.X.........
 .......XXX.XXXXXXXXXX.XXX.......
 .....XXXXX.XXXXXXXXXX.XXXXX.....
 ...XXXXXXX.XXXXXXXXXX.XXXXXXX...
 .XXXXXXXXX.XXXXXXXXXX.XXXXXXXXX.
 ................................
 ..XXXXXXXXXX........XXXXXXXXXX..
 ..............XXXX..............
 ..XXXXXXXXXX........XXXXXXXXXX..
 ................................
end

 gosub normalscreen

 rem just in case our init is taking too long
 drawscreen

 rem set up the players in the viewport
 rem we are using two 8x16 players to match the original TI graphics!
 rem use vdel to push the sprites down one scanline so they align better with
 rem the no_blank_lines playfield at the top of the window
 player0x=72
 player0y=ypos
 player1x=80
 player1y=ypos-1
 VDELP0=0
 VDELP1=0

 gosub eraseplayers 
 
 rem just in case our init is taking too long
 drawscreen

 rem set up the ball and missile1 for use fixing up the window
 rem we dont have access to missile0! 
 rem set both to 4 pixels wide and 40 pixels tall
 rem the missile is the same color as player1 (we have to tweak it to BLUE at the beginning of the line)
 rem the missile thus /adds/ window
 rem the ball is the same color as the playfield (black), so we have to invert its effect!
 rem We have to, it flashes with the playfield. So it /removes/ window.
 NUSIZ1=$20
 missile1y=47
 missile1height=38

 CTRLPF=$21
 bally=46
 ballheight=38

 rem set up 8 missile dots
 pfscore1=$55
 pfscore2=$aa

 rem and variable inits
 score=0
 fuel=10.0
 speed=0
 shield=0
 temper=0
 level=0
 frame=0

gamelp
 rem reset ball and missile each frame
 missile1x=36
 ballx=128

 drawscreen
 frame=frame+1

 rem make noise
 AUDV0=shield
 AUDV1=speed
 
 temp1=frame
 temp1=temp1&15
 on temp1 goto 1 0 0 4 0 2 0 0 4 0 3 0 0 4 0 0
 
1
 if shield=0 then goto 0
   for lp=1 to shield
     fuel=fuel-0.02
   next
 goto 0
 
2
 if speed=0 then 0
   for lp=1 to speed
     fuel=fuel-0.01
   next
 goto 0

3
 if temper = 0 then 0
   for lp=1 to temper
     fuel=fuel-0.005
   next
  goto 0
  
4
   if speed > 7 || temper < 1 then 0
   temper = temper - 1
   if speed > 5 || temper < 1 then 0
   temper = temper - 1
   if speed > 3 || temper < 1 then 0
   temper = temper - 1

0

 rem redraw the bars
 gosub 2000

 rem handle player input
 gosub 5000
 
 rem Are we out of fuel?
 if fuel <= 0 then 3000
 
 temp1=rand
 temp1=temp1/8
 if rand >= speed then gamelp
 
 rem random ship appears!
 for lp=1 to 3
 drawscreen
 
 rem audio on, and flash warning indicator
 AUDV0=12
 AUDC0=1
 AUDF0=10
 AUDV1=12
 AUDC1=1
 AUDF1=6
 pfcolors:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 72
 186
 72
 186
 0
end
 
 for lp2=1 to 15
 rem delay a few frames
 drawscreen
 next lp2

 gosub resetaudio
 gosub normalscreen 

 for lp2=1 to 10
 rem delay a few frames
 drawscreen
 next lp2

 next lp

 rem choose a ship from 0 to 7 and draw it
 ship=rand
 ship=ship/32
 on ship gosub 6000 6020 6040 6060 6080 6100 6120 6140
 gosub display

 rem countdown loop to give the player time to respond
 rem on level 1, give about 1 seconds. Decrease from there.
 AUDC0=8
 AUDF0=3
 flag=0
 temp1=60-level
 if temp1 < 5 then temp1=5
 for lp=temp1 to 0 step -1
   AUDV0=4
   drawscreen
   
   AUDV0=0
   if !joy0fire then nofire
     flag=1
     AUDC0=12
     AUDF0=3
     AUDV0=10
     lp=1
     drawscreen
nofire
 next
 
 rem reset audio registers
 gosub resetaudio

 if flag=0 then 990
 rem didn't fire
 gosub 7000
 goto gamelp

990 
  rem did fire
  gosub 7500
  goto gamelp

2000
 rem redraw the bars - divided up to reduce workload per frame
 rem fuel is 10 pixels at 7,2
 rem shield is 10 pixels at 7,20
 rem speed is 10 pixels at 9,2
 rem temperature is 10 pixels at 9,20
 rem ammo is dots around the score
 temp1=frame&7
 on temp1 goto 2010 2015 2020 2025 2030 2035 2040 2045
 
2010 
 temp1=fuel+2
 if temp1 <= 11 then pfhline temp1 7 11 off
 return
 
2015
 if fuel < 1 then return
 temp1=fuel+1
 pfhline 2 7 temp1 on
 return

2020 
 temp1=shield+20
 if temp1 <= 29 then pfhline temp1 7 29 off
 return
 
2025
 if shield < 1 then return
 temp1=shield+19
 pfhline 20 7 temp1 on
 return

2030
 temp1=speed+2
 if temp1 <= 11 then pfhline temp1 9 11 off
 return
 
2035
 if speed < 1 then return
 temp1=speed+1
 pfhline 2 9 temp1 on
 return
 
2040
 temp1=temper+20
 if temp1 <= 29 then pfhline temp1 9 29 off
 return
 
2045
 if temper < 1 then return
 temp1=temper+19
 pfhline 20 9 temp1 on
 return

3000 rem  OUT OF FUEL 
 AUDV0=0
 AUDV1=0

 for lp=1 to 60
   frame=frame+1
   temp1=frame&7
   if temp1 <> 0 then noshield
   if temper=0 then notemp
     temper=temper-1
notemp
   if speed=0 then nospeed
     speed=speed-1
nospeed
  if shield=0 then noshield
    shield=shield-1
noshield
  gosub 2000
  drawscreen
 next
 
 rem display an enemy to destroy us
 ship=rand
 ship=ship/64
 on ship gosub 6000 6020 6040 6060
 gosub display
 gosub flyaway 
 gosub shotcomesin

 rem now, Mr Bond, you die.
 AUDC0=8
 AUDF0=2
 for lp=15 to 0 step -1
   frame=frame+1
   AUDV0=lp
   gosub whitewindow
   gosub 2000
   drawscreen
   gosub normalscreen
   gosub 2000
   drawscreen
 next
 gosub resetaudio
  
 rem dead. Wait for a button press
 gosub whitewindow
  
lp4evr
  drawscreen
  if joy0fire then restart
  goto lp4evr  
  
5000
 temp1=frame & 15
 if temp1 <> 0 then 5999

 rem input - up/down for speed, left/right for shield
 if !joy0right || shield > 9 then 5050
 shield=shield + 1
 
5050
 if !joy0left || shield < 1 then 5070
 shield=shield - 1
 
5070
 if !joy0up || speed > 9 then 5090
 speed=speed + 1

5090
 if !joy0down || speed < 1 then 5999
 speed=speed - 1

5999
 return

6000
 rem 10000 DATA 000000010202073F ,000000804040E0FC ,EFF0FF7F3F081030 ,F70FFFFEFC10080C
 player0:
 $30
 $10
 $08
 $3F
 $7F
 $FF
 $F0
 $EF
 $3F
 $07
 $02
 $02
 $01
 0
 0
 0
end
 player1:
 $0C
 $08
 $10
 $FC
 $FE
 $FF
 $0F
 $F7
 $FC
 $E0
 $40
 $40
 $80
 0
 0
 0
end
 return

6020
 rem 10010 DATA 000040E0530C1F3F ,00000207CA30F8FC ,5F848A84C0 ,FA21512103
 player0:
 $00
 $00
 $00
 $C0
 $84
 $8A
 $84
 $5F
 $3F
 $1F
 $0C
 $53
 $E0
 $40
 0
 0
end
 player1:
 $00
 $00
 $00
 $03
 $21
 $51
 $21
 $FA
 $FC
 $F8
 $30
 $CA
 $07
 $02
 0
 0
end
 return

6040
 rem 10020 DATA 201008070F10223F ,040810E0F00844FC ,3F3F1F0F172040 ,FCFCF8F0E80402
 player0:
 $00
 $40
 $20
 $17
 $0F
 $1F
 $3F
 $3F
 $3F
 $22
 $10
 $0F
 $07
 $08
 $10
 $20
end
 player1:
 $00
 $02
 $04
 $E8
 $F0
 $F8
 $FC
 $FC
 $FC
 $44
 $08
 $F0
 $E0
 $10
 $08
 $04
end
 return

6060
 rem 10030 DATA 0101010101030509 ,8080808080C0A090 ,35569A5F3F0D07 ,AC6A59FAFCB0E
 player0:
 $00
 $07
 $0D
 $3F
 $5F
 $9A
 $56
 $35
 $09
 $05
 $03
 $01
 $01
 $01
 $01
 $01
end
 player1:
 $00
 $E0
 $B0
 $FC
 $FA
 $59
 $6A
 $AC
 $90
 $A0
 $C0
 $80
 $80
 $80
 $80
 $80
end
 return

6080
 rem 10040 DATA 0103020505050404 ,80C040A0A0A02020 ,0409112D4DFF0C ,209088B4B2FF3
 player0:
 $00
 $0C
 $FF
 $4D
 $2D
 $11
 $09
 $04
 $04
 $04
 $05
 $05
 $05
 $02
 $03
 $01
end
 player1:
 $00
 $30
 $FF
 $B2
 $B4
 $88
 $90
 $20
 $20
 $20
 $A0
 $A0
 $A0
 $40
 $C0
 $80
end
 return

6100
 rem 10050 DATA 0000003F30A8E5E2 ,000000E060A0242E ,E5E8B03F040818 ,3EA161FF080406
 player0:
 $00
 $18
 $08
 $04
 $3F
 $B0
 $E8
 $E5
 $E2
 $E5
 $A8
 $30
 $3F
 0
 0
 0
end
 player1:
 $00
 $06
 $04
 $08
 $FF
 $61
 $A1
 $3E
 $2E
 $24
 $A0
 $60
 $E0
 0
 0
 0
end
 return

6120
 rem 10060 DATA 031F3F203F20100F ,C0F8FC04FC0408F ,0202020203030201 ,40404040C0C0408
 player0:
 $01
 $02
 $03
 $03
 $02
 $02
 $02
 $02
 $0F
 $10
 $20
 $3F
 $20
 $3F
 $1F
 $03
end
 player1:
 $80
 $40
 $C0
 $C0
 $40
 $40
 $40
 $40
 $F0
 $08
 $04
 $FC
 $04
 $FC
 $F8
 $C0
end
 return

6140
 rem 10070 DATA 014161514945332F ,8082868A92A2CCF4 ,2F3143454952614 ,F48CC2A2924A8602
 player0:
 $40
 $61
 $52
 $49
 $45
 $43
 $31
 $2F
 $2F
 $33
 $45
 $49
 $51
 $61
 $41
 $01
end
 player1:
 $02
 $86
 $4A
 $92
 $A2
 $C2
 $8C
 $F4
 $F4
 $CC
 $A2
 $92
 $8A
 $86
 $82
 $80
end
 return

7000 rem shoot (if we have any ammo left!)
 if pfscore1=0 then decpf2
   pfscore1=pfscore1/4
   goto decdone
decpf2
  if pfscore2=0 then 7500
  pfscore2=pfscore2/4
decdone

  rem missile appears
  missile1x=80
  drawscreen
  
  rem missile flies up
  lp2=4
  missile1height=lp2
  for lp=47 to ypos step -2
    missile1y=lp
    frame=frame+1
    temp1=frame&3
    if temp1=0 && lp2>1 then lp2=lp2-1
    missile1height=lp2
    drawscreen
  next
  missile1y=110
  
  rem ship is destroyed!
  rem 30 DATA 41,03,02,30,08,08,81,42,2C,02,0F,42,00,61,1D,04
  rem 40 DATA 00,08,60,24,04,C2,62,00,70,80,89,09,30,90,13,00  
  player0:
  $41
  $03
  $02
  $30
  $08
  $08
  $81
  $42
  $2C
  $02
  $0F
  $42
  $00
  $61
  $1D
  $04
end
  player1:
  $00
  $08
  $60
  $24
  $04
  $C2
  $62
  $00
  $70
  $80
  $89
  $09
  $30
  $90
  $13
  $00  
end
  
  AUDC0=8
  AUDF0=4
  for lp=15 to 0 step -1
    AUDV0=lp
    gosub whitewindow
    drawscreen
    gosub normalscreen
    drawscreen
  next
  gosub eraseplayers
  gosub resetaudio
  drawscreen

  if ship > 3 then 7200

  rem blew up a bad guy
  level=level+1
  if level>195 then level=195
  
  for lp=0 to ship
    score=score+100
    drawscreen
  next

  return
  
7200  
 rem blew up a good guy
 rem play a bad tone
 AUDC0=4
 AUDV0=10
 AUDF0=14
 
 for lp=1 to 10
   drawscreen
   temp1=lp+5
   AUDF0=temp1
 next
 
 gosub resetaudio
 
 if sc1=$00 && sc2<$03 then noscore
 score=score-300
 goto scoredone
noscore
 score=0
scoredone

 if ship=6 then score=0
 return

7500
 rem does not shoot
 gosub flyaway
 rem this needs to be a "then goto" for some reason
 if ship > 3 then goto 7800

 rem bad guy, not shot
 gosub shotcomesin

 temp1=11-shield
 for lp2=temp1 to 1 step -1
   frame=frame+1
   fuel=fuel-0.1
   if fuel < 0 then fuel=0.0
   gosub 2000
   drawscreen
 next

 temper=temper+3
 if temper > 10 then temper = 10 

 AUDC0=8
 AUDF0=3
 for lp=15 to 0 step -1
   frame=frame+1
   AUDV0=lp
   gosub whitewindow
   gosub 2000
   drawscreen
   gosub normalscreen
   gosub 2000
   drawscreen
 next
 
 gosub resetaudio
 
 return 

7800
 rem good guy not shot
 if ship<>6 then return
 
 rem extra handling for starbase!
 AUDC0=4
 AUDF0=fuel
 AUDV0=8
 for lp=fuel to 10
   AUDF0=13-fuel
   fuel=lp
   for lp2=1 to 4
     gosub 2000
     drawscreen
   next
 next
 fuel=10.0
 temper=0
 pfscore1=$55
 pfscore2=$aa
 gosub resetaudio
 return 
 
display
 rem display him with a little beep
 AUDC0=4
 AUDF0=11
 AUDV0=12
 for lp=1 to 3
   COLUP0=14
   COLUP1=14
   drawscreen
 next lp
 goto resetaudio

flyaway
 rem he flies away
 rem this loop adjusts the sprite data (which starts from the bottom and counts up)
 rem this approach works better than the weirdly timed kernel hacks I tried (although
 rem a true custom kernel hiding the top line from sprites probably would have taken less CPU work)
 for lp=ypos to 9 step -1
   player0y=lp
   player1y=lp-1
   if lp > 23 then justdraw
     player0height=player0height-1
     player1height=player1height-1
justdraw
   drawscreen
 next lp
 gosub eraseplayers
 player0y=ypos
 player1y=ypos-1
 return
 
shotcomesin
 rem we use the player sprites for a shot that grows larger and larger
 rem with some noise
 AUDC0=6
 for lp=1 to 15
   temp1=15-lp
   AUDF0=15-lp
   AUDV0=lp
   temp1=lp/4
   on temp1 gosub shot0 shot1 shot2 shot3

   COLUP0=14
   COLUP1=14

   drawscreen
   drawscreen
 next lp
 gosub eraseplayers
 goto resetaudio
 
shot0
 rem 30 DATA 00,00,00,00,00,00,00,01,01,00,00,00,00,00,00,00
 rem 40 DATA 00,00,00,00,00,00,00,80,80,00,00,00,00,00,00,00
 player0:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $01
 $01
end
 player1:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $80
 $80
end
 return
 
shot1
 rem 30 DATA 00,00,00,00,00,01,03,07,07,03,01,00,00,00,00,00
 rem 40 DATA 00,00,00,00,00,80,C0,E0,E0,C0,80,00,00,00,00,00
 player0:
 $00
 $00
 $00
 $00
 $00
 $01
 $03
 $07
 $07
 $03
 $01
end
 player1:
 $00
 $00
 $00
 $00
 $00
 $80
 $C0
 $E0
 $E0
 $C0
 $80
end
 return
 
shot2
 rem 30 DATA 00,00,00,03,0F,0F,1F,1F,1F,1F,0F,0F,03,00,00,00
 rem 40 DATA 00,00,00,C0,F0,F0,F8,F8,F8,F8,F0,F0,C0,00,00,00
 player0:
 $00
 $00
 $00
 $03
 $0F
 $0F
 $1F
 $1F
 $1F
 $1F
 $0F
 $0F
 $03
end
 player1:
 $00
 $00
 $00
 $C0
 $F0
 $F0
 $F8
 $F8
 $F8
 $F8
 $F0
 $F0
 $C0
end
 return
 
shot3
 rem 30 DATA 00,07,1F,3F,3F,7F,7F,7F,7F,7F,7F,3F,3F,1F,07,00
 rem 40 DATA 00,E0,F8,FC,FC,FE,FE,FE,FE,FE,FE,FC,FC,F8,E0,00
 player0:
 $00
 $07
 $1F
 $3F
 $3F
 $7F
 $7F
 $7F
 $7F
 $7F
 $7F
 $3F
 $3F
 $1F
 $07
end
 player1:
 $00
 $E0
 $F8
 $FC
 $FC
 $FE
 $FE
 $FE
 $FE
 $FE
 $FE
 $FC
 $FC
 $F8
 $E0
end
 return
 
resetaudio
 rem reset audio registers
 AUDV0=0
 AUDC0=3
 AUDF0=10
 AUDV1=0
 AUDC1=8
 AUDF1=6
return
 
normalscreen
 pfcolors:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 14
 186
 14
 186
 0
end
 return
 
whitewindow
 pfcolors:
 14
 14
 14
 14
 14
 14
 14
 14
 14
 14
 14
 14
end
 return
 
eraseplayers
 player0:
 0
end
 player1:
 0
end
 COLUP0=0
 COLUP1=0
 return

