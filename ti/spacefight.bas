REM SPACE FIGHT BY MIKE BRENT AKA TURSI
REM FROM SOME TIME IN THE 80s...

1 CALL KEY(5,K,S)
10 CALL CLEAR
20 GOSUB 1000
30 CALL HCHAR(1,1,37,768)
40 FOR A=2 TO 10
50 CALL HCHAR(A,12-A,33)
60 CALL HCHAR(A,21+A,34)
70 CALL VCHAR(A+1,12-A,32,10-A)
80 CALL VCHAR(A+1,21+A,32,10-A)
90 CALL HCHAR(A,12,32,10)
100 NEXT A
110 CALL HCHAR(15,4,35,10)
120 CALL HCHAR(15,20,35,10)
125 CALL HCHAR(14,30,122)
130 CALL HCHAR(18,4,35,10)
135 CALL HCHAR(17,3,120)
140 CALL HCHAR(18,20,35,10)
145 CALL HCHAR(20,27,121)
147 CALL HCHAR(20,28,123)
150 FOR A=13 TO 16
160 CALL HCHAR(A,15,96,4)
170 NEXT A
180 CALL HCHAR(22,16,104)
190 CALL HCHAR(22,17,105)
200 CALL HCHAR(23,16,106)
210 CALL HCHAR(23,17,107)
220 A$="SCORE:0"
230 R=1
240 C=12
250 GOSUB 1500
260 A$="FUEL"
270 R=13
280 C=4
290 GOSUB 1500
300 A$="SHIELDS"
310 C=20
320 GOSUB 1500
330 A$="SPEED"
340 R=16
350 C=4
360 GOSUB 1500
370 A$="TEMPERATURE"
380 C=20
390 GOSUB 1500
400 A$="TORPEDOS"
410 R=20
420 C=8
430 GOSUB 1500
440 A$="SHIP"
450 R=22
460 C=12
470 GOSUB 1500
480 A$="TYPE"
490 R=23
500 C=18
510 GOSUB 1500
520 FOR A=1 TO 15
530 R=INT(RND*8)+2
540 C=INT(RND*30)+2
550 CALL GCHAR(R,C,QW)
560 IF QW<>32 THEN 530
570 CALL HCHAR(R,C,46)
580 NEXT A
590 CALL HCHAR(14,4,32,10)
600 CALL HCHAR(14,20,32,10)
610 CALL HCHAR(17,4,32,10)
620 CALL HCHAR(17,20,32,10)
630 CALL HCHAR(10,17,40)
640 SCORE=0
650 FUEL=10
655 OLDFUEL=0
660 SPEED=0
665 OLDSPEED=-1
670 SHIELDS=0
675 OLDSHIELDS=-1
680 TEMP=0
685 OLDTEMP=1
690 TORPS=10
691 OLDTORPS=0
695 LE=0
700 GOSUB 2000
701 CALL KEY(0,K,S)
702 IF S=0 THEN 701
703 RANDOMIZE
710 CALL SOUND(-1000,550,30-SHIELDS*3,110,30-TEMP*3,-7,30-SPEED*3)
715 CALL COLOR(10,3,3)
720 FUEL=FUEL-(SPEED/50)-(SHIELDS/100)
730 TEMP=TEMP+(SPEED/30)
731 IF SPEED>0 THEN 740
732 TEMP=INT(TEMP-1)
733 IF TEMP>=0 THEN 740
734 TEMP=0
740 GOSUB 2000
745 GOSUB 5000
750 IF INT(FUEL+.5)=0 THEN 3000
760 IF RND>=SPEED/10 THEN 710
770 REM  SHIP APPEARS 
780 FOR A=1 TO 3
790 CALL SOUND(355,145,10,-2,0)
800 CALL COLOR(9,7,1)
810 CALL COLOR(9,16,1)
820 NEXT A
830 SN=INT(RND*8)+1
835 IF (SN=7)*(SC=0)THEN 830
840 ON SN GOSUB 6000,6020,6040,6060,6080,6100,6120,6140
850 READ C1$,C2$,C3$,C4$
860 CALL CHAR(104,C1$)
870 CALL CHAR(105,C2$)
880 CALL CHAR(106,C3$)
890 CALL CHAR(107,C4$)
900 CALL SOUND(100,1000,0)
910 CALL COLOR(10,16,3)
920 CALL HCHAR(6,17,41)
925 FLAG=0
930 FOR X=1 TO 10-LE
940 CALL SOUND(10,-6,5)
950 CALL KEY(0,K,S)
960 IF K<>32 THEN 970
961 CALL SOUND(-100,110,0)
965 FLAG=1
970 NEXT X
975 IF FLAG=0 THEN 990
980 GOSUB 7000
985 GOTO 710
990 GOSUB 7500
995 GOTO 710
1000 CALL CHAR(33,"FFFEFCF8F0E0C08")
1010 CALL CHAR(34,"FF7F3F1F0F070301")
1020 CALL CHAR(35,"7F7F7F7FFFFFFFFF")
1030 CALL CHAR(36,"003C7E7E7E7E3C")
1040 CALL CHAR(37,"FFFFFFFFFFFFFFFF")
1050 CALL CHAR(40,"101028")
1060 CALL CHAR(41,"00007E7E7E")
1070 CALL CHAR(42,"0000001818")
1080 CALL CHAR(43,"0000183C3C18")
1090 CALL CHAR(44,"00183C7E7E3C18")
1100 CALL CHAR(45,"187E7EFFFF7E7E18")
1110 CALL CHAR(96,"FFFFFFFFFFFFFFFF")
1112 CALL CHAR(120,"6080402ACA040A0A")
1114 CALL CHAR(121,"0036452614640000")
1116 CALL CHAR(122,"2050705751020407")
1118 CALL CHAR(123,"0030404040300000")
1120 CALL CHAR(104,"")
1130 CALL CHAR(105,"")
1140 CALL CHAR(106,"")
1150 CALL CHAR(107,"")
1160 CALL SCREEN(2)
1170 CALL COLOR(1,6,1)
1180 CALL COLOR(2,16,1)
1190 CALL COLOR(9,16,1)
1200 CALL COLOR(10,3,3)
1210 FOR A=3 TO 8
1220 CALL COLOR(A,2,6)
1230 NEXT A
1232 CALL COLOR(12,5,6)
1235 CALL CHAR(112,"FFFFFFFFFFFFFFFF")
1237 CALL COLOR(11,10,10)
1240 RETURN
1500 FOR A=1 TO LEN(A$)
1510 CALL HCHAR(R,C+A-1,ASC(SEG$(A$,A,1)))
1520 NEXT A
1530 RETURN
2000 IF FUEL=OLDFUEL THEN 2020
2005 CALL HCHAR(14,4,32,10)
2010 CALL HCHAR(14,4,112,FUEL)
2015 OLDFUEL=FUEL
2020 IF SHIELDS=OLDSHIELDS THEN 2040
2025 CALL HCHAR(14,20,32,10)
2030 CALL HCHAR(14,20,112,SHIELDS)
2035 OLDSHIELDS=SHIELDS
2040 IF SPEED=OLDSPEED THEN 2060
2045 CALL HCHAR(17,4,32,10)
2050 CALL HCHAR(17,4,112,SPEED)
2055 OLDSPEED=SPEED
2060 IF TEMP=OLDTEMP THEN 2080
2065 CALL HCHAR(17,20,32,10)
2070 CALL HCHAR(17,20,112,TEMP)
2075 OLDTEMP=TEMP
2080 IF TORPS=OLDTORPS THEN 2100
2085 CALL HCHAR(20,17,32,10)
2090 CALL HCHAR(20,17,36,TORPS)
2095 OLDTORPS=TORPS
2100 RETURN
3000 REM  OUT OF FUEL 
3010 FOR X=SHIELDS TO 1 STEP -1
3020 SHIELDS=SHIELDS-1
3030 GOSUB 2000
3035 CALL SOUND(-1000,550,30-SHIELDS*3,110,30-SHIELDS*3,-7,30-SPEED*3)
3040 NEXT X
3050 FOR X=SPEED TO 1 STEP -1
3060 SPEED=SPEED-1
3070 GOSUB 2000
3080 CALL SOUND(-1000,550,30,110,30,-7,30-SPEED*3)
3090 NEXT X
3100 CALL HCHAR(6,17,41)
3110 CALL SOUND(-400,340,5)
3120 FOR R=6 TO 2 STEP -1
3130 CALL HCHAR(R,17,41)
3140 CALL HCHAR(R,17,32)
3150 NEXT R
3160 FOR X=42 TO 45
3170 CALL SOUND(250,5*((X=42)+(X=43))+6*(X=44)+7*(X=45),(45-X)*4)
3180 CALL HCHAR(6,17,X)
3190 NEXT X
3200 FOR A=0 TO 30
3210 CALL SOUND(-100,-7,A)
3220 CALL SCREEN(16)
3230 CALL SCREEN(2)
3240 NEXT A
3250 CALL CLEAR
3255 CALL SCREEN(6)
3260 PRINT "YOU HAVE BEEN DESTROYED."
3270 PRINT "YOU GOT TO LEVEL";LE
3275 PRINT "YOUR SCORE IS ";SC
3276 PRINT
3280 PRINT :::
3290 INPUT "PLAY AGAIN? Y/N":A$
3300 IF A$="Y" THEN 10
3310 END
4000 REM  OVERHEAT 
4010 FOR A=30 TO 0 STEP -1
4020 CALL SOUND(-100,-5,A)
4030 NEXT A
4040 FOR A=0 TO 30
4050 CALL SOUND(-100,-7,A)
4060 CALL SCREEN(16)
4070 CALL SCREEN(2)
4080 NEXT A
4090 CALL CLEAR
4100 PRINT "OVERHEAT!!!":
4110 GOTO 3260
5000 REM  KEYS 
5010 CALL KEY(0,K,S)
5020 IF S=0 THEN 5999
5030 IF (K<>65)+(SHIELDS=10)THEN 5050
5040 SHIELDS=SHIELDS+1
5050 IF (K<>90)+(SHIELDS=0)THEN 5070
5060 SHIELDS=SHIELDS-1
5070 IF (K<>83)+(SPEED=10)THEN 5090
5080 SPEED=SPEED+1
5090 IF (K<>88)+(SPEED=0)THEN 5999
5100 SPEED=SPEED-1
5999 RETURN
6000 RESTORE 10000
6010 RETURN
6020 RESTORE 10010
6030 RETURN
6040 RESTORE 10020
6050 RETURN
6060 RESTORE 10030
6070 RETURN
6080 RESTORE 10040
6090 RETURN
6100 RESTORE 10050
6110 RETURN
6120 RESTORE 10060
6130 RETURN
6140 RESTORE 10070
6150 RETURN
7000 REM  SHOOT 
7010 IF TORPS=0 THEN 7500
7020 TORPS=TORPS-1
7030 FOR A=10 TO 6 STEP -1
7040 CALL HCHAR(A,17,40)
7050 CALL HCHAR(A,17,32)
7060 NEXT A
7070 FOR A=0 TO 30 STEP 3
7080 CALL SOUND(-300,-6,A)
7083 CALL COLOR(1,6,16)
7086 CALL COLOR(1,6,1)
7090 NEXT A
7100 IF SN>4 THEN 7200
7101 LE=LE+1
7102 IF LE<10 THEN 7110
7103 LE=9
7110 SC=SC+SN*100
7120 A$=STR$(SC)
7130 R=1
7140 C=18
7145 CALL HCHAR(1,18,37,10)
7150 GOSUB 1500
7160 IF TORPS=0 THEN 7999
7170 CALL HCHAR(10,17,40)
7180 RETURN
7200 CALL SOUND(-300,110,0,111,0,112,0)
7210 CALL SOUND(300,110,-30*(SN<>7))
7220 SC=SC-300
7230 IF (SC>=0)*(SN<>7)THEN 7240
7235 SC=0
7240 LE=LE-1
7250 IF LE>=0 THEN 7120
7260 LE=0
7270 GOTO 7120
7500 FOR A=6 TO 2 STEP -1
7510 CALL HCHAR(A,17,41)
7520 CALL HCHAR(A,17,32)
7530 NEXT A
7540 IF SN>4 THEN 7800
7550 FOR X=42 TO 45
7560 CALL SOUND(250,5*((X=42)+(X=43))+6*(X=44)+7*(X=45),(45-X)*4)
7570 CALL HCHAR(6,17,X)
7580 NEXT X
7585 CALL HCHAR(6,17,32)
7590 FOR A=0 TO 30 STEP SHIELDS+1
7600 FUEL=FUEL-.5
7610 CALL SOUND(-100,-7,A)
7620 CALL SCREEN(16)
7630 CALL SCREEN(2)
7640 NEXT A
7650 FUEL=INT(FUEL)
7660 IF FUEL>=0 THEN 7670
7665 FUEL=0
7670 REM  
7800 IF SN<>7 THEN 7999
7801 FOR A=FUEL TO 10
7802 CALL SOUND(100,A*110,0)
7803 NEXT A
7810 FUEL=10
7820 TORPS=10
7830 TEMP=0
7999 RETURN
10000 DATA 000000010202073F,000000804040E0FC,EFF0FF7F3F081030,F70FFFFEFC10080C
10010 DATA 000040E0530C1F3F,00000207CA30F8FC,5F848A84C0,FA21512103
10020 DATA 201008070F10223F,040810E0F00844FC,3F3F1F0F172040,FCFCF8F0E80402
10030 DATA 0101010101030509,8080808080C0A090,35569A5F3F0D07,AC6A59FAFCB0E
10040 DATA 0103020505050404,80C040A0A0A02020,0409112D4DFF0C,209088B4B2FFC
10050 DATA 0000003F30A8E5E2,000000E060A0242E,E5E8B03F040818,3EA161FF080406
10060 DATA 031F3F203F20100F,C0F8FC04FC0408F,0202020203030201,40404040C0C0408
10070 DATA 014161514945332F,8082868A92A2CCF4,2F3143454952614,F48CC2A2924A8602
