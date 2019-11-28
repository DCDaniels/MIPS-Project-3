#David Daniels
#HU ID: @02884990
#02884990%11 = 9
#26 + 9 = Base 35
#Range (0,y) and (0-Y)

.data 						#Declarations
InputVariable: .space 3000			#Variable for user input 
SubString: .word 0, 0, 0, 0			#Created a word list
BadInput: .asciiz "NaN"				#Variable used to output Invalid input

.text						#Instructions stored in text segment at next available address
.globl main					#Allows main to be refrenced anywhere

main:
	
	li $v0, 8				#Allows user to input
	la $a0, InputVariable			#Saves input to  variable
	li $a1, 1002				#Allows the input to be 1000 characters
	la $s0, SubString 			#Load the address of the list
	syscall 				#Issues a System Call
	
	
	
	loop:
		bgt $t5,$t2, output_bad_input		#Branch if more than 4 good characters
		lb $t6,0($t1)				#Gets each integer from the input
		j check_character			#Jump to check character function if it doesnt branch
	
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
	
	check_character:			#Function to see if character is invalid
	blt $t6,$s0, output_bad_input		#Branch if character is below ASCII number for 0
	bgt $t6,$s1, check_capital		#Branch if character is above ASCII number for 9
	addi $t6,$t6, -48			#Convert it to its decimal counterpart
	j incrementor				#Jump to incrementor function
	
	incrementor:				#Function to increment all variables
	sb $t6, 0($s6)		 		#Stores the character in a string
	addi $s6,$s6, 1 			#Increment array posistion
	addi $t1,$t1, 1 			#Increment the input string
	addi $t5,$t5, 1 			#Increment the number of valid characters
	j loop					#Go back to loop