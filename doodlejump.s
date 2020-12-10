#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Yingke Wang, Student Number: 1005072751
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?

# - Milestone 1
#
#####################################################################

.data 
displayAddress: .word 0x10008000
platform1: .word 0x100082B8
platform2: .word 0x10008864
platform3: .word 0x10008D24
baseline: .word 0x10008E80
platform3Visible: .word 1
Doodle: .word 0x10008BAC
GameEnd: .word 0
red: .word 0xff0000
blue: .word 0x33D5FF
green: .word 0x00ff00
white: .word 0xffffff
lastUnit: .word 0x10008ffc
orange: .word 0xffa500
brown: .word 0xa0522d
grey: .word 0x808080
score: .word 0
awsDisplayed: .word 0
pogDisplayed: .word 0
wowDisplayed: .word 0
sheidLeft: 3
sheidDurLeft: 0

platDir: .word 4
.text
main: 	
#Draw the screen
jal DRAWSCREEN
#Draw Platform 1
lw $s1, platform1	#s1: platform1 
addi $sp, $sp, -4
sw $s1, 0($sp)
jal DRAWPLA
lw $s1, 0($sp)
addi $sp, $sp, 4	#load s1 back
# Draw Platform 2
lw $s2, platform2	#s2: platform2
addi $sp, $sp, -4
sw $s2, 0($sp)	
jal DRAWPLA
lw $s2, 0($sp)
addi $sp, $sp, 4
#Draw Platform 3
lw $s3, platform3	#s3: platform3
addi $sp, $sp, -4
sw $s3, 0($sp)		
jal DRAWPLA3
lw $s3, 0($sp)
addi $sp, $sp, 4
# Draw Doodle
lw $s4, Doodle		#s4: doodle
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOO
addi $s5, $zero, 20 #s5: vertical move
addi $s6, $zero, 0 #s6: base offset
MainLoop:
lw $t7, GameEnd
beq $t7, $zero, SingleIteration
jal DrawEndScreen
Exit:
li $v0, 10 # terminate the program gracefully
syscall

Plat1Move:
addi $t0, $zero, 128
div $s1, $t0
mfhi $t1
slti $t2, $t1, 5
beq $t2, 1, plat_move_right
addi $t0, $zero, 99
slt $t2, $t0, $t1
beq $t2, 1, plat_move_left
exit_PlatMove:
lw $t0, platDir
add $s1, $s1, $t0
jr $ra


plat_move_right:
addi $t0, $zero, 4
sw $t0, platDir
j exit_PlatMove

plat_move_left:
addi $t0, $zero, -4
sw $t0, platDir
j exit_PlatMove


DrawEndScreen:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal drawEND
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


SingleIteration:
jal DETACT_INPUT

jal Change_doodle_pos
j REDRAW

Change_doodle_pos:
bgtz $s5 doodle_jump_up
blez $s5 doodle_jump_down
check_collison:
blez $s5 check_doodle_collison

exit_change_doodle_pos:
jr $ra

check_doodle_collison:
#check platform 1
lw $t0, score #load score
#check platform 1
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $s1, 0($sp)	#position argument
addi $sp, $sp, -4
sw $t0, 0($sp) #score argument
jal check_platform_collison
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, score	#save the score back
#check platform 2
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $s2, 0($sp)	#position argument
addi $sp, $sp, -4
sw $t0, 0($sp) #score argument
jal check_platform_collison
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, score	#save the score back
#check platform 3
lw $t4, platform3Visible
beq $t4, 0, finish_check_platforms
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $s3, 0($sp)	#position argument
addi $sp, $sp, -4
sw $t0, 0($sp) #score argument
jal check_platform_collison
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, score	#save the score back
finish_check_platforms:
bne $s5, 0, exit_check_doodle_collison
addi $s5, $s5, 20
exit_check_doodle_collison:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal check_doodle_outbound
lw $ra, 0($sp)
addi $sp, $sp, 4
j exit_change_doodle_pos

check_doodle_outbound:
lw $t3, lastUnit	
slt $t0, $t3, $s4
blez $t0, exit_check_doodle_outbound
lw $t3, sheidDurLeft
bgtz $t3, handle_use_sheid
sw $t0, GameEnd
exit_check_doodle_outbound:
jr $ra

handle_use_sheid:
addi $t3, $zero, 0
sw $t3, sheidDurLeft
addi $s5, $s5, 25
j exit_check_doodle_outbound


check_platform_collison:
lw $t6, 0($sp)		#load score
addi $sp, $sp, 4
lw $t0, 0($sp)		#platform position
addi $sp, $sp, 4
add $t1, $s4, 384	#t1: doodle pos
addi $t2, $t0, 28	#t2: end
addi $t0, $t0, -4	#t0: start
slt $t3, $t0, $t1
slt $t4, $t1, $t2
and $t5, $t3, $t4	#t5: collison boolean
beq $t5, $zero, exit_check_platform_collison
addi $s5, $zero, 0	#set doodle to stop
addi $t0, $t0, 4
beq $t0, $s3, check_platform3_collison
check_normal_platform_collison:
lw $t3, baseline		#load the baseline
sub $t3, $t3, $t0
addi $t4, $zero, 128
div $t3, $t4
mflo $t4
blez $t4, exit_check_platform_collison
addi $s6, $t4, 0
addi $t6, $t6, 1

exit_check_platform_collison:
addi $sp, $sp, -4
sw $t6, 0($sp)
jr $ra

check_platform3_collison:
addi $t3, $zero, 0
sw $t3, platform3Visible
j check_normal_platform_collison

doodle_jump_down:
addi $s4, $s4, 128
j check_collison


doodle_jump_up:
addi $s4, $s4, -128
addi $s5, $s5, -1
beq $s5, $zero change_vertical_direct
exit_doodle_jump_up:
j check_collison

change_vertical_direct:
addi $s5, $s5, -1
j exit_doodle_jump_up


REDRAW:
#Draw the screen
blez $s6, startRedraw
addi $s1, $s1, 128
addi $sp, $sp, -4
sw $s1, 0($sp)
jal Check_plat_outbound
lw $s1, 0($sp)
addi $sp, $sp, 4
addi $s2, $s2, 128
addi $sp, $sp, -4
sw $s2, 0($sp)
jal Check_plat_outbound
lw $s2, 0($sp)
addi $sp, $sp, 4
addi $s3, $s3, 128
addi $sp, $sp, -4
sw $s3, 0($sp)
jal Check_plat_outbound
lw $s3, 0($sp)
addi $sp, $sp, 4
addi $s4, $s4, 128
addi $s6, $s6, -1

startRedraw:
jal DRAWSCREEN
jal DrawSheid
jal DRAWSCORE
jal Plat1Move
#Draw Platform 1
addi $sp, $sp, -4
sw $s1, 0($sp)
jal DRAWPLA
lw $s1, 0($sp)
addi $sp, $sp, 4	#load s1 back
# Draw Platform 2
addi $sp, $sp, -4
sw $s2, 0($sp)	
jal DRAWPLA
lw $s2, 0($sp)		#load s2 back
addi $sp, $sp, 4
#Draw Platform 3
addi $sp, $sp, -4
sw $s3, 0($sp)		# load s3 back	
jal DRAWPLA3
lw $s3, 0($sp)
addi $sp, $sp, 4
# Draw Doodle
lw $t0, sheidDurLeft
bgtz $t0, handleDrawDOOAct
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOO
endRedraw:
jal SLEEP
j MainLoop

handleDrawDOOAct:
addi $t0, $t0, -1
sw $t0, sheidDurLeft
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOOActive
j endRedraw

DrawSheid:
lw $t0, sheidLeft
lw $t5, displayAddress
addi $t5, $t5, 4
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t5, 0($sp)
addi $sp, $sp, -4
sw $t0, 0($sp)
jal DRAWDigit
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


DRAWSCORE:
lw $t0, score
beq $t0, 5, handleAwesome
beq $t0, 10, handlePoggers
beq $t0, 15, handleWow
startDRAWSCORE:
addi $t1, $zero, 10
div $t0, $t1
mflo $t2 #10s
mfhi $t3 #1s
lw $t0, displayAddress
addi $t4, $t0, 48 #10s start
addi $t5, $t0, 64 #1s start
#draw 10s
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t2, 0($sp)
addi $sp, $sp, -4
sw $t3, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -4
sw $t5, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
addi $sp, $sp, -4
sw $t2, 0($sp)
jal DRAWDigit
lw $t5, 0($sp)
addi $sp, $sp, 4
lw $t4, 0($sp)
addi $sp, $sp, 4
lw $t3, 0($sp)
addi $sp, $sp, 4
lw $t2, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
#draw 1s
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t5, 0($sp)
addi $sp, $sp, -4
sw $t3, 0($sp)
jal DRAWDigit
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


handleAwesome:
lw $t1, awsDisplayed
beq $t1, 1, startDRAWSCORE
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t0, 0($sp)
jal DrawAwesome
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $t1, $zero, 1
sw $t1, awsDisplayed
li $v0, 32
li $a0, 2500
syscall
j startDRAWSCORE

handleWow:
lw $t1, wowDisplayed
beq $t1, 1, startDRAWSCORE
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t0, 0($sp)
jal DrawWow
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $t1, $zero, 1
sw $t1, wowDisplayed
li $v0, 32
li $a0, 2500
syscall
j startDRAWSCORE

handlePoggers:
lw $t1, pogDisplayed
beq $t1, 1, startDRAWSCORE
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t0, 0($sp)
jal DrawPoggers
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $t1, $zero, 1
sw $t1, pogDisplayed
li $v0, 32
li $a0, 2500
syscall
j startDRAWSCORE

DRAWDigit:
lw $t0, 0($sp) #number
addi $sp, $sp, 4
lw $t1, 0($sp)	#start pos
addi $sp, $sp, 4
addi $t6, $zero, 0
slti $t6, $t0, 1
bgtz $t6, handle0
slti $t6, $t0, 2
bgtz $t6, handle1
slti $t6, $t0, 3
bgtz $t6, handle2
slti $t6, $t0, 4
bgtz $t6, handle3
slti $t6, $t0, 5
bgtz $t6, handle4
slti $t6, $t0, 6
bgtz $t6, handle5
slti $t6, $t0, 7
bgtz $t6, handle6
slti $t6, $t0, 8
bgtz $t6, handle7
slti $t6, $t0, 9
bgtz $t6, handle8
j handle9
drawdigit_exit:
jr $ra

handle0:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw0
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle1:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw1

lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle2:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw2
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle3:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw3
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle4:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw4
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle5:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw5
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle6:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw6
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle7:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw7
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle8:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw8
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit

handle9:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t1, 0($sp)
jal draw9
lw $ra, 0($sp)
addi $sp, $sp, 4
j drawdigit_exit



Check_plat_outbound:
lw $t0 0($sp)
addi $sp, $sp, 4
lw $t1 lastUnit
slt $t2, $t1, $t0
blez $t2, exit_plat_outbound
beq $t0, $s3, platform3_reappear
generate_random_plat:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal Generate_random_pos
lw $t0 0($sp) #new position
addi $sp, $sp, 4
lw $ra 0($sp)
addi $sp, $sp, 4
exit_plat_outbound:
addi $sp, $sp, -4
sw $t0 0($sp)
jr $ra

platform3_reappear:
addi $t4, $zero, 1
sw $t4, platform3Visible
j generate_random_plat

DRAWSCREEN:
addiu  $t0, $zero, 0 #inital counter
add $t1, $zero, 1024 #final val
lw $t2, white	#white color
lw $t3, displayAddress #grid accumulator 
StartScreenLoop: bne $t0, $t1, ScreenLoop
jr $ra
ScreenLoop:
sw $t2, 0($t3)
addi $t3, $t3, 4
addi $t0, $t0, 1
j StartScreenLoop

DRAWDOOActive:
lw $t0 0($sp) #lode the position into t0
addi $sp, $sp, 4
lw $t1, green #load color green into t1
sw $t1 0($t0)
addi $t0, $t0, 128
sw $t1 0($t0)
addi $t0, $t0, -4
sw $t1 0($t0)
addi $t0, $t0, 8
sw $t1 0($t0)
addi $t0, $t0, 120
sw $t1 0($t0)
addi $t0, $t0, 8
sw $t1 0($t0)
jr $ra



DRAWDOO:
lw $t0 0($sp) #lode the position into t0
addi $sp, $sp, 4
lw $t1, grey #load color green into t1
sw $t1 0($t0)
addi $t0, $t0, 128
sw $t1 0($t0)
addi $t0, $t0, -4
sw $t1 0($t0)
addi $t0, $t0, 8
sw $t1 0($t0)
addi $t0, $t0, 120
sw $t1 0($t0)
addi $t0, $t0, 8
sw $t1 0($t0)
jr $ra


DRAWPLA: 
lw $t0 0($sp)	#load the position of the platform
addi $t1, $zero, 0 #inital i
addi $t2 $zero, 7 #final counter
lw $t3, red #load red
StartPlatLoop: bne $t1, $t2, PlatLoop
jr $ra
PlatLoop: 
sw $t3, 0($t0)
addi $t0, $t0, 4
addi $t1, $t1 ,1
j StartPlatLoop

DRAWPLA3: 
lw $t0 0($sp)	#load the position of the platform
addi $t1, $zero, 0 #inital i
addi $t2 $zero, 7 #final counter
lw $t4, platform3Visible
beq $t4, 0, loadDRAWPLA3white
lw $t3, brown #load red
StartPlat3Loop: 
bne $t1, $t2, Plat3Loop
jr $ra
Plat3Loop: 
sw $t3, 0($t0)
addi $t0, $t0, 4
addi $t1, $t1 ,1
j StartPlat3Loop

loadDRAWPLA3white:
lw $t3, white
j StartPlat3Loop

DETACT_INPUT:
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input

detact_exit:
jr $ra

keyboard_input:
lw $t2, 0xffff0004
beq $t2, 0x6A, respond_to_j
beq $t2, 0x6B, respond_to_k
beq $t2, 0x69, respond_to_i
return_keyboard_back:
j detact_exit

respond_to_j:
addi $s4, $s4, -8
j return_keyboard_back

respond_to_k:
addi $s4, $s4, 8
j return_keyboard_back

respond_to_i:
lw $t2, sheidLeft
blez $t2, return_keyboard_back
addi $t2, $t2, -1
sw $t2, sheidLeft
addi $t2, $zero, 50
sw $t2, sheidDurLeft
j return_keyboard_back

Generate_random_pos:
li $v0, 42
li $a0, 0
li $a1, 25
syscall
addi $t0, $zero, 4
mult $a0, $t0
mflo $t1
lw $t0, displayAddress
add $t0, $t0, $t1
addi $sp, $sp, -4
sw $t0, 0($sp)
jr $ra

draw0:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw1:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
sw $t1, 0($t0)
sw $t1, 128($t0)
sw $t1, 256($t0)
sw $t1, 384($t0)
sw $t1, 512($t0)
jr $ra 

draw2:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw3:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw4:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw5:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw6:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw7:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 136($t0)
sw $t1, 264($t0)
sw $t1, 392($t0)
sw $t1, 520($t0)
jr $ra

draw8:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

draw9:
lw $t0, 0($sp) #leftupper corner
addi $sp, $sp, 4
lw $t1, blue # blue color
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

drawEND:
lw $t0, displayAddress
lw $t1, orange
#draw E
sw $t1, 1940($t0)
sw $t1, 1944($t0)
sw $t1, 1948($t0)
sw $t1, 1952($t0)
sw $t1, 1956($t0)
sw $t1, 2068($t0)
sw $t1, 2196($t0)
sw $t1, 2324($t0)
sw $t1, 2452($t0)
sw $t1, 2580($t0)
sw $t1, 2584($t0)
sw $t1, 2588($t0)
sw $t1, 2592($t0)
sw $t1, 2096($t0)
sw $t1, 2708($t0)
sw $t1, 2836($t0)
sw $t1, 2964($t0)
sw $t1, 3092($t0)
sw $t1, 3220($t0)
sw $t1, 3224($t0)
sw $t1, 3228($t0)
sw $t1, 3232($t0)
sw $t1, 3236($t0)
# draw N
sw $t1, 1968($t0)
sw $t1, 2096($t0)
sw $t1, 2224($t0)
sw $t1, 2352($t0)
sw $t1, 2480($t0)
sw $t1, 2608($t0)
sw $t1, 2736($t0)
sw $t1, 2864($t0)
sw $t1, 2992($t0)
sw $t1, 3120($t0)
sw $t1, 3248($t0)
sw $t1, 2100($t0)
sw $t1, 2232($t0)
sw $t1, 2360($t0)
sw $t1, 2488($t0)
sw $t1, 2616($t0)
sw $t1, 2744($t0)
sw $t1, 2872($t0)
sw $t1, 3000($t0)
sw $t1, 3132($t0)
sw $t1, 3136($t0)
sw $t1, 3264($t0)
sw $t1, 3008($t0)
sw $t1, 2880($t0)
sw $t1, 2752($t0)
sw $t1, 2624($t0)
sw $t1, 2496($t0)
sw $t1, 2368($t0)
sw $t1, 2240($t0)
sw $t1, 2112($t0)
sw $t1, 1984($t0)
#Draw D
sw $t1, 1996($t0)
sw $t1, 2124($t0)
sw $t1, 2128($t0)
sw $t1, 2252($t0)
sw $t1, 2380($t0)
sw $t1, 2508($t0)
sw $t1, 2636($t0)
sw $t1, 2764($t0)
sw $t1, 2892($t0)
sw $t1, 3020($t0)
sw $t1, 3148($t0)
sw $t1, 3276($t0)
sw $t1, 3120($t0)
sw $t1, 2260($t0)
sw $t1, 2392($t0)
sw $t1, 2524($t0)
sw $t1, 2652($t0)
sw $t1, 2780($t0)
sw $t1, 2904($t0)
sw $t1, 3028($t0)
sw $t1, 3152($t0)
jr $ra

DrawAwesome:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal DRAWSCREEN
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, displayAddress
#call drawA
addi $t4, $t3, 1424
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawA
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawW
addi $t4, $t3, 1448
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawW
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawe
addi $t4, $t3, 1344
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawe
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawS
addi $t4, $t3, 1496
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawS
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawO
addi $t4, $t3, 1520
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawO
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawM
addi $t4, $t3, 2716
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawM
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawExpo
addi $t4, $t3, 2744
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawExpo
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawe
addi $t4, $t3, 2772
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawe
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

DrawWow:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal DRAWSCREEN
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, displayAddress
#call drawW
addi $t4, $t3, 1424
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawW
lw $ra, 0($sp)
addi $sp, $sp, 4

#call drawO
addi $t4, $t3, 1344
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawO
lw $ra, 0($sp)
addi $sp, $sp, 4

#call drawW
addi $t4, $t3, 1520
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawW
lw $ra, 0($sp)
addi $sp, $sp, 4

#call drawExpo
addi $t4, $t3, 2744
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawExpo
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra



DrawPoggers:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal DRAWSCREEN
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, displayAddress
#call drawP
addi $t4, $t3, 1424
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawP
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawO
addi $t4, $t3, 1448
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawO
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawg
addi $t4, $t3, 1472
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawg
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawg
addi $t4, $t3, 1496
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawg
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawe
addi $t4, $t3, 1520
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawe
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawr
addi $t4, $t3, 2716
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawr
lw $ra, 0($sp)
addi $sp, $sp, 4
#call drawExpo
addi $t4, $t3, 2744
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawExpo
lw $ra, 0($sp)
addi $sp, $sp, 4
#call draws
addi $t4, $t3, 2772
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $t4, 0($sp)
jal drawS
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra



drawA:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange 
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 380($t0)
sw $t1, 384($t0)
sw $t1, 388($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 520($t0)
sw $t1, 632($t0)
sw $t1, 648($t0)
sw $t1, 760($t0)
sw $t1, 776($t0)
sw $t1, 888($t0)
sw $t1, 904($t0)
jr $ra

drawW:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, -8($t0)
sw $t1, 8($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 512($t0)
sw $t1, 520($t0)
sw $t1, 632($t0)
sw $t1, 640($t0)
sw $t1, 648($t0)
sw $t1, 760($t0)
sw $t1, 768($t0)
sw $t1, 776($t0)
sw $t1, 892($t0)
sw $t1, 900($t0)
jr $ra

drawe:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 124($t0)
sw $t1, 128($t0)
sw $t1, 132($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 380($t0)
sw $t1, 384($t0)
sw $t1, 388($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 632($t0)
sw $t1, 760($t0)
sw $t1, 892($t0)
sw $t1, 896($t0)
sw $t1, 900($t0)
sw $t1, 776($t0)
jr $ra

drawS:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 376($t0)
sw $t1, 504($t0)
sw $t1, 508($t0)
sw $t1, 512($t0)
sw $t1, 516($t0)
sw $t1, 648($t0)
sw $t1, 776($t0)
sw $t1, 892($t0)
sw $t1, 896($t0)
sw $t1, 900($t0)
jr $ra

drawO: 
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 520($t0)
sw $t1, 632($t0)
sw $t1, 648($t0)
sw $t1, 760($t0)
sw $t1, 776($t0)
sw $t1, 892($t0)
sw $t1, 896($t0)
sw $t1, 900($t0)
jr $ra

drawP:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 4($t0)
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 380($t0)
sw $t1, 384($t0)
sw $t1, 388($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 632($t0)
sw $t1, 760($t0)
sw $t1, 888($t0)
jr $ra

drawg:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 4($t0)
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 380($t0)
sw $t1, 384($t0)
sw $t1, 388($t0)
sw $t1, 392($t0)
sw $t1, 520($t0)
sw $t1, 648($t0)
sw $t1, 776($t0)
sw $t1, 888($t0)
sw $t1, 892($t0)
sw $t1, 896($t0)
sw $t1, 900($t0)
jr $ra

drawM: 
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 4($t0)
sw $t1, -4($t0)
sw $t1, 120($t0)
sw $t1, 128($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 256($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 384($t0)
sw $t1, 392($t0)
sw $t1, 504($t0)
sw $t1, 520($t0)
sw $t1, 632($t0)
sw $t1, 648($t0)
sw $t1, 760($t0)
sw $t1, 776($t0)
jr $ra

drawr:
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 4($t0)
sw $t1, 0($t0)
sw $t1, -4($t0)
sw $t1, 120($t0)
sw $t1, 136($t0)
sw $t1, 248($t0)
sw $t1, 264($t0)
sw $t1, 376($t0)
sw $t1, 504($t0)
sw $t1, 632($t0)
sw $t1, 760($t0)
sw $t1, 888($t0)
jr $ra

drawExpo: 
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t1, orange
sw $t1, 0($t0)
sw $t1, 128($t0)
sw $t1, 256($t0)
sw $t1, 384($t0)
sw $t1, 512($t0)
sw $t1, 640($t0)
sw $t1, 896($t0)
jr $ra


SLEEP:
li $v0, 32
li $a0, 100
syscall
jr $ra

