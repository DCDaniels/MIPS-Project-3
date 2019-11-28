#HU ID: @02884990
#02884990%11 = 9
#26 + 9 = Base 35
#Range (0,y) and (0-Y)

.data 						#Declarations
InputVariable: .space 3000			#Variable for user input 
list: .word 0, 0, 0, 0				#Created a word list
BadInput: .asciiz "NaN"		#Variable used to output Invalid input

.text						#Instructions stored in text segment at next available address
.globl main					#Allows main to be refrenced anywhere

main:
	li $v0, 8				#Allows user to input
	la $a0, InputVariable			#Saves input to  variable
	li $a1, 1002				#Allows the input to be 1000 characters
	syscall 				#Issues a System Call
	
	la $t1,InputVariable			#Load the variable to the register $t1
	li $t2,4				#Stored to check if variable is greater than 4
	li $t3,32				#Stored a space in $t3 to check for spaces
	li $t4,9				#Stored to check for tabs
	li $t0,0				#Variable initialized to 0
	li $s0,48				#For lowest valid non letter input option
	li $s1,57				#For highest valid non letter input option
	li $s2,65				#For lowest capital letter
	li $s3,89				#For highest capital letter (I go to Y not Z)
	li $s4,97				#For lowest common letter
	li $s5,121				#For highest common letter (I go to y not z)
	li $a3,0				#Initialized for sum
	li $s7, 0x0A				#Stored a new line
	


	output_bad_input:			#Fucntion to print invalid output
	li $v0,4
	la $a0, BadInput			#Prints Invalid input
	syscall					#Issues a System Call
	
	
	beginning_characters:			#Function that checks if character is a space or tab
	beq $t6,$t3, skip_character		#Branches if character is a space
	beq $t6,$t4, skip_character		#Branches if character is a tab
	j check_character			#Jump to check_character
	
	skip_character:				#Function that moves to next character
	addi $t1,$t1, 1				#Increments $t1 to check next number
	j loop					#Jumps back to beginning of loop
	