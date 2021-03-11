.data
message: .asciiz "\nPlease enter a number of size 32 bits: \n"
x: .space 32
error: .asciiz "ERROR!\n" 
.text
######## display message and read in number
begin:
la $a0 message
li $v0 4
syscall
li $v0 5
syscall
######## load immediate hex values into temp regiisters
beq $v0 $0 case0 # stop program if a 0 is entered
li $t1 0x31
li $t2 0x30
li $t3 0x48
li $t4 0x74
#########
srl $t0 $v0 24
beq $t0 $t1 case1
beq $t0 $t2 case2
beq $t0 $t3 case3
beq $t0 $t4 case4
j errorMessage



case1:
li $s1 195
or $a0 $v0 $s1
li $v0 34
syscall 
j begin
############
case2:
li $s1 0xffffff3c
and $a0 $v0 $s1
li $v0 34
syscall
j begin
############
case3:
li $s1 0x0000ff00
xor $a0 $v0 $s1
li $v0 34
syscall
j begin
############
case4:
sll $s1 $v0 7
srl $s1 $s1 27 #s1 now contains the value that we will be shifting left 

loop:
	beq $t9 $s1 endLoop
	sll $v0 $v0 1
	addi $t9 $t9 1
	j loop
endLoop:
add $a0 $v0 $0
li $v0 34
syscall
j begin
############














####### print error message
errorMessage:
la $a0 error
li $v0 4
syscall
j begin

case0: 
# case 0 terminates the program





