.data
msg: .asciiz "Please enter a number less than 100 and more than -100\n"
msg2: .asciiz "\nThe Sum is "
.text
la $a0, msg
loop:
li $v0, 4
syscall
li $v0, 5
syscall
slti $t1 $v0 -99 #if the input number is less than -100 it puts a 1 in $t1
slti $t2 $v0 99 #if th einput number is less than 100 it puts a 1 in $t2
beqz $t2, loop
bnez $t1, loop
beqz $v0, end
add $t0, $t0, $v0 # $t0 keeps track of the sum of the input numbers
j loop
end:
la $a0, msg2
li $v0, 4
syscall
add $a0, $zero, $t0
li $v0, 1
syscall




