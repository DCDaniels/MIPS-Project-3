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
	
	loop: 					#Loop to parse each substring
		lb $t5, 0($t3)			#Gets one byte and loads it
		beq $t5, $t4, LSubstring 	#Branch if newline
		beq $t5, $t1, PSubstring 	#Branch if commma
		addi $t6, $t6, 1		#Increments the length of substring
		addi $t3, $t3, 1		#Increments the address of the word
		j loop				#Go to start of the loop again
		
	PSubstring:				#Parse the substrings
		sub $t3, $t3, $t6		#Return the word address
		li $t7, 0			#Check if leading
		li $t8, 32			#Loads a space
		li $t9, 9			#Loads a tab
		li $s1, 4			#Loads the max amount of characters
		li $s2, 0			#Loads a counter for the anumber of characters
		
	LoopTwo:
		beq $t6, $s2, VSubstring 
		lb $t5, 0($t3) 			#Loads piece of the word
		addi $s2, $s2, 1 		#Increments counter
		beq $t7, $zero, leads 	#Branches if possible leading character
	
	
	PStringAssister:
		beq $t5, $t8, skip_trailing_tab_or_space
		beq $t5, $t9, skip_trailing_tab_or_space
		addi $t7, $t7, 1 
		sb $t5, 0($s0) 	
		addi $s0, $s0, 1 
		bgt $t7, $s1, invalid_substring 
		addi $t3, $t3, 1
		
		
	invalid_substring:
		li $v0, 4
		la $a0, BadInput #prints "NaN"
		syscall
		
		
	LSubstring: 				#Checks the last substring		
		lw $ra, 0($sp) 			#Loads the return address
		jr $ra 				#Returns to last call
		
		
	nextSubstring:
		li $a0, ','
		li $v0, 11 #prints ","
		syscall	
		
		add $t3, $t3, $t6
		addi $t3, $t3, 1 
		add $t6, $zero, $zero
		j loop
		
	leading_chars: 
		beq $t5, $t8, skip_leading_tab_or_space
		beq $t5, $t9, skip_leading_tab_or_space
		j parseStringHelper
		
	
	skip_leading_tab_or_space: 
		addi $t3, $t3, 1
		j LoopTwo
	
	
	skip_trailing_tab_or_space: #checks if the rest of the substring tabs and spaces
		addi $t3, $t3, 1 #move to the next byte
		lb $t5, 0($t3)  #gets a character of the string
		beq $t5, $t1, validSubstring #branches if only trailing tabs are spaces are found before newline
		bne $t4, $t8, not_a_space #branches if character is not a space
		j skip_trailing_tab_or_space #returns to check next character for trailing tab or space
		