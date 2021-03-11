.data
array: .byte 4, -9, 100, 5, -6, 7, 120, 2
.text
la $a1, array
li $a2, 8 # the size of our array
li $a3, 0 # we will compare a2 and a1 in the loop so we know when we get to the end of the array
lb $t0, 0($a1) # loads the first value into t0 which in the end will contain the highest value
loop:
addi $a3, $a3, 1 # incrementing the counter
addi $a1, $a1, 1 # continuously adds to the address to iterate through the array
beq $a2, $a3, end #if we've reached the end of the array we get out of the loop

lb $t1, 0($a1)  # loads the next number into t1
slt $s0, $t0, $t1 # if s0 gets set to 1 then the highest valuee isn't in t0 and we need to swap

beqz $s0, loop # if we didn't go to the beginning of the loop then we need to put the value thats in t1 into t0
lb $t0, 0($a1) #loads the compared value into t0 and we go back to the top of the loop
j loop
end:
add $a0, $t0, $zero
li $v0, 1
syscall # prints the highest value