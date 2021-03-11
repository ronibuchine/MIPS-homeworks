.data
myArray: .word 1, -1, 5, 6, -9, 345, -246, 60, 22
.text
la $a0, myArray
li $a1, 9
addi $a2, $a1, -1 #a2 will contain the n-1 value


forloop:
beq $a2, $t8 end # t8 is the outerloop counter
bne $a2, $t9 swapif # t9 is the innerloop counter
# at the end of each inner loop we increase the outer counter, reset inner counter and bring pointer back to beginning
addi $t8, $t8, 1 # increase outer counter
addi $t9, $zero, 0
addi $a0, $a0, -32 # puts the pointer back at the begining
j forloop

swapif: # swaps the current value and the next value
lw $s0, 0($a0)
lw $s1, 4($a0)
slt $v0, $s1, $s0
beqz $v0, increment
sw $s0, 4($a0)
sw $s1, 0($a0)
li $v0, 0
increment:
addi $t9, $t9, 1 # increment inner counter
addi $a0, $a0, 4 #increments the pointer
j forloop
end: