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
	
	li $v0, 10
	syscall
	
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
		j LoopTwo
		
		
	Bad_Substring:
		li $v0, 4
		la $a0, BadInput 		#prints "NaN"
		syscall
		
			
	Move_to_next_Substring:
		li $a0, ','
		li $v0, 11 			#prints ","
		syscall	
		
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
		bne $t5, $t8, Not_Space 
		j Trailing 
		
	
	Not_Space:
		bne $t5, $t9, Bad_Substring
		j Trailing 
		
	
	LSubstring: 				#Checks the last substring		
		lw $ra, 0($sp) 			#Loads the return address
		jr $ra 				#Returns to last call
	
		
	Good_Strings:
		li $a0, 35 
		sub $s0, $s0, $t7
		sw $s0, 8($sp) 
		add $a1, $t7, $zero 
		
		jal Substring_Conversion 
		blt $v0, $zero,Invalid_Output 
		add $t7, $v0, $zero
		li $v0, 1
		move $a0, $t7
		syscall
		add $s4, $zero, 4zero
		j Move_to_next_Substring
	
	
	Convert_Substring:
		sw $ra, 12($sp)
		lw $s3, 8($sp)
	
	Convert_Loop:	
		lb $t5, 0($s3)
		li $t7, 48 
		li $t8, 57 
		li $t9, 65 
		li $s0, 89 
		li $s1, 97 
		li $s2, 121 
		blt $t5, $t7, Invalid_Output #breaks if ascii of character is < 48
		bgt $t5, $t8, not_a_digit #breaks if ascii of character is > 57
		addi $t5, $t5, -48
		
	Convert_Byte_Helper:			
		lb $a0, $t4
		jal Conversion_to_Byte
		add $s4, $s4, $v0 #adds the amount for that digit to the total
		addi $s3, $s3, 1 #increments the address
		addi $a1, $a1, -1 #decrements the character position
		beq $a1, $zero, End
		j Convert_Loop
		
	Invalid_Output:
		addi $v0, $zero, -1  
		j Return
		
	not_a_digit:
		blt $t5, $t9, print_invalid_input #breaks if ascii of character is < 65
		bgt $t5, $s5, not_a_capital_letter #breaks if ascii of character is > 89
		addi $t5, $t5, -55 #makes the ascii for digit align with capital letters
		j convertByteHelper
		
	not_a_capital_letter:
		blt $t5, $s1, print_invalid_input #breaks if ascii of character is < 97
		bgt $t5, $s2, print_invalid_input #breaks if ascii of character is > 121
		addi $t5, $t5, -87 #makes the ascii for digit align with common letters
		j convertByteHelper
		
	End:
		add $v0, $s4, $zero
		
	Return:
		lw $ra, 12($sp) #loading the return value register
		jr $ra
		
Conversion_to_Byte:
	li $t7, 1
	li $t8, 2
	li $t9, 3
	li $s1, 4
	beq $a1, $s1,Four #branch if there are 4 characters
	beq $a1, $t9,Three #branch if there are 3 characters
	beq $a1, $t8,Two #branch if there are 2 valid characters
	beq $a1, $t7,One #branch if there is one valid character
		

	Four:
	li $t9, 42875
	multu $t9, $a0 
	mflo $v0
	jr $ra
	
	
	Three:
	li $t9, 1225
	multu $t9, $a0 
	mflo $v0 
	jr $ra
	
	
	Two:
	li $t9, 35
	multu $t9, $a0 
	mflo $v0 
	jr $ra	
	
	
	One:
	li $t9, 1
	multu $t9, $a0 
	mflo $v0 
	jr $ra