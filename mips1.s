.data
displayAddress: .word 0x10008000
blue: .word 0x33D5FF
.text
main:
lw $t0, displayAddress
addi $t1, $zero, 10 #amount to draw
addi $sp, $sp, -4
sw $t0, 0($sp)
lw $t2, blue
addi $sp, $sp, -4
sw $t2, 0($sp)
addi $sp, $sp, -4
sw $t1, 0($sp)
jal drawVertical




j exit


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








drawVertical:
lw $t0, 0($sp) #t0: number to draw
addi $sp, $sp, 4
lw $t1, 0($sp) #t1: color
addi $sp, $sp, 4
lw $t2, 0($sp) #t2: start position
addi $sp, $sp, 4
addi $t3, $zero, 0 #t3: accumulator
doVerticalLoop:
bne $t3, $t0, drawVerticalLoop
jr $ra

drawVerticalLoop:
sw $t1, 0($t2)
addi $t2, $t2, 128
addi $t3, $t3, 1
j doVerticalLoop

drawHorizontal:
lw $t0, 0($sp) #t0: number to draw
addi $sp, $sp, 4
lw $t1, 0($sp) #t1: color
addi $sp, $sp, 4
lw $t2, 0($sp) #t2: start position
addi $sp, $sp, 4
addi $t3, $zero, 0 #t3: accumulator
doHoritonalLoop:
bne $t3, $t0, drawHoritonalLoop
jr $ra
drawHoritonalLoop:
sw $t1, 0($t2)
addi $t2, $t2, 4
addi $t3, $t3, 1
j doHoritonalLoop




exit:
li $v0, 10 # terminate the program gracefully
syscall
