# Christen Reinbeck
# lab 3

.data
	ask_user:		.asciiz "Please give an integer to find nth Fibonacci number: "
	new_line:		.asciiz "\n"

.text
	li $v0, 4		# print ask user
	la $a0, ask_user
	syscall 		
	li $v0,5		# read in an int
	syscall 
	add $a0,$v0,$zero 	# puts int in $a0 - for recursive solution
	add $t9, $v0, $zero	# puts int - to use in iterative solution as n
	add $t8, $v0, $zero	# puts int - to use in iterative solution as counter
# recursive solution
	jal fib_r
	add $a0,$v0,$zero	# puts solution in $a0 from $v0 to print
	li $v0,1		# prints recursive answer
	syscall
	
	li $v0, 4		# puts in newline to separate recursive from iterative
	la $a0, new_line
	syscall

# iterative solution
	li $t1, 0		# begin t1 at 0
	li $t2, 1		# begin t2 at 1
	addi $t8, $t8, -1	# take the counter down by one initially to get the right number of loops
	
fib_i:
# base cases
	li $t0, 1
	beq $t9, $zero, it_0
	beq $t9, $t1, it_1
	beq $t8, $zero, exit_i	# checks counter and kicks it out when it equals 0
	add $t3, $t1, $t2	# adds two previous	
	add $t1, $zero, $t2	# makes t1, t2
	add $t2, $zero, $t3	# makes t2, the result of fib
	addi $t8, $t8, -1	# decrements counter
	j fib_i
	
# EXITS fail safe
	li $v0,10		
	syscall

fib_r:		# if input = 0, return 0 // if input = 1, return 1 // else return [fib(n-1) + fib(n-2)]
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	add $s0,$a0,$zero
# base cases - checking for 0, 1
	li $t1, 1		# load 1 into t1 to compare to int
	beq $s0,$zero,return_0	# returns zero if equal to zero
	beq $s0,$t1,return_1	# returns one if equal to one
# fib(n-1)
	addi $a0,$s0,-1
	jal fib_r		# returns in v0
	add $s1,$zero,$v0  	# store answer of fib(n-1) in $s1   
# fib(n-2)
	addi $a0,$s0,-2
	jal fib_r           	# returns in v0
	add $v0,$v0,$s1		# store answer of fib(n-1) + fib(n-2)

exit:
	lw $ra,0($sp)       #read registers from stack
	lw $s0,4($sp)
	lw $s1,8($sp)
	addi $sp,$sp,12       #bring back stack pointer
	jr $ra

return_1:
	li $v0,1
	j exit

return_0 :     
	li $v0,0
 	j exit
 
# iterative base cases
it_0:
	li $a0, 0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
it_1:
	li $a0, 1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
	
 # exits iterative solution
 exit_i:
 	move $a0, $t3
 	li $v0, 1		# prints iterative solution
 	syscall
 	li $v0, 10		# exits
 	syscall
