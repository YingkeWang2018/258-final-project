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
platform1: .word 0x10008088
platform2: .word 0x10008880
platform3: .word 0x10008450
Doodle: .word 0x10008CD0
red: .word 0xff0000
green: .word 0x00ff00
white: .word 0xffffff
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
addi $s5, $zero, 10 #s5: vertical move
addi $s6, $zero, 0 #s6: horizontal move
MainLoop:
beq $s7, $zero, SingleIteration
Exit:
li $v0, 10 # terminate the program gracefully
syscall

SingleIteration:
#jal DETACT_INPUT
jal Change_doodle_pos
j REDRAW

Change_doodle_pos:
beq $s5 $zero exit_change_doodle_pos
bgtz $s5 doodle_jump_up
blez $s5 doodle_jump_down
check_horitontal:
bgtz $s6 doodle_jump_right
blez $s6 doodle_jump_left

exit_change_doodle_pos:
jr $ra

doodle_jump_left:
addi $s4, $s4, -4
addi $s6, $s6, 1
j exit_change_doodle_pos

doodle_jump_right:
addi $s4, $s4, -4
addi $s6, $s6, -1
j exit_change_doodle_pos


doodle_jump_down:
addi $s4, $s4, 128
j check_horitontal


doodle_jump_up:
addi $s4, $s4, -128
addi $s5, $s5, -1
beq $s5, $zero change_vertical_direct
exit_doodle_jump_up:
j check_horitontal

change_vertical_direct:
addi $s5, $s5, -1
j exit_doodle_jump_up


REDRAW:
#Draw the screen
jal DRAWSCREEN
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
addi $t2 $zero, 5 #final counter
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
bne $s5, $zero, exit_respond_to_j
addi $s5, $s5, 10
addi $s6, $zero, -7
exit_respond_to_j:
j return_keyboard_back

respond_to_k:
bne $s5, 0, exit_respond_to_k
addi $s5, $s5, 10
addi $s6, $zero, 7
exit_respond_to_k:
j return_keyboard_back


SLEEP:
li $v0, 32
li $a0, 500
syscall
jr $ra

