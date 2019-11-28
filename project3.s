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
	
	lw $t0, InputVariable			#Loads the word in $t0
	sub $sp, $sp, 12			#Moves the pointer for stacks
	sw $t0, 4($sp)				#Adds the input string to the word
	
	jal StringProcessor			#Jump to the first subprogram A
	
	StringProcessor:			#First subprogram that accepts all the strings and make it substrings
		sw $ra, 0($sp)			#Store return address
		li $t1, 44			#Loads a comma
		lw $t2, 4($sp)			#Loads the user input
		la $t3, ($t2)			#Loads the address of the input string
		li $t4, 0x0A			#Loads a newline
		li $t6, 0			#Length of substring
	
	