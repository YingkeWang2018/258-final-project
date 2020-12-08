# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
displayAddress: .word 0x10008000
.text
lw $t0, displayAddress # $t0 stores the base address for display
li $t1, 0xff0000 # $t1 stores the red colour code
li $t2, 0x00ff00 # $t2 stores the green colour code
li $t3, 0xffffff # $t3 stores the white colour code
li $t4, 4096 # $t4 store the white colour code


LOOP:
j PAINTBOARD
lw $t0, displayAddress 
addi $t0, $t0, 100
j PAINTOBS
addi $t0, $t0, 400
j PAINTOBS
addi $t0, $t0, 300
j PAINTOBS
j LOOP


PAINTBOARD: blez $t4, RESETT0
sw $t3,($t0)
addi $t0, $t0, 4
addu $t4, $t4, -4
j PAINTBOARD

RESETT0:
lw $t0, displayAddress
j PAINTD

PAINTD:
li $t5, 3100
add $t0, $t0, $t5
sw $t2,($t0)
addi $t0, $t0, 124
sw $t2,($t0)
addi $t0, $t0, 4
sw $t2,($t0)
addi $t0, $t0, 4
sw $t2,($t0)
addi $t0, $t0, 128
sw $t2,($t0)
addi $t0, $t0, -8
sw $t2,($t0)
lw $t0, displayAddress


PAINTOBS:
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)
addi $t0, $t0, 1
sw $t1,($t0)





END:

Exit:
li $v0, 10 # terminate the program gracefully
syscall