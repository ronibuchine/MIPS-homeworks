.data
inputNumber: .asciiz "input a number\n"
inputOperator: .asciiz "input an operator\n"
result: .asciiz "the answer is: "
.text
li $t7 '+'
li $t8 '*'
li $t9 '^'

la $a0 inputNumber
li $v0 4
syscall
li $v0 5 # reads in an integer
syscall
add $s0 $zero $v0
la $a0 inputOperator
li $v0 4
syscall
li $v0 12
syscall
add $t2 $v0 $zero
li $a0 '\n'
li $v0 11
syscall
la $a0 inputNumber
li $v0 4
syscall
li $v0 5 # reads in an integer
syscall
add $s1 $zero $v0

beq $t2 $t7 addition
beq $t2 $t8 multi
beq $t2 $t9 exponent

addition:
add $a0 $s0 $zero
add $a1 $s1 $zero
jal afunction
j printResult
afunction:
add $v0 $a0 $a1
jr $ra
multi:
add $a0 $s0 $zero
add $a1 $s1 $zero
jal mfunction
j printResult
mfunction: # because we aren't using mult we do not need to care about the hi and lo registers
beqz $a0 zeroMult #if one of the parameters are 0 we jump to the end and return 0
beqz $a1 zeroMult
addi $sp $sp -24
sw $ra 20($sp)
sw $t0 16($sp) 
sw $t1 12($sp)
sw $t2 8($sp)
sw $t8 4($sp)
sw $t9 0($sp)
add $t8 $a0 $zero #store parammeters so we can reuse them in nested calls
add $t9 $a1 $zero
slt $t2 $a1 $zero
beqz $t2 doneSwap
### if the second argument is negative we swap values
add $t2 $a1 $zero
add $a1 $a0 $zero
add $a0 $t2 $zero
doneSwap:
li $t2 0
slt $t2 $a1 $zero # we check if the second value is negative
beqz $t2 start
add $t1 $a1 $zero
add $a1 $zero $a0

loop2:
sub $t0 $zero $v0
jal afunction
add $a0 $v0 $zero #update our parameter for the next addition
addi $t1 $t1 1 #increment the counter
bnez $t1 loop2 # we jump back to the loop to add 
j giveResult

start:
add $t1 $a1 $zero # store the amount of times we're adding 
add $a1 $zero $a0
li $v0 0

loop:
add $t0 $v0 $zero
jal afunction
add $a0 $v0 $zero #update our parameter for the next addition
addi $t1 $t1 -1 #decrement the counter
bnez $t1 loop # we jump back to the loop to add again
giveResult:
add $a0 $t8 $zero #restore parameters
add $a1 $t9 $zero
add $v0 $t0 $zero
lw $t9 0($sp)
lw $t8 4($sp)
lw $t2 8($sp)
lw $t1 12($sp)
lw $t0 16($sp)
lw $ra 20($sp)
addi $sp $sp 24
j endMult
zeroMult:
li $v0 0
endMult:
jr $ra
exponent:
add $a0 $s0 $zero
add $a1 $s1 $zero
jal efunction
j printResult


efunction:

addi $sp $sp -12
sw $ra 8($sp)
sw $t0 4($sp)
sw $t1 0($sp)
li $t0 1
beq $a1 $zero zeroExp #0 exponent
beq $a1 $t0 oneExp # 1 exponent
li $v0 0
add $t0 $a1 $zero # t0 will be a counter for how many times we multiply
add $a1 $zero $a0 # we store the value of a0 in a1 so it can be multiplied by itself

eloop:
add $t1 $v0 $zero # t1 will store the end result
jal mfunction
addi $t0 $t0 -1 #decrement counter
add $a0 $v0 $zero
beqz $t0 expEnd
j eloop

zeroExp:
li $v0 1
j jspace
oneExp:
add $v0 $a0 $zero
j jspace
expEnd:
add $v0 $t1 $zero
jspace:
lw $t1 0($sp)
lw $t0 4($sp)
lw $ra 8($sp)
addi $sp $sp 12
jr $ra
printResult:
# first store the return value from the function in t0
add $t0 $zero $v0
la $a0 result
li $v0 4
syscall
add $a0 $t0 $zero #put the result in here
li $v0 1 
syscall













