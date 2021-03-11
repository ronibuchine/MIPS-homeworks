.data
found: .asciiz "\nsequence found!"
notfound: .asciiz "\nsequence not found"
message: .asciiz "Please enter the size of your sequence followed by the sequence: \n"
sequence: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 4, 5, 6, 4, 5, 3, 5, 5, 6, 7, 8, 9, 0, 0, 3
code: .space 500
.text
################# print message
li $v0 4
la $a0 message
syscall
###############
li $a1 32
la $a0 sequence
la $a2 code
###############
li $v0 5
syscall
add $a3 $v0 $0
####### read integer for size and store the size in a3
li $t0 0
inputSequence:
	beq $t0 $a3 detectSequence
	li $v0 5 ## read integer for sequence
	syscall
	sb $v0 0($a2)
	addi $a2 $a2 1 ## increment pointer
	addi $t0 $t0 1 ## increment counter
	j inputSequence
	
##############################
# we now have the code ready and we check in a nested loop if the sequence matches any point in the original sequence
# for (int i = 0; i < size; i++)
#	if (code[0] == sequence[i])
#		for (int j = i; j < codesize; j++)
#			if ( code[j] != sequence[j])
#				break;
#			if (j == codesize-1) return found
#	if (i == size-1) return notfound
detectSequence:
la $a2 code
li $t0 1 # set i counter back to 0
outerLoop:
	beq $t0 $a1 printNotFound
	lb $s0 0($a0)
	lb $s1 0($a2)
	bne $s0 $s1 outerContinue #if the first two values arent equal we dont go into the inner loop
	li $t1 1 # reset j counter to 0
	addi $a0 $a0 1 #increment pointers
	addi $a2 $a2 1
	li $t3 1 #store a counter so we know where to go back to in the outerloop for the a0 address
	innerLoop:
		beq $t1 $a3 printFound #if we made it all the way through the code without breaking back to the outer loop then we go to print found
		lb $s0 0($a0)
		lb $s1 0($a2)
		bne $s0 $s1 out #if the values are not equal at any point break from the inner loop
		addi $a0 $a0 1
		addi $a2 $a2 1
		addi $t1 $t1 1
		addi $t3 $t3 1
		j innerLoop
		
		out:
		sub $a0 $a0 $t3 #subtract the pointer so it goes back to where it was				
		la $a2 code #reset the code pointer
		j outerContinue	
	
outerContinue:	
	addi $a0 $a0 1 #increment pointer
	addi $t0 $t0 1	# increment counter
	j outerLoop

printFound:
li $t1 0
la $a2 code
printLoop:
	beq $t1 $a3 printStatement1
	lb $a0 0($a2)
	li $v0 1
	syscall
	addi $a2 $a2 1
	addi $t1 $t1 1
	j printLoop
printStatement1:
la $a0 found
li $v0 4
syscall
j end
printNotFound:
li $t1 0
la $a2 code
printLoop2:
	beq $t1 $a3 printStatement2
	lb $a0 0($a2)
	li $v0 1
	syscall
	addi $a2 $a2 1
	addi $t1 $t1 1
	j printLoop2
printStatement2:
la $a0 notfound
li $v0 4
syscall
end:









