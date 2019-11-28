#HU ID: @02884990
#02884990%11 = 9
#26 + 9 = Base 35
#Range (0,y) and (0-Y)

.data 						#Declarations
InputVariable: .space 1000			#Variable for user input 
list: .word 0, 0, 0, 0				#Created a word list
BadInput: .asciiz "Invalid input"		#Variable used to output Invalid input

.text						#Instructions stored in text segment at next available address
.globl main					#Allows main to be refrenced anywhere


