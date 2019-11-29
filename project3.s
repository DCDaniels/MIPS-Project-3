#02856918 % 11 = 9 Base 35

.data #section to declare data
user_input: .space 2000 # creating space for the user input
invalid: .asciiz "NaN" #creating the error message for incorrect input
subString: .word 0, 0, 0, 0 #initialize a word list

.text #Assembly language instruction


main: 

	la $s0, subString #load the address of the list
	
	li $v0, 8 #accepts user input
	la $a0, user_input
	li $a1, 1002 #specify the length of the input a person can enter
	syscall
	
	
	lw $t0, user_input #loads the word in $t0
	sub $sp, $sp, 12 #moves the pointer for stack
	sw $t0, 4($sp) #adds the input string to the word
	
	
	jal processString #jumps to subprogram A
	
	
	
processString:   #subprogram A to accept all the string and make it substrings
	
	sw $ra, 0($sp) #stores the return address for the program
	li $t1, 44 #loads a comma
	lw $t2, 4($sp) #loads the user_input
	la $t3, ($a0) #loads the address of the input string 
	li $t4, 0x0A #loads a newline
	li $t6, 0 #length of substring
	
	
	
	loop: #loop to parse each substring
		
		lb $t5, 0($t3)	#loads one byte of the word
		beq $t5, $t4, lastSubstring #branches if the byte is equal to a newline
		beq $t5, $t1, parseSubstring #branches if the byte is equal to a commma
		addi $t6, $t6, 1 #increments the length of substring
		addi $t3, $t3, 1 #increments the address of the word
		j loop
	
	parseSubstring: #takes care of parsing the substring
		sub $t3, $t3, $t6 #returns the word address to the first byte
		li $t7, 0 #check if leading 
		li $t8, 32 #loads a space
		li $t9, 9 #loads a tab
		li $s1, 4 #loads the max amount of characters
		li $s2, 0 #loads a counter for the amount of characters in the substring
		
	loopTwo: 
		
		beq $t6, $s2, validSubstring #branches if all the substring is finished
		lb $t5, 0($t3) #loads one byte of the word
		addi $s2, $s2, 1 #increments the counter for numbers in substring
		beq $t7, $zero, leading_chars #branch if byte could be leading
		
	parseStringHelper:
		beq $t5, $t8, skip_trailing_tab_or_space
		beq $t5, $t9, skip_trailing_tab_or_space
		addi $t7, $t7, 1 #increments the amount of non-space or non-tab chars
		sb $t5, 0($s0) #stores the char in a list
		addi $s0, $s0, 1 #increments the word list
		bgt $t7, $s1, invalid_substring #branches if amount of characters is more than 4
		addi $t3, $t3, 1 #increments the address of the word
		j loopTwo
		
		
	invalid_substring:
		li $v0, 4
		la $a0, invalid #prints "NaN"
		syscall
	
	nextSubstring:
		blt $a3, $zero, endProgram
		li $a0, ','
		li $v0, 11 #prints ","
		syscall	
		
		addi $t3, $t3, 1 #moves the address of the user input after the first substring
		add $t6, $zero, $zero
		
		j loop
		
	endProgram:
	li $v0, 10
	syscall  #tell the system this is the end of file
	
		
	leading_chars: #checks if it is a leading space/tab
		beq $t5, $t8, skip_leading_tab_or_space
		beq $t5, $t9, skip_leading_tab_or_space
		
		j parseStringHelper
		
	skip_leading_tab_or_space: #increments char
		addi $t3, $t3, 1
		j loopTwo
	
	skip_trailing_tab_or_space: #checks if the rest of the substring tabs and spaces
		addi $t3, $t3, 1 #move to the next byte
		lb $t5, 0($t3)  #gets a character of the string
		beq $t5, $t1, validSubstring #branches if only trailing tabs are spaces are found before newline
		bne $t5, $t8, not_a_space #branches if character is not a space
		j skip_trailing_tab_or_space #returns to check next character for trailing tab or space
	
	not_a_space:
		bne $t5, $t9, invalid_substring #if character after space for trailing is not a tab or space then print invalid
		j skip_trailing_tab_or_space #returns to check the next character for trailing tab or space
	
	lastSubstring: #checks the final substring		
		add $a3, $zero, -1
		j parseSubstring
		
		
	validSubstring:
		li $a0, 35 #initialized the base number
		sub $s0, $s0, $t7
		sw $s0, 8($sp) #adds the substring of the 4 letters to the stack
		add $a1, $t7, $zero #changes variable $t7 to and argument
		
		jal convertSubstring #subprogram to convert to base 35
		blt $v0, $zero, invalid_substring #prints error message for that substring
		
		add $t7, $v0, $zero #move the answer to a different variable
		li $v0, 1
		move $a0, $t7
		syscall #prints the result of the decimal equivalent to the base 35 number
		add $s4, $zero, $zero #reinitialize s4
		j nextSubstring
		
convertSubstring: 
	
	sw $ra, 12($sp) #stores the return address in stack 
	lw $s3, 8($sp) #gets the substring from stack
	
	loopConvert:
	
		lb $t5, 0($s3) #gets the first byte from the substring
	
		li $t7, 48 #lowest possible valid character ascii
		li $t8, 57 #hightest possible non-letter digit ascii
		li $t9, 65 #lowest possible capital letter ascii
		li $s5, 89 #highest possible capital letter ascii # =Y since N = 35
		li $s1, 97 #lowest possible common letter ascii 
		li $s2, 121 #highest possible common letter ascii = y since N = 35
	
		blt $t5, $t7, print_invalid_input #breaks if ascii of character is < 48
		bgt $t5, $t8, not_a_digit #breaks if ascii of character is > 57
		addi $t5, $t5, -48 #makes the ascii digit align with capital letters
		
	
	convertByteHelper:
		add $a0, $t5, $zero #loads byte in a0 to be passed as an argument
		
		jal convertByte #subprogram to convert byte to base 35
		add $s4, $s4, $v0 #adds the amount for that digit to the total
		addi $s3, $s3, 1 #increments the address
		addi $a1, $a1, -1 #decrements the character position
		beq $a1, $zero, endSubstring
		j loopConvert
		
	print_invalid_input:
		addi $v0, $zero, -1 #sets the value of v0 to negative 
		j returnToNextSubstring
			
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
	
	endSubstring:
		add $v0, $s4, $zero #puts the converted substring in the return variable
		
	returnToNextSubstring:
		lw $ra, 12($sp) #loading the return value register
		jr $ra
		
		
convertByte:
	li $t7, 1
	li $t8, 2
	li $t9, 3
	li $s1, 4
	beq $a1, $s1,four_valid_chars #branch if there are 4 characters
	beq $a1, $t9,three_valid_chars #branch if there are 3 characters
	beq $a1, $t8,two_valid_chars #branch if there are 2 valid characters
	beq $a1, $t7,one_valid_char #branch if there is one valid character
	
	four_valid_chars:
	li $t9, 42875
	multu $t9, $a0 #multiplying the character by the base number to a specific power
	mflo $v0 #moves the answer to a register to be passed back to the function
	jr $ra
	
	three_valid_chars:
	li $t9, 1225
	multu $t9, $a0 #multiplying the character by the base number to a specific power
	mflo $v0 #moves the answer to a register to be passed back to the function
	jr $ra
	
	two_valid_chars:
	li $t9, 35
	multu $t9, $a0 #multiplying the character by the base number to a specific power
	mflo $v0 #moves the answer to a register to be passed back to the function
	jr $ra
	
	one_valid_char:
	li $t9, 1
	multu $t9, $a0 #multiplying the character by the base number to a specific power
	mflo $v0 #moves the answer to a register to be passed back to the function
	jr $ra