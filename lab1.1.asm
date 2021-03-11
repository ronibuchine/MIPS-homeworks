.data 
myArray: .word 3, 4, 5, 6, 7, 8, 9, 0
myArray2: .space 100
.text
la $a0, myArray
la $a1, myArray2
loop:
lw $t0, 0($a0) # takes the first element that the address $a0 is pointing to and puts it in $t0
sw $t0, 0($a1) #stores $t0 into a1
addi $a0, $a0, 4 #iterates throught the array
addi $a1, $a1, 4 #iterates through the array
addi $v0, $v0, 1
beq $t0, $zero, end
j loop
end: