.data
mySequence: .byte 2, 4, 8, 16, 32, 65
Arithmetic: .asciiz "d = "
Geometric: .asciiz "q = "
None: .asciiz "Not a Progression"
.text
la $a0, mySequence
li $a1, 6 # size of sequence

lb $t0, 0($a0)
lb $t1, 1($a0)
sub $t2, $t1, $t0  # t2 will contain the constant difference
addi $a0, $a0, 1
li $s0, 2
arithmetic:
beq $s0, $a1, endArithmetic #if we got through the whole loop without any change in the constant difference then we print it out
lb $t0, 0($a0)
lb $t1, 1($a0)
sub $t3, $t1, $t0
bne $t2, $t3, geometric # if we dont get a constant difference we go to check geometric
addi $a0, $a0, 1
addi $s0, $s0, 1
j arithmetic
endArithmetic:
la $a0, Arithmetic
li $v0, 4
syscall
add $a0, $zero, $t2
li $v0, 1
syscall
j end
geometric:
la $a0, mySequence
li $s0, 2
lb $t0, 0($a0)
lb $t1, 1($a0)
div $t1, $t0
mflo $t2 #t2 will contain the constant ratio
mfhi $t9 #t9 will ccontin the remainder
bnez $t9 nosequence #we don't need to check for a constant ration that is a floating point number so if the remainder is ever not 0 we branch to the end
gloop:
beq $s0, $a1, endGeometric
addi $a0, $a0, 1
lb $t0, 0($a0)
lb $t1, 1($a0)
div $t1, $t0
mflo $t3
mfhi $t9
bnez $t9, nosequence
bne $t3, $t2, nosequence
addi $s0, $s0, 1
j gloop
endGeometric:
la $a0, Geometric
li $v0, 4
syscall
add $a0, $zero, $t2
li $v0, 1
syscall
j end
nosequence:
la $a0, None
li $v0, 4
syscall
end:


