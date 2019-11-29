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
	
	Loop: 					#Loop to parse each substring
		lb $t5, 0($t3)			#Gets one byte and loads it
		beq $t5, $t4, LSubstring 	#Branch if newline
		beq $t5, $t1, PSubstring 	#Branch if commma
		addi $t6, $t6, 1		#Increments the length of substring
		addi $t3, $t3, 1		#Increments the address of the word
		j Loop				#Go to start of the Loop again
		
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
		beq $t7, $zero, Leads 	#Branches if possible leading character
	
	
	PStringAssister:
		beq $t5, $t8, Trailing
		beq $t5, $t9, Trailing
		addi $t7, $t7, 1 
		sb $t5, 0($s0) 	
		addi $s0, $s0, 1 
		bgt $t7, $s1, Bad_Substring
		addi $t3, $t3, 1
		
		
	Bad_Substring:
		li $v0, 4
		la $a0, BadInput 		#prints "NaN"
		syscall
		
		
	LSubstring: 				#Checks the last substring		
		lw $ra, 0($sp) 			#Loads the return address
		jr $ra 				#Returns to last call
		
		
	Move_to_next_Substring:
		li $a0, ','
		li $v0, 11 			#prints ","
		syscall	
		
		add $t3, $t3, $t6
		addi $t3, $t3, 1 
		add $t6, $zero, $zero
		j Loop
		
	Leads: 
		beq $t5, $t8, Leading
		beq $t5, $t9, Leading
		j PStringAssister
		
	
	Leading: 
		addi $t3, $t3, 1
		j LoopTwo
	
	
	Trailing: 
		addi $t3, $t3, 1 
		lb $t5, 0($t3)  
		beq $t5, $t1, Good_Strings 
		bne $t4, $t8, Not_Space 
		j Trailing 
		
	
	Not_Space:
		bne $t4, $t9, Bad_Substring
		j Trailing 
	
		
	Good_Strings:
		li $a0, 35 
		sub $s0, $s0, $t7
		sw $s0, 8($sp) 
		add $a1, $t7, $zero 
		
		jal Substring_Conversion 
		j Move_to_next_Substring
		
	
	Substring_Conversion: 
		sw $ra, 12($sp) 
		lw $s3, 8($sp) 
		lb $t5, 0($s3) 
		li $t7, 48 
		li $t8, 57 
		li $t9, 65 
		li $s0, 89 
		li $s1, 97 
		li $s2, 121 
		blt $t4, $s4, print_invalid_input 
		bgt $t4, $s5, not_a_digit 
