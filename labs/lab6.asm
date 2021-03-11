.data
inputRowNumber1: .asciiz "Please enter the number of rows in the first matrix: \n"
inputColNumber1: .asciiz "Please enter the number of columns in the first matrix: \n"
inputRowNumber2: .asciiz "Please enter the number of rows in the second matrix: \n"
inputColNumber2: .asciiz "Please enter the number of columns in the second matrix: \n"
error: .asciiz "ERROR: INVALID MATRIX DIMENSIONS\n"
inputVal: .asciiz "Please input the values of the two matrices: \n"
result: .asciiz "The result is:"
A: .space 512
B: .space 512
.text
############### I/O from user
IO:
la $a0 inputRowNumber1
li $v0 4
syscall
li $v0 5
syscall
add $a1 $v0 $0
la $a0 inputColNumber1
li $v0 4
syscall
li $v0 5
syscall
add $a2 $v0 $0
# a1 and a2 contain row and column dimensions for matrix A
la $a0 inputRowNumber2
li $v0 4
syscall
li $v0 5
syscall
add $k0 $v0 $0
la $a0 inputColNumber2
li $v0 4
syscall
li $v0 5
syscall
add $k1 $v0 $0
bne $a2 $k0 printError
# k0 and k1 contain dimensions for matrix B
la $a0 inputVal
li $v0 4
syscall
mult $a1 $a2
mflo $t0
la $t8 A
li $t1 0
inputLoop:
	beq $t0 $t1 endLoop
	li $v0 5
	syscall
	sw $v0 0($t8)
	addi $t8 $t8 4 #increment pointer
	addi $t1 $t1 1
	j inputLoop
endLoop:
mult $k0 $k1
mflo $t0
la $t9 B
li $t1 0
inputLoop2:
	beq $t1 $t0 endLoop2
	li $v0 5
	syscall
	sw $v0 0($t9)
	addi $t9 $t9 4 #increment pointer
	addi $t1 $t1 1
	j inputLoop2
endLoop2:
############### now multiply the matrices
# DO NOT OVERWRITE THE $a REGISTERS OR THE $k REGISTERS
la $t0 A # any citems that have to do with matrix A will be put in $t registers
la $s0 B # any items having to do with he B register will be stored in the $s registers
li $t6 0 # counter to tell us which row we're on
li $t7 0 # row counter
li $t8 0 # counter for product matrix C
li $t9 0 # sum counter
li $s3 1 # counter to tell us which column we're multiplying on
li $t3 1 # counter for which row we're muliplying on
add $s6 $k1 $0 
sll $s6 $s6 2 # s6 contains the number of columns*4 to account for word space
add $t5 $a2 $0
sll $t5 $t5 2 # t5 contains the same thing as s6 but for columns in A (columns*4 for word space)
addi $s4 $k0 -1 # number of rows-1 in B 
sll $s4 $s4 2 # multiplied by 4 for wordspace
mult $s4 $k1 #multiplied by number of columns
mflo $s4
###########
# at this stage all of the dimensions an inputs have been entered and we must multiply the matrices
# in order to do this we must have a pointer to the first row of A and we will interate along the row according to the amount of columns in B
# once this is done we move the pointer to the next row in A and repeat until we have done the last row in A
multiplyRow: #for (int i = 0, i < numColumns; i+= numColumns) this step assumes t0 and s0 are pointed in the correct places
	lw $s1 0($t0) #s1 and s2 are parameters to be multiplied
	lw $s2 0($s0) 
	mult $s1 $s2
	mflo $s7
	add $t9 $s7 $t9 #add the value retrieved from the multiplication into t9 whih stores the sum
	addi $t7 $t7 1 #increment row counter
	beq $t7 $a2 endMult
	addi $t0 $t0 4 # increment pointer for matrix A to next item in the row
	add $s0 $s0 $s6 # increment column counter by s6
	j multiplyRow
endMult: 
# when we finish multiplying a row by a column we check to make sure its not the last column 
# if it is the last column we check to see if it was the last row, if it was then we're done
#if it wasnt the last row we move to the next row and repeat the process
#if it wasn't the last column then we increment to the next column and repeat with the same row
	add $a0 $t9 $0
	li $v0 1
	syscall
	li $a0 ' '
	li $v0 11
	syscall # these two print statements print the sum value we got by multiplying the row and a comma to seperate it from the next value
	li $t9 0 #reset the sum register to 0
	li $t7 0 # reset row counter to 0
	bne $s3 $k1 nextCol #check columns
	bne $t3 $a1 nextRow #check rows
	j end
	
	
nextCol: # have the pointer go back
	sub $s0 $s0 $s4
	addi $s0 $s0 4 # increment to the next column by adding 4 (wordspace)
	sub $t0 $t0 $t5 # we subtract the number of columns*4 so we can get back to the beginning of the row
	addi $t0 $t0 4
	addi $s3 $s3 1 #increment col counter
	j multiplyRow
nextRow:
	li $a0 '\n'
	li $v0 11
	syscall # prints a new line
	addi $t0 $t0 4 # because we're already at the end of the row we just add 4 to get to the first element in the next row
	la $s0 B # we reload to the beginnning of the column matrix to start multiplying again
	addi $t3 $t3 1
	li $s3 1 # reset column counter
	j multiplyRow

printError:
la $a0 error
li $v0 4
syscall
j IO
end: