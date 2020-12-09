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
Doodle: .word 0x10008BAC
red: .word 0xff0000
blue: .word 0x33D5FF
green: .word 0x00ff00
white: .word 0xffffff
lastUnit: .word 0x10008ffc

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
jal DRAWPLA
lw $s3, 0($sp)
addi $sp, $sp, 4
# Draw Doodle
lw $s4, Doodle		#s4: doodle
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOO
addi $s7, $zero, 0 #s7 for game end
addi $s5, $zero, 20 #s5: vertical move
addi $s6, $zero, 0 #s6: base offset
addi $t0, $zero, 0 #score
addi $sp, $sp, -4
sw $t0, 0($sp)
MainLoop:
beq $s7, $zero, SingleIteration
Exit:
li $v0, 10 # terminate the program gracefully
syscall

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
lw $t0, 0($sp) #load score
addi $sp, $sp, 4
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
addi $sp, $sp, -4
sw $t0, 0($sp)	#save the score back
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
addi $sp, $sp, -4
sw $t0, 0($sp)	#save the score back
#check platform 3
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
addi $sp, $sp, -4
sw $t0, 0($sp)	#save the score back

bne $s5, 0, exit_check_doodle_collison
addi $s5, $s5, 20
exit_check_doodle_collison:
j exit_change_doodle_pos




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
lw $t3 baseline		#load the baseline
addi $t0, $t0, 4
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
jal DRAWSCORE
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
jal DRAWPLA
lw $s3, 0($sp)
addi $sp, $sp, 4
# Draw Doodle
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOO
jal SLEEP
j MainLoop

DRAWSCORE:
lw $t0, 0($sp)
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




DRAWDOO:
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

DETACT_INPUT:
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input

detact_exit:
jr $ra

keyboard_input:
lw $t2, 0xffff0004
beq $t2, 0x6A, respond_to_j
beq $t2, 0x6B, respond_to_k
return_keyboard_back:
j detact_exit

respond_to_j:
addi $s4, $s4, -4
j return_keyboard_back

respond_to_k:
addi $s4, $s4, 4
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



SLEEP:
li $v0, 32
li $a0, 50
syscall
jr $ra

