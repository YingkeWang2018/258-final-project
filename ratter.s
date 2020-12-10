#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Yuzhan Gao, 1001789665
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# - Milestone 1 2 3 4 5
#
# Which approved additional features have been implemented?
# 1. Milestone 4 - Score count
# 2. Milestone 4 - Game over/retry  (After you failed, you can key in 'r' to retry the game)
# 3. Milestone 5 - Dynamic on-screen notifications (After you reached 2, 5, and 8 
#                  points, you will see differnt notifications, 'Awesome','Poggers', 'Wow')
# 4. Milestone 5 - Two Doodle Birds (use 'a' and 'd' to control green Doo, use 'j' and 'l' to control purple Doo)
# 5. Milestone 5 - Shields (At the begining of the game, each Doo has 2 shields, as shown on the top left 
#                           of the screen. Every time a Doo hits the bottom of the screen, that Doo loses 1 shield
#		            if a Doo has no shield and hit the bottom of the screen, gameover)					
#
# Any additional information that the TA needs to know:
# - Two Doo can jump on each other!
#
#####################################################################
.data
displayAddress: .word 0x10008000
redcolor: .word 0xff0000
greencolor: .word 0x00ff00
whitecolor: .word 0xffffff
bluecolor: .word 0x0000ff
blackcolor: .word 0x000000
purplecolor: .word 0xc39797
score: .word 0
scorePosition: .word 0
Doo_X_Pos1: .word 16
Doo_Y_Pos1: .word 28
Doo_X_Pos2: .word 19
Doo_Y_Pos2: .word 28
Doo_Power1: .word 12
Doo_Power2: .word 12
shield1: .word 2
shield2: .word 2
.text
lw $t0, displayAddress # $t0 stores the base address for display

MAIN:


jal PAINTBOARD
lw $t0, displayAddress 


#addi $a1, $zero, 5	#x-axis positionload 
#addi $a2, $zero, 10	#y-axis positionload 

addi $t2, $zero, 16
sw $t2, Doo_X_Pos1

addi $t2, $zero, 28
sw $t2, Doo_Y_Pos1

addi $t2, $zero, 19
sw $t2, Doo_X_Pos2

addi $t2, $zero, 28
sw $t2, Doo_Y_Pos2

addi $t2, $zero, 16
sw $t2, Doo_Power1

addi $t2, $zero, 16
sw $t2, Doo_Power2

addi $t2, $zero, 2
sw $t2, shield1

addi $t2, $zero, 2
sw $t2, shield2


addi $t2, $zero, 0
sw $t2, score

jal Gen_Random_New_Obs
addi $s0, $t4, 896
move $t5, $s0
jal PAINTOBS

jal Gen_Random_New_Obs
addi $s1, $t4, 1920
move $t5, $s1
jal PAINTOBS

jal Gen_Random_New_Obs
addi $s2, $t4, 2944
move $t5, $s2
jal PAINTOBS

addi $s6, $zero, 4024
move $t5, $s6
jal PAINTOBS



lw $s4, Doo_X_Pos1 #load initial X for Doo1
lw $s3, Doo_Y_Pos1 #load initial Y for Doo1
lw $s5, Doo_Power1 #load initial power
lw $t3, greencolor #load green color
lw $s7, shield1 #load shield
jal PAINTD
sw $s4, Doo_X_Pos1 #save X for Doo1
sw $s3, Doo_Y_Pos1 #save Y for Doo1
sw $s5, Doo_Power1 #save power
sw $s7, shield1 #load shield


lw $s4, Doo_X_Pos2 #load initial X for Doo2
lw $s3, Doo_Y_Pos2 #load initial Y for Doo2
lw $s5, Doo_Power2 #load initial power
lw $t3, purplecolor #load purple color
lw $s7, shield2 #load shield
jal PAINTD
sw $s4, Doo_X_Pos2 #save X for Doo2
sw $s3, Doo_Y_Pos2 #save Y for Doo2
sw $s5, Doo_Power2 #save power
sw $s7, shield2 #load shield


jal PAINTSCORE


jal PAINTSHIELD1
jal PAINTSHIELD2

jal SLEEP




LOOP:
jal PAINTBOARD

lw $s3, Doo_Y_Pos1 #load Y for Doo1
addi $t6, $s3, -12  #if Doo is on the top half of the screen
blez $t6, ScreenMoveDown
sw $s3, Doo_Y_Pos1 #save Y for Doo1

lw $s3, Doo_Y_Pos2 #load Y for Doo2
addi $t6, $s3, -12  #if Doo is on the top half of the screen
blez $t6, ScreenMoveDown
sw $s3, Doo_Y_Pos2 #save Y for Doo2




move $t5, $s0
jal PAINTOBS

move $t5, $s1
jal PAINTOBS

move $t5, $s2
jal PAINTOBS

move $t5, $s6
jal PAINTOBS


lw $t8, 0xffff0000
beq $t8, 1, Keyboard_input

lw $s4, Doo_X_Pos1 #load initial X for Doo1
lw $s3, Doo_Y_Pos1 #load initial Y for Doo1
lw $s5, Doo_Power1 #load initial power
lw $t3, greencolor #load green color
lw $s7, shield1 #load shield

jal PAINTD
sw $s4, Doo_X_Pos1 #save X for Doo1
sw $s3, Doo_Y_Pos1 #save Y for Doo1
sw $s5, Doo_Power1 #save power
sw $s7, shield1 #load shield


lw $s4, Doo_X_Pos2 #load initial X for Doo2
lw $s3, Doo_Y_Pos2 #load initial Y for Doo2
lw $s5, Doo_Power2 #load initial power
lw $t3, purplecolor #load purple color
lw $s7, shield2 #load shield
jal PAINTD
sw $s4, Doo_X_Pos2 #save X for Doo2
sw $s3, Doo_Y_Pos2 #save Y for Doo2
sw $s5, Doo_Power2 #save power
sw $s7, shield2 #load shield



jal PAINTSCORE

jal PAINTSHIELD1
jal PAINTSHIELD2


lw $t6, score

bne $t6, 2, Skip5
jal PAINTAWESOME

Skip5:

bne $t6, 5, Skip6
jal PAINTPOGGERS

Skip6:
bne $t6, 8, Skip7
jal PAINTWOW

Skip7:

jal SLEEP

j LOOP



li $v0, 10 # terminate the program gracefully
syscall



PAINTSHIELD1:
addiu  $t0, $zero, 0 #inital counter
lw $t4, shield1
add $t1, $zero, $t4 #final val
lw $t2, greencolor	#greencolor
lw $t3, displayAddress #grid accumulator 
StartPaintSLoop1: bne $t0, $t1, PaintSLoop1
jr $ra

PaintSLoop1:
sw $t2, 0($t3)
addi $t3, $t3, 8
addi $t0, $t0, 1
j StartPaintSLoop1



PAINTSHIELD2:
addiu  $t0, $zero, 0 #inital counter
lw $t4, shield2
add $t1, $zero, $t4 #final val
lw $t2, purplecolor	#purplecolor
lw $t3, displayAddress #grid accumulator 
addi $t3, $t3, 128
StartPaintSLoop2: bne $t0, $t1, PaintSLoop2
jr $ra

PaintSLoop2:
sw $t2, 0($t3)
addi $t3, $t3, 8
addi $t0, $t0, 1
j StartPaintSLoop2




PAINTBOARD:
addiu  $t0, $zero, 0 #inital counter
add $t1, $zero, 4096 #final val
lw $t2, whitecolor	#white color
lw $t3, displayAddress #grid accumulator 
StartPaintBLoop: bne $t0, $t1, PaintBLoop
jr $ra

PaintBLoop:
sw $t2, 0($t3)
addi $t3, $t3, 4
addi $t0, $t0, 4
j StartPaintBLoop



PAINTD: #Paint the Doo





addi $t2, $s5, 0 #load power=8

#StartPaintDLoop: bne $zero, 1, PaintDLoop
#jr $ra

addi, $t6, $s3, 0 #import y



addi, $t7, $s4, 0 #import x 



mul $t5, $t6, 128
mul $t1, $t7, 4
add $t5, $t5, $t1
add $t0, $t0, $t5  #DOO's head's address
sw $t3,($t0)
addi $t0, $t0, 124
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 128
sw $t3,($t0)
addi $t0, $t0, -8
sw $t3,($t0)  #t0 is the left foot


move $t2, $s5 #load power

blez $t2, LowPower     #if power <=0 then go down

addi $t2, $t2, -1 #if power >0, power - 1
addi $t6, $t6, -1 #y-axis go down, DOO go up

#j StartPaintDLoop
SaveNewDooPos:
addi $s3, $t6, 0 #save y
addi $s4, $t7, 0 #save x
addi $s5, $t2, 0 #save power

lw $t0, displayAddress

jr $ra


LowPower:

#bgtz $t8, GoUp

addi $t5, $t6, -29
beq $t5, $zero GAMEOVER  #if Doo is at the bottom line, game over

addi $t8, $t0, 132 #left foot of doo's next line

lw $t4, ($t8)


#whitecolor: .word 0xffffff
#redcolor: .word 0xff0000

beq $t4, 0xffffff, NotHitObsL

addi $t8, $zero, 1

j Skip1

NotHitObsL:
addi $t8, $zero, 0

Skip1:


#addi $t9, $t0, 130 #right foot of Doo
#lw $t5, ($t9)
#beq $t5, 0xffffff, NotHitObsR

#addi $t9, $zero, 1 

#j Skip2

#NotHitObsR:
#addi $t9, $zero, 0

#Skip2:

#add $t8, $t8, $t9



bgtz $t8, GoUp

addi $t6, $t6, 1 #else, go down

j SaveNewDooPos

GoUp:
addi $t2, $zero, 12 #power set to 8
addi $t6, $t6, -1  #y-axis go up

j SaveNewDooPos



Keyboard_input:

lw $t9, 0xffff0004
beq $t9, 'a', MoveLeft1
beq $t9, 'd', MoveRight1

beq $t9, 'j', MoveLeft2
beq $t9, 'l', MoveRight2
jr $ra

MoveLeft1:
lw $t5, Doo_X_Pos1 #load initial X for Doo1
addi $t5, $t5, -1
sw $t5, Doo_X_Pos1
jr $ra

MoveRight1:
lw $t5, Doo_X_Pos1 #load initial X for Doo1
addi $t5, $t5, 1
sw $t5, Doo_X_Pos1
jr $ra

MoveLeft2:
lw $t5, Doo_X_Pos2 #load initial X for Doo2
addi $t5, $t5, -1
sw $t5, Doo_X_Pos2
jr $ra

MoveRight2:
lw $t5, Doo_X_Pos2 #load initial X for Doo2
addi $t5, $t5, 1
sw $t5, Doo_X_Pos2
jr $ra



PAINTOBS: #Paint obstacles
lw $t0, displayAddress # $t0 stores the base address for display

#addi, $t6, $a2, 0 #import y
#addi, $t7, $a1, 0 #inport x

lw $t3, redcolor #load red color

#mul $t5, $t6, 128
#mul $t7, $t7, 4

#add $t5, $t5, $t7

add $t0, $t0, $t5

sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
addi $t0, $t0, 4
sw $t3,($t0)
lw $t0, displayAddress
jr $ra


Gen_Random_New_Obs:
li $v0, 42 #obs is 8 bits long
li $a0, 0
li $a1, 25
syscall

move $a1, $a0
mul $t4, $a1, 4

jr $ra


ScreenMoveDown:

lw $t5, Doo_Y_Pos1
addi $t5, $t5, 1
sw $t5, Doo_Y_Pos1

lw $t5, Doo_Y_Pos2
addi $t5, $t5, 1
sw $t5, Doo_Y_Pos2



addi $s0, $s0, 128
addi $s1, $s1, 128
addi $s2, $s2, 128
addi $s6, $s6, 128

addi $sp, $sp, -4
sw $ra, ($sp)

addi $t9, $s0, -3967
jal Gen_Random_New_Obs
bgtz $t9, Assign_val_s0

Point1:

addi $t9, $s1, -3967
jal Gen_Random_New_Obs
bgtz $t9, Assign_val_s1

Point2:

addi $t9, $s2, -3967
jal Gen_Random_New_Obs
bgtz $t9, Assign_val_s2

Point3:

addi $t9, $s6,-3967
jal Gen_Random_New_Obs
bgtz $t9 Assign_val_s6

Point4:

lw $ra, ($sp)

jr $ra

Assign_val_s0:

addi $s0, $t4, 0
lw $t7, score
addi $t7, $t7, 1
sw $t7, score
j Point1

Assign_val_s1:

addi $s1, $t4, 0
lw $t7, score
addi $t7, $t7, 1
sw $t7, score
j Point2

Assign_val_s2:

addi $s2, $t4, 0
lw $t7, score
addi $t7, $t7, 1
sw $t7, score
j Point3

Assign_val_s6:

addi $s6, $t4, 0
lw $t7, score
addi $t7, $t7, 1
sw $t7, score
j Point4



SLEEP: 
li $v0, 32
li $a0, 150
syscall
jr $ra

GAMEOVER:

blez $s7, Skip8

addi $s7, $s7, -1
j GoUp

Skip8:

jal PAINTBOARD
lw $t0, displayAddress 

lw $t3, bluecolor #load blue color
sw $t3,1032($t0)
sw $t3,1036($t0)
sw $t3,1040($t0)
sw $t3,1052($t0)
sw $t3,1060($t0)
sw $t3,1064($t0)
sw $t3,1072($t0)
sw $t3,1076($t0)
sw $t3,1080($t0)
sw $t3,1084($t0)
sw $t3,1092($t0)
sw $t3,1096($t0)
sw $t3,1100($t0)
sw $t3,1112($t0)
sw $t3,1124($t0)
sw $t3,1136($t0)
sw $t3,1140($t0)
sw $t3,1160($t0)
sw $t3,1168($t0)
sw $t3,1172($t0)
sw $t3,1180($t0)
sw $t3,1184($t0)
sw $t3,1188($t0)
sw $t3,1192($t0)
sw $t3,1204($t0)
sw $t3,1208($t0)
sw $t3,1220($t0)
sw $t3,1228($t0)
sw $t3,1232($t0)
sw $t3,1240($t0)
sw $t3,1252($t0)
sw $t3,1264($t0)
sw $t3,1268($t0)
sw $t3,1288($t0)
sw $t3,1300($t0)
sw $t3,1308($t0)
sw $t3,1332($t0)
sw $t3,1336($t0)
sw $t3,1348($t0)
sw $t3,1360($t0)
sw $t3,1368($t0)
sw $t3,1380($t0)
sw $t3,1392($t0)
sw $t3,1396($t0)
sw $t3,1416($t0)
sw $t3,1428($t0)
sw $t3,1436($t0)
sw $t3,1460($t0)
sw $t3,1464($t0)
sw $t3,1476($t0)
sw $t3,1488($t0)
sw $t3,1496($t0)
sw $t3,1500($t0)
sw $t3,1504($t0)
sw $t3,1508($t0)
sw $t3,1520($t0)
sw $t3,1524($t0)
sw $t3,1544($t0)
sw $t3,1552($t0)
sw $t3,1556($t0)
sw $t3,1564($t0)
sw $t3,1568($t0)
sw $t3,1572($t0)
sw $t3,1576($t0)
sw $t3,1588($t0)
sw $t3,1592($t0)
sw $t3,1604($t0)
sw $t3,1612($t0)
sw $t3,1616($t0)
sw $t3,1624($t0)
sw $t3,1628($t0)
sw $t3,1632($t0)
sw $t3,1636($t0)
sw $t3,1648($t0)
sw $t3,1652($t0)
sw $t3,1672($t0)
sw $t3,1676($t0)
sw $t3,1680($t0)
sw $t3,1692($t0)
sw $t3,1696($t0)
sw $t3,1700($t0)
sw $t3,1704($t0)
sw $t3,1716($t0)
sw $t3,1720($t0)
sw $t3,1732($t0)
sw $t3,1736($t0)
sw $t3,1740($t0)
sw $t3,1756($t0)
sw $t3,1760($t0)
sw $t3,1776($t0)
sw $t3,1780($t0)
sw $t3,1800($t0)
sw $t3,1804($t0)
sw $t3,1820($t0)
sw $t3,1824($t0)
sw $t3,1828($t0)
sw $t3,1832($t0)
sw $t3,1844($t0)
sw $t3,1848($t0)
sw $t3,1860($t0)
sw $t3,1864($t0)
sw $t3,1884($t0)
sw $t3,1888($t0)
sw $t3,1904($t0)
sw $t3,1908($t0)
sw $t3,1928($t0)
sw $t3,1932($t0)
sw $t3,1948($t0)
sw $t3,1972($t0)
sw $t3,1976($t0)
sw $t3,1988($t0)
sw $t3,1992($t0)
sw $t3,2012($t0)
sw $t3,2016($t0)
sw $t3,2032($t0)
sw $t3,2036($t0)
sw $t3,2056($t0)
sw $t3,2060($t0)
sw $t3,2064($t0)
sw $t3,2076($t0)
sw $t3,2100($t0)
sw $t3,2104($t0)
sw $t3,2116($t0)
sw $t3,2120($t0)
sw $t3,2124($t0)
sw $t3,2140($t0)
sw $t3,2144($t0)
sw $t3,2160($t0)
sw $t3,2164($t0)
sw $t3,2184($t0)
sw $t3,2192($t0)
sw $t3,2196($t0)
sw $t3,2204($t0)
sw $t3,2228($t0)
sw $t3,2232($t0)
sw $t3,2244($t0)
sw $t3,2252($t0)
sw $t3,2256($t0)
sw $t3,2268($t0)
sw $t3,2272($t0)
sw $t3,2288($t0)
sw $t3,2292($t0)
sw $t3,2312($t0)
sw $t3,2320($t0)
sw $t3,2324($t0)
sw $t3,2332($t0)
sw $t3,2356($t0)
sw $t3,2360($t0)
sw $t3,2372($t0)
sw $t3,2380($t0)
sw $t3,2384($t0)
sw $t3,2396($t0)
sw $t3,2400($t0)
sw $t3,2440($t0)
sw $t3,2452($t0)
sw $t3,2460($t0)
sw $t3,2464($t0)
sw $t3,2468($t0)
sw $t3,2472($t0)
sw $t3,2484($t0)
sw $t3,2488($t0)
sw $t3,2500($t0)
sw $t3,2512($t0)
sw $t3,2524($t0)
sw $t3,2528($t0)
sw $t3,2544($t0)
sw $t3,2548($t0)
sw $t3,2568($t0)
sw $t3,2588($t0)
sw $t3,2592($t0)
sw $t3,2596($t0)
sw $t3,2600($t0)
sw $t3,2612($t0)
sw $t3,2616($t0)
sw $t3,2628($t0)
sw $t3,2652($t0)
sw $t3,2656($t0)
sw $t3,2672($t0)
sw $t3,2676($t0)
sw $t3,1056($t0)


#lw $t8, 0xffff0000
#beq $t8, 1, Keyboard_input

lw $t9, 0xffff0004
beq $t9, 'r', MAIN

j GAMEOVER



PAINTAWESOME:
jal PAINTBOARD
lw $t0, displayAddress 

lw $t3, bluecolor #load blue color

sw $t3,900($t0)
sw $t3,904($t0)
sw $t3,916($t0)
sw $t3,932($t0)
sw $t3,940($t0)
sw $t3,944($t0)
sw $t3,948($t0)
sw $t3,960($t0)
sw $t3,964($t0)
sw $t3,972($t0)
sw $t3,976($t0)
sw $t3,980($t0)
sw $t3,992($t0)
sw $t3,1000($t0)
sw $t3,1012($t0)
sw $t3,1016($t0)
sw $t3,1020($t0)
sw $t3,1004($t0)
sw $t3,1036($t0)
sw $t3,1044($t0)
sw $t3,1060($t0)
sw $t3,1068($t0)
sw $t3,1084($t0)
sw $t3,1100($t0)
sw $t3,1108($t0)
sw $t3,1116($t0)
sw $t3,1124($t0)
sw $t3,1132($t0)
sw $t3,1140($t0)
sw $t3,1152($t0)
sw $t3,1164($t0)
sw $t3,1172($t0)
sw $t3,1188($t0)
sw $t3,1196($t0)
sw $t3,1200($t0)
sw $t3,1216($t0)
sw $t3,1228($t0)
sw $t3,1236($t0)
sw $t3,1244($t0)
sw $t3,1252($t0)
sw $t3,1260($t0)
sw $t3,1268($t0)
sw $t3,1272($t0)
sw $t3,1280($t0)
sw $t3,1284($t0)
sw $t3,1288($t0)
sw $t3,1292($t0)
sw $t3,1300($t0)
sw $t3,1308($t0)
sw $t3,1316($t0)
sw $t3,1324($t0)
sw $t3,1348($t0)
sw $t3,1356($t0)
sw $t3,1364($t0)
sw $t3,1372($t0)
sw $t3,1388($t0)
sw $t3,1396($t0)
sw $t3,1408($t0)
sw $t3,1420($t0)
sw $t3,1428($t0)
sw $t3,1436($t0)
sw $t3,1444($t0)
sw $t3,1452($t0)
sw $t3,1476($t0)
sw $t3,1484($t0)
sw $t3,1492($t0)
sw $t3,1500($t0)
sw $t3,1516($t0)
sw $t3,1524($t0)
sw $t3,1536($t0)
sw $t3,1548($t0)
sw $t3,1560($t0)
sw $t3,1568($t0)
sw $t3,1580($t0)
sw $t3,1584($t0)
sw $t3,1588($t0)
sw $t3,1596($t0)
sw $t3,1600($t0)
sw $t3,1612($t0)
sw $t3,1616($t0)
sw $t3,1620($t0)
sw $t3,1628($t0)
sw $t3,1644($t0)
sw $t3,1652($t0)
sw $t3,1656($t0)
sw $t3,1660($t0)

sw $t3,1980($t0)
sw $t3,1984($t0)
sw $t3,2108($t0)
sw $t3,2112($t0)
sw $t3,2236($t0)
sw $t3,2240($t0)
sw $t3,2364($t0)
sw $t3,2368($t0)
sw $t3,2492($t0)
sw $t3,2496($t0)
sw $t3,2748($t0)
sw $t3,2752($t0)
sw $t3,2876($t0)
sw $t3,2880($t0)

lw $t7, score
addi $t7, $t7, 1
sw $t7, score

li $v0, 32
li $a0, 800
syscall

j LOOP


PAINTWOW:
jal PAINTBOARD
lw $t0, displayAddress 

lw $t3, bluecolor #load blue color

sw $t3,792($t0)
sw $t3,808($t0)
sw $t3,824($t0)
sw $t3,832($t0)
sw $t3,848($t0)
sw $t3,864($t0)
sw $t3,920($t0)
sw $t3,936($t0)
sw $t3,948($t0)
sw $t3,964($t0)
sw $t3,976($t0)
sw $t3,992($t0)
sw $t3,1048($t0)
sw $t3,1064($t0)
sw $t3,1076($t0)
sw $t3,1092($t0)
sw $t3,1104($t0)
sw $t3,1120($t0)
sw $t3,1176($t0)
sw $t3,1184($t0)
sw $t3,1192($t0)
sw $t3,1204($t0)
sw $t3,1220($t0)
sw $t3,1232($t0)
sw $t3,1240($t0)
sw $t3,1248($t0)
sw $t3,1304($t0)
sw $t3,1312($t0)
sw $t3,1320($t0)
sw $t3,1332($t0)
sw $t3,1348($t0)
sw $t3,1360($t0)
sw $t3,1368($t0)
sw $t3,1376($t0)
sw $t3,1436($t0)
sw $t3,1444($t0)
sw $t3,1464($t0)
sw $t3,1468($t0)
sw $t3,1472($t0)
sw $t3,1492($t0)
sw $t3,1500($t0)


sw $t3,1980($t0)
sw $t3,1984($t0)
sw $t3,2108($t0)
sw $t3,2112($t0)
sw $t3,2236($t0)
sw $t3,2240($t0)
sw $t3,2364($t0)
sw $t3,2368($t0)
sw $t3,2492($t0)
sw $t3,2496($t0)
sw $t3,2748($t0)
sw $t3,2752($t0)
sw $t3,2876($t0)
sw $t3,2880($t0)

lw $t7, score
addi $t7, $t7, 1
sw $t7, score

li $v0, 32
li $a0, 800
syscall

j LOOP


PAINTPOGGERS:
jal PAINTBOARD
lw $t0, displayAddress 

lw $t3, bluecolor #load blue color

sw $t3,772($t0)
sw $t3,776($t0)
sw $t3,900($t0)
sw $t3,908($t0)
sw $t3,1028($t0)
sw $t3,1036($t0)
sw $t3,1044($t0)
sw $t3,1048($t0)
sw $t3,1052($t0)
sw $t3,1060($t0)
sw $t3,1064($t0)
sw $t3,1068($t0)
sw $t3,1076($t0)
sw $t3,1080($t0)
sw $t3,1084($t0)
sw $t3,1096($t0)
sw $t3,1100($t0)
sw $t3,1112($t0)
sw $t3,1124($t0)
sw $t3,1136($t0)
sw $t3,1140($t0)
sw $t3,1144($t0)
sw $t3,1156($t0)
sw $t3,1160($t0)
sw $t3,1172($t0)
sw $t3,1180($t0)
sw $t3,1188($t0)
sw $t3,1196($t0)
sw $t3,1204($t0)
sw $t3,1212($t0)
sw $t3,1220($t0)
sw $t3,1232($t0)
sw $t3,1244($t0)
sw $t3,1248($t0)
sw $t3,1260($t0)
sw $t3,1284($t0)
sw $t3,1300($t0)
sw $t3,1304($t0)
sw $t3,1308($t0)
sw $t3,1316($t0)
sw $t3,1320($t0)
sw $t3,1324($t0)
sw $t3,1332($t0)
sw $t3,1336($t0)
sw $t3,1340($t0)
sw $t3,1348($t0)
sw $t3,1352($t0)
sw $t3,1356($t0)
sw $t3,1360($t0)
sw $t3,1372($t0)
sw $t3,1392($t0)
sw $t3,1396($t0)
sw $t3,1412($t0)
sw $t3,1452($t0)
sw $t3,1468($t0)
sw $t3,1476($t0)
sw $t3,1500($t0)
sw $t3,1528($t0)
sw $t3,1572($t0)
sw $t3,1576($t0)
sw $t3,1580($t0)
sw $t3,1588($t0)
sw $t3,1592($t0)
sw $t3,1596($t0)
sw $t3,1608($t0)
sw $t3,1612($t0)
sw $t3,1628($t0)
sw $t3,1644($t0)
sw $t3,1648($t0)
sw $t3,1652($t0)


sw $t3,1980($t0)
sw $t3,1984($t0)
sw $t3,2108($t0)
sw $t3,2112($t0)
sw $t3,2236($t0)
sw $t3,2240($t0)
sw $t3,2364($t0)
sw $t3,2368($t0)
sw $t3,2492($t0)
sw $t3,2496($t0)
sw $t3,2748($t0)
sw $t3,2752($t0)
sw $t3,2876($t0)
sw $t3,2880($t0)

lw $t7, score
addi $t7, $t7, 1
sw $t7, score

li $v0, 32
li $a0, 800
syscall

j LOOP


















PAINTSCORE:


addi $sp, $sp, -4
sw $ra, ($sp)  #save ra

lw $t2, score #load score
addi $t3, $zero, 10
div $t2, $t3

mflo $t2 #Quotinet
mfhi $t3 #Remainder


#paint 10 digit +100
addi $t4, $zero, 100

bne $t2, 0, Point5
jal Paint0

Point5:
bne $t2, 1, Point6
jal Paint1

Point6:
bne $t2, 2, Point7
jal Paint2

Point7:
bne $t2, 3, Point8
jal Paint3

Point8:
bne $t2, 4, Point9
jal Paint4

Point9:
bne $t2, 5, Point10
jal Paint5

Point10:
bne $t2, 6, Point11
jal Paint6

Point11:
bne $t2, 7, Point12
jal Paint7

Point12:
bne $t2, 8, Point13
jal Paint8

Point13:
bne $t2, 9, Point14
jal Paint9

Point14:

#paint 01 digit +116
move $t2, $t3
addi $t4, $zero, 116

bne $t2, 0, Point0
jal Paint0

Point0:

bne $t2, 1, Point15
jal Paint1

Point15:
bne $t2, 2, Point16
jal Paint2

Point16:
bne $t2, 3, Point17
jal Paint3

Point17:
bne $t2, 4, Point18
jal Paint4

Point18:
bne $t2, 5, Point19
jal Paint5

Point19:
bne $t2, 6, Point20
jal Paint6

Point20:
bne $t2, 7, Point21
jal Paint7

Point21:
bne $t2, 8, Point22
jal Paint8

Point22:
bne $t2, 9, Point23
jal Paint9

Point23:

lw $ra, ($sp) 
jr $ra


Paint0:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 264($t0)
sw $t1, 384($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint1:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 8($t0)
sw $t1, 136($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 520($t0)
jr $ra 

Paint2:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 384($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint3:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint4:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 520($t0)
jr $ra 

Paint5:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint6:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 384($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint7:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 136($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 520($t0)
jr $ra 

Paint8:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 384($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 

Paint9:
lw $t0, displayAddress
add $t0, $t0, $t4  #load address
lw $t1, blackcolor #load black color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 128($t0)
sw $t1, 136($t0)
sw $t1, 256($t0)
sw $t1, 260($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
jr $ra 


Exit:
li $v0, 10 # terminate the program gracefully
syscall
