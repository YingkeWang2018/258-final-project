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
lw $s1, platform1	#platform positionload 
addi $sp, $sp, -4
sw $s1, 0($sp)		#save position argument
jal DRAWPLA
# Draw Platform 2
lw $s2, platform2
addi $sp, $sp, -4
sw $s2, 0($sp)		#save position argument
jal DRAWPLA
#Draw Platform 3
lw $s3, platform3
addi $sp, $sp, -4
sw $s3, 0($sp)		#save position argument
jal DRAWPLA
# Draw Doodle
lw $s4, Doodle
addi $sp, $sp, -4
sw $s4, 0($sp)		#save position argument
jal DRAWDOO
addi $s5, $zero, 0 #s5 for game end
MainLoop:
beq $s5, $zero, REDRAW
Exit:
li $v0, 10 # terminate the program gracefully
syscall
	

REDRAW:
jal DRAWSCREEN
addi $s1, $s1, 128	#platform positionload 
addi $sp, $sp, -4
sw $s1, 0($sp)		#save position argument
jal DRAWPLA
# Draw Platform 2
addi $s2, $s2, 128
addi $sp, $sp, -4
sw $s2, 0($sp)		#save position argument
jal DRAWPLA
#Draw Platform 3
addi $s3, $s3, 128
addi $sp, $sp, -4
sw $s3, 0($sp)		#save position argument
jal DRAWPLA
# Draw Doodle
addi $s4, $s4, 128
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
addi $sp, $sp, 4 #pop the position of the platform
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

SLEEP:
li $v0, 32
li $a0, 1000
syscall
jr $ra

