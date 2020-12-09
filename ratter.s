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
# - Milestone 1 
#
# Which approved additional features have been implemented?
#None
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
.data
displayAddress: .word 0x10008000
redcolor: .word 0xff0000
greencolor: .word 0x00ff00
whitecolor: .word 0xffffff
.text
lw $t0, displayAddress # $t0 stores the base address for display

MAIN:


jal PAINTBOARD
lw $t0, displayAddress 


addi $a1, $zero, 5	#x-axis positionload 
addi $a2, $zero, 10	#y-axis positionload 
jal PAINTOBS

addi $a1, $zero, 8	#x-axis positionload 
addi $a2, $zero, 20	#y-axis positionload 

jal PAINTOBS

addi $a1, $zero, 12	#x-axis positionload 
addi $a2, $zero, 31	#y-axis positionload 
jal PAINTOBS


addi $s4, $zero, 16	#x-axis positionload 
addi $s3, $zero, 28	#y-axis positionload 
addi $s5, $zero, 8
jal PAINTD

jal SLEEP

LOOP:
jal PAINTBOARD

addi $a1, $zero, 5	#x-axis positionload 
addi $a2, $zero, 10	#y-axis positionload 
jal PAINTOBS

addi $a1, $zero, 8	#x-axis positionload 
addi $a2, $zero, 20	#y-axis positionload 
jal PAINTOBS

addi $a1, $zero, 12	#x-axis positionload 
addi $a2, $zero, 31	#y-axis positionload 
jal PAINTOBS


jal PAINTD

jal SLEEP

j LOOP

li $v0, 10 # terminate the program gracefully
syscall



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



lw $t3, greencolor #load green color

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
lw $t0, displayAddress

move $t2, $s3 #load power

blez $t2, LowPower     #if power <=0 then go down

addi $t2, $t2, -1 #if power >0, power - 1
addi $t6, $t6, -1 #y-axis go down, DOO go up

#j StartPaintDLoop
SaveNewDooPos:
addi $s3, $t6, 0 #save y
addi $s4, $t7, 0 #save x
addi $s5, $t2, 0 #save power

jr $ra


LowPower:

#bgtz $t8, GoUp

addi $t5, $t6, -29
bgtz $t5, GAMEOVER  #if Doo is at the bottom line, game over

addi $t8, $t0, 128 #left foot of doo

lw $t8, ($t8)

lw $t4, whitecolor

beq $t8, $t4, NotHitObsL

addi $t8, $zero, 1

j Skip1

NotHitObsL:
addi $t8, $zero, 0

Skip1:

addi $t9, $t0, 130 #right foot of Doo
lw $t9, ($t9)
beq $t9, $t4, NotHitObsR

addi $t9, $zero, 1 

j Skip2

NotHitObsR:
addi $t9, $zero, 0

Skip2:

add $t8, $t8, $t9

bgtz $8, GoUp

addi $t6, $t6, 1 #else, go down

j SaveNewDooPos

GoUp:
addi $t2, $zero, 8 #power set to 8
addi $t6, $t6, -1  #y-axis go up

j SaveNewDooPos






PAINTOBS: #Paint obstacles
lw $t0, displayAddress # $t0 stores the base address for display

addi, $t6, $a2, 0
addi, $t7, $a1, 0 #inport x and y

lw $t3, redcolor #load red color

mul $t5, $t6, 128
mul $t7, $t7, 4
add $t5, $t5, $t7

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










SLEEP: 
li $v0, 32
li $a0, 1000
syscall
jr $ra

GAMEOVER:
li $v0, 10 # terminate the program gracefully
syscall
