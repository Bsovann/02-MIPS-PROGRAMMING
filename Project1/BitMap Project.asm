#/////////////////////////////////////////////////////////////////////////////////////////////////////# 
# Project 1, Objective: Bitmap Project								      #
# Name: Bondith Sovann										      #
# Date: April/10/2022										      #	
#/////////////////////////////////////////////////////////////////////////////////////////////////////#

# Global variable
.eqv 			RED		0x00FF0000
.eqv			GREEN		0x0000FF00
.eqv 			BLUE		0x000000FF
.eqv 			WHITE		0x00FFFFFF
.eqv 			YELLOW		0x00FFFF00
.eqv 			CYAN 		0x0000FFFF
.eqv 			MAGENTA		0x00FF00FF
.eqv 			BLACK		0x00000000

# Width Screen in pixels (Diplay width / Unit width = 512 /8 = 64)
.eqv		WIDTH		64
# Height Screen in pixels (Diplay height / Unit height = 512 / 8 = 64)
.eqv 		HEIGHT		64

.data
# Array of colors
ArrOfColors: 	.word 		MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED
color: 		.word 		0

.text
main: 		
			jal START_GAME
			jal FRUIT_GENERATOR
			jal DRAW_WALL
			jal SNAKE	
			# Terminate the program
exit: 			li $v0, 10
			syscall
		
DRAW_WALL:  
			addi $sp, $sp, -16
			sw $ra, ($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)
			sw $a2, 12($sp)
		
			li $t0, 0			
			li $a1, 0
			li $a0, 0 
			addi $a2, $0, MAGENTA
		
top_pixels:		# Top Border
			beq $t0, 63, resetCounter1							
			jal DRAW_PIXEL			
			addi $a0, $a0, 1		
			addi $t0, $t0, 1		
			j top_pixels			
	
resetCounter1: 		move $t0, $0			
right_pixels:		# Right Border
			beq $t0, 63, resetCounter2					
			jal DRAW_PIXEL			
			addi $a1, $a1, 1		
			addi $t0, $t0, 1		
			j right_pixels			
	
resetCounter2: 		move $t0, $0			
bottom_pixels: 		# Bottom Border
			beq $t0, 63, resetCounter3									
			jal DRAW_PIXEL			
			subi $a0, $a0, 1		
			addi $t0, $t0, 1		
			j bottom_pixels			
	
resetCounter3: 		move $t0, $0			
left_pixels:		# Left Border			
			beq $t0, 63, RETURN_WALL					
			jal DRAW_PIXEL			
			subi $a1, $a1, 1		
			addi $t0, $t0, 1 		
			j left_pixels
RETURN_WALL:
			lw $ra, ($sp)
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $a2, 12($sp)
			addi $sp, $sp, 12
			jr $ra
				
START_GAME:	
			addi $sp, $sp, -4
			sw $ra, ($sp)
			
			jal HEAD_COOR
			addi $a2, $0, RED
			jal DRAW_PIXEL
		
			lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra
				
# SUBROUTINE: HEAD COOR
HEAD_COOR:
			# Centralize the box 
			# x = 28 
			addi $sp, $sp, -4
			sw $ra, ($sp)
		
			addi $a0, $0, WIDTH 		# a0 = x = (WIDTH / 2) - 4
			sra $a0, $a0, 1			# shift right 
			subi $a0, $a0, 4		# a0 - 4
			# y = 28
			addi $a1, $0, HEIGHT		# a1 = y = (HEIGHT / 2) - 4
			sra $a1, $a1, 1 		# shift right 
			subi $a1, $a1, 4		# a1 - 4
		
			lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra
			
# SUBROUTINE:FRUIT COOR		
FRUIT_COOR: 
			addi $sp, $sp, -12
			sw $a0, ($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
		
			li $v0, 42
			li $a0, 2
			li $a1, 64
			syscall
		
			move $t5, $a0
		
			li $v0, 42
			li $a0, 2
			li $a1, 64
			syscall
		
			move $t6, $a0			
		
			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
		
			move $v0, $t5
			move $v1, $t6
			jr $ra
			
# SUBROUTINE:GENERATOR
FRUIT_GENERATOR:
		
			# $s7 is fruit count
			addi $sp, $sp, -16
			sw $a0, ($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			jal FRUIT_COOR
			move $a0, $v0
			move $a1, $v1
			add $a2, $0, CYAN
		
			jal DRAW_PIXEL	
		
			jal FRUIT_COOR
			move $a0, $v0
			move $a1, $v1
			add $a2, $0, CYAN
		
			jal DRAW_PIXEL		
		
			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
		
			jr $ra
		
# SUBROUTINE: CHECK MOVE
CHECK_MOVE:	
			addi $sp, $sp, -4
			sw $ra, ($sp)
		
			li $a3, 0

			# Check input
			lw $t0, 0xffff0000
			beq $t0, 0, return_key	 	

			# Keyboard Detection 
loop:			lw $s1, 0xffff0004		
			beq $s1, 119, up_key		 
			beq $s1, 115, down_key 		
			beq $s1, 97, left_key		 
			beq $s1, 100, right_key		
			# Invalid Input
			j return_key
	
up_key: 		# UP 
			li $a3, 1
			j return_key
		
down_key: 		# DOWN 			
			li $a3, 2
			j return_key		

left_key:		# LEFT			 
			li $a3, 3
			j return_key
		
right_key: 		# RIGHT	
			li $a3, 4
			j return_key

return_key: 	
			lw $ra, ($sp)
			addi $sp, $sp, 4
			add $v0, $0, $a3
			jr $ra
			
#SUBROUTINE: TAIL COOR
TAIL_COOR:	
			addi $sp, $sp, -12
			sw $a0, ($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
		
			li $s2, 0
			li $s3, 0
			
			move $t9, $s6
			#beq $k1, $a3, load	
check:		
			beq $t9, 1, tail_Y_Up
			beq $t9, 2, tail_Y_Down
			beq $t9, 3, tail_X_Left
			beq $t9, 4, tail_X_Right
			beq $t9, 0, tail_K1_ZERO
		
tail_Y_Up:		beq $s7, 0, load
			#addi $t0, $s7, 1
			add $s3, $s3, $s7	
			j load

tail_Y_Down:		beq $s7, 0, load
			#addi $t0, $s7, 1
			sub $s3, $s3, $s7
			j load
 	 		
tail_X_Left:		beq $s7, 0, load
			#addi $t0, $s7, 1
			add $s2, $s2, $s7
			j load
		
tail_X_Right:		beq $s7, 0, load
			#addi $t0, $s7, 1
			sub $s2, $s2, $s7		
			j load
		
tail_K1_ZERO:		move $t9, $k0
			j check
		
load:			add $t4, $s2, $t7 		# X coor of Tail 
			add $t5, $s3, $t8		# Y coor of Tail  

			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12 
		
return_coor:		move $v0, $t4
			move $v1, $t5
			jr $ra
			
# SUBROUTINE: UPDATE LENGTH & MOVEMENT		
UPDATE_SNAKE: 
			addi $sp, $sp, -8
			sw $a2, 0($sp)
			sw $ra, 4($sp)
		
			move $t0, $a0  			# x - HEAD snake going right copy	
			move $t1, $a1			# y - HEAD snake going down copy
								

condition:		beq $s7, 0, default
			beq $k1, $k0, default
			beq $k0, 0, default
			beq $a3, 0, default
			#beq $a3, $k0, default
		
			move $t7, $s4
			move $t8, $s5
			move $s6, $k1
			jal TAIL_COOR
			move $s2, $v0			# x - COOR of Tail 
			move $s3, $v1			# y - COOR of Tail
		
			beq $k0, 4, loopCondition1 
			beq $k0, 3, loopCondition2 
			beq $k0, 2, loopCondition3
			beq $k0, 1, loopCondition4
	 
loopCondition1: 
		
			beq $k1, 1, loopCon1   # Prev head go up
			beq $k1, 2, loopCon2
	
loopCon1:		
			jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			addi $a0, $a0, 1
			subi $s3, $s3, 1
			bne $t1, $s3, loopCon1
			j return_del1
			
loopCon2:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			addi $a0, $a0, 1
			addi $s3, $s3, 1
			bne $t1, $s3, loopCon2
			j return_del1			

loopCondition2: 
			beq $k1, 1, loopCon3
			beq $k1, 2, loopCon4
		
loopCon3:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			subi $a0, $a0, 1
			subi $s3, $s3, 1
			bne $t1, $s3, loopCon3
			j return_del1
		 		 	 	
loopCon4:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			subi $a0, $a0, 1
			add $s3, $s3, 1
			bne $t1, $s3, loopCon4
			j return_del1
				

loopCondition3: 
			beq $k1, 3, loopCon5
			beq $k1, 4, loopCon6
		
loopCon5:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			addi $a1, $a1, 1
			subi $s2, $s2, 1
			bne $t0, $s2, loopCon5
			j return_del1
		 		 	 	 		 	 	
loopCon6:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			addi $a1, $a1, 1
			addi $s2, $s2, 1
			bne $t0, $s2, loopCon6
			j return_del1

loopCondition4: 
		
			beq $k1, 3, loopCon7
			beq $k1, 4, loopCon8
		
loopCon7:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			subi $a1, $a1, 1
			subi $s2, $s2, 1
			bne $t0, $s2, loopCon7
			j return_del1
		 		 	 	
loopCon8:		jal DELETE_PREV_PIXEL
			jal DRAW_SNAKE
			jal DELAY_FOR_TAIL
			subi $a1, $a1, 1
			addi $s2, $s2, 1
			bne $t0, $s2, loopCon8
			j return_del1
#												
default:	
			move $t7, $a0
			move $t8, $a1
			move $s6, $k0
			jal TAIL_COOR
			move $s2, $v0		
			move $s3, $v1		
			jal DELETE_PREV_PIXEL
			j return_del2
								
return_del1:	
			lw $a2, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			jr $ra	
		
return_del2:		jal NEXT_MOVE
			jal DRAW_SNAKE
			lw $a2, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			jr $ra	
		
# SUBROUTINE: Next MOVE
NEXT_MOVE:
			beq $k0, 1, move_up 
			beq $k0, 2, move_down
			beq $k0, 3, move_left
			beq $k0, 4, move_right
		
move_up:		subi $a1, $a1, 1
			j return_move
		
move_down:		addi $a1, $a1, 1
			j return_move
		
move_left:		subi $a0, $a0, 1
			j return_move
			
move_right:		addi $a0, $a0, 1
			j return_move
			
return_move: 		jr $ra 	
																																					
# SUBROUTINE: Draw SNake
DRAW_SNAKE:	
			addi $sp, $sp, -8
			sw $a2, 0($sp)
			sw $ra, 4($sp)
		
			#addi $a2, $0, RED
			jal COLORING
			jal DRAW_PIXEL
		
			lw $a2, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			jr $ra

# SUBROUTINE: Delete last pixel of snake
DELETE_PREV_PIXEL: 	
			addi $sp, $sp, -16
			sw $a0, ($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			move $a0, $s2
			move $a1, $s3
			addi $a2, $0, BLACK
		
			jal DRAW_PIXEL
			
			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)	
			lw $ra, 12($sp)
			add $sp, $sp, 16
			jr $ra										
						
#SUBROUTINE: SNAKE
SNAKE:
			#addi $sp, $sp, -4
			#sw $ra, 0($sp)	
			jal CHECK_MOVE 
			move $a3, $v0
		
again:	 		add $k0, $0, $a3		
			beq $a3, 1, moveUp
			beq $a3, 2, moveDown
			beq $a3, 3, moveLeft
			beq $a3, 4, moveRight
			beq $a3, 0, SNAKE

moveUp:			jal SAVE_HEAD_COOR
			jal DETECT_HEAD	
			add $s7, $s7, $v0
	
			jal UPDATE_SNAKE
			
DrawUp:			jal DELAY			
			jal CHECK_MOVE
			move $a3, $v0
			beq $a3, 2, moveUp
			beq $a3, 0, moveUp
			li $k1, 1
			j again

moveDown:		jal SAVE_HEAD_COOR
			jal DETECT_HEAD	
			add $s7, $s7, $v0
		
			jal UPDATE_SNAKE
			
DrawDown:		jal DELAY			
			jal CHECK_MOVE
			move $a3, $v0
			beq $a3, 1, moveDown
			beq $a3, 0, moveDown
			li $k1, 2
			j again

moveLeft:		jal SAVE_HEAD_COOR
			jal DETECT_HEAD	
			add $s7, $s7, $v0
					
			jal UPDATE_SNAKE
		
DrawLeft:		jal DELAY				
			jal CHECK_MOVE
			move $a3, $v0
			beq $a3, 4, moveLeft
			beq $a3, 0, moveLeft
			li $k1, 3
			j again
				
moveRight:		jal SAVE_HEAD_COOR
			jal DETECT_HEAD	
			add $s7, $s7, $v0
					
			jal UPDATE_SNAKE
			
DrawRight:		jal DELAY				
			jal CHECK_MOVE
			move $a3, $v0
			beq $a3, 3, moveRight
			beq $a3, 0, moveRight
			li $k1, 4
			j again
		
return: 	
			jr $ra		
# Helper Method
SAVE_HEAD_COOR:
			move $s4, $a0
			move $s5, $a1
			jr $ra

# Helper Method
DETECT_HEAD: 
			addi $sp, $sp, -12
			sw $a0, ($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
		
			beq $k0, 1, detect_up 
			beq $k0, 2, detect_down
			beq $k0, 3, detect_left
			beq $k0, 4, detect_right
		
detect_up:		subi $a1, $a1, 1
			j detect
		
detect_down:		addi $a1, $a1, 1
			j detect
		
detect_left:		subi $a0, $a0, 1
			j detect 
		
detect_right:		addi $a0, $a0, 1
			j detect
				
detect:			mul $s1, $a1, WIDTH		
			add $s1, $s1, $a0 		 
			mul $s1, $s1, 4			 
			add $s1, $s1, $gp		
			lw $t0, ($s1)			
	
			beq $t0, CYAN, UPDATE_LENGTH
			beq $t0, MAGENTA, exit
			j RETURN_WITH_NO_UPDATE
						
UPDATE_LENGTH: 		addi $t2, $0, 1
			jal FRUIT_GENERATOR
		
			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
		
			move $v0, $t2	
			jr $ra

RETURN_WITH_NO_UPDATE:
			lw $a0, ($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
		
			li $v0, 0
			jr $ra				

# SUBROUTINE: Draw a pixel 
# $a0 = x
# $a1 = y 
# $a2 = color
DRAW_PIXEL: 
		# To draw a pixel :
		# 1. find the address at that coordinate (MEM + 4*(x + y* width))
		# 2. and assignmentthe color 
		addi $sp, $sp, -4
		sw $ra, ($sp)
		
		mul $s1, $a1, WIDTH		# y * width 
		add $s1, $s1, $a0 		# (x + y * width) 
		mul $s1, $s1, 4			# to get word offset 
		add $s1, $s1, $gp		# add global pointer (base address)
		sw $a2, ($s1)			# store color at memory location
		
		lw $ra, ($sp)
	  	addi $sp, $sp, 4
		jr $ra   
	  
# SUBROUTINE: Coloring the pixel
reset: 	  	li $t2, 0
COLORING: 	la $t3, ArrOfColors 		# address of the array
	  	 
	 	beq $t2, 6, reset		# Condition for color rotating 
	  	sll $t4, $t2, 2 		# i = i * 4 
	 	add $t5, $t3, $t4		# color address
	 	lw $v0, ($t5)			# Load color from that address
	 	move $a2, $v0			# Store it back to color
	  	addi $t2, $t2, 1		# Increment i by 1
	  
	  	
	 	jr $ra				# Return the "ra" 

# SUBROUTINE: Delay function
DELAY: 	  
		# Save ra
		addi $sp, $sp, -8
		sw   $ra, ($sp)
		sw   $a0, 4($sp)
		
		# System call 32
		li $v0, 32
		li $a0, 25			# Sleep for 10ms
		syscall
	
		# Restore $ra and $a0
		lw $ra, ($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		
DELAY_FOR_TAIL: 	  
		# Save ra
		addi $sp, $sp, -8
		sw   $ra, ($sp)
		sw   $a0, 4($sp)
		
		# System call 32
		li $v0, 32
		li $a0, 5			# Sleep for 5ms
		syscall
	
		# Restore $ra and $a0
		lw $ra, ($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra		
#/////////////////////////////////////////////END///////////////////////////////////////////////////#	
		
		
		
		
		
