.text
main:
addi $t1 $zero, 0
lw $t8, 0xffff0000
lw $t2, 0xffff0004
j main
li $v0, 10 # terminate the program gracefully
syscall