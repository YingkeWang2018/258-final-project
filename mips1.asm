.text
main:
addi $s0, $zero, 22
addi $s1, $zero, 33
slt $s2, $s0, $s1
slt $s3, $s0, $s1
and $s4, $s3, 0x1001


li $v0, 10 # terminate the program gracefully
syscall
