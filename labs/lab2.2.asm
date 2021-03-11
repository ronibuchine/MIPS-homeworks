.data
prompt1: .asciiz "ENTER VALUE\n"
prompt2: .asciiz "\nENTER OP-CODE ('+', '-', '*', '@')\n"
result: .asciiz "The result is: "
#error message section
overflow1: .asciiz "\nERROR: POSITIVE OVERFLOW\n"
overflow2: .asciiz "\nERROR: NEGATIVE OVERFLOW\n"
# syscall codes, to print string from $a0 use code 4, to read integer, syscall 5, to read integer read into $v0), 
#syscall 12 read in a character
.text
li $s0, '+'
li $s1, '-'
li $s2, '*'
li $s3, '@'
la $a0, prompt1
li, $v0, 4
syscall
li , $v0, 5
syscall
add $t9, $v0, $zero
loop:
la $a0, prompt2
li $v0, 4
syscall
li $v0, 12
syscall
beq $v0, $s0, addition
beq $v0, $s1, subtract
beq $v0, $s2, multiply
beq $v0, $s3, end
addition:
la $a0, prompt1
li, $v0, 4
syscall
li , $v0, 5
syscall
add $t9, $t9, $v0
j loop
subtract:
la $a0, prompt1
li, $v0, 4
syscall
li , $v0, 5
syscall
sub $t9, $t9, $v0
j loop
multiply:
# possible cases, no overflow into hi (either contans all 1s or all 0s) first check if equal to 0
# negative overflow into hi -- check if less than negative 1
# positive overflow into hi -- if hi isnt 0 or less than negative 1 its a positive overflow
la $a0, prompt1
li, $v0, 4
syscall
li , $v0, 5
syscall
mult $t9, $v0
mflo $t0
mfhi $t1
beq $t1, $zero, regular # value only in lo and positive
li $t5, -1
beq $t1, $t5, regular # value only in lo and negative
slt $t2, $t1, $t5
beqz $t2, positive # positive overflow
bnez $t2, negative #negative overflow
positive:
la $a0, overflow1
li $v0, 4
syscall
j end2
negative:
la $a0, overflow2
li $v0, 4
syscall
j end2
regular:
add $t9, $t0, $zero
j loop
end:
la $a0, result
li $v0, 4
syscall
add $a0, $t9, $zero
li $v0, 1
syscall
end2:
# display message "the result is: result"






