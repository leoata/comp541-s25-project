# =============================================================
# main PROCEDURE TEMPLATE # 4b
#
# Use with "proc_template.asm" as the template for other procedures
#
# Based on "Ex4b" of Lecture 9 (Procedures and Stacks) of COMP411 Spring 2020
#   (main is simpler than other procedures because it does not have to
#     clean up anything before exiting)
#
# Assumptions:
#
#   - main calls other procedures with no more than 4 arguments ($a0-$a3)
#   - any local variables needed are put into registers (not memory)
#   - no values are put in temporaries that must be preserved across a call from main
#       to another procedure
#
# =============================================================

.data 0x10010000                # Start of data memory
.align 2
#
# declare global variables here
seed: .word 1
# Maze dimensions: n = number of rows, k = number of columns.
n:      .word 30         # number of rows
k:      .word 40         # number of columns
# Each cell is an int (4 bytes) so we reserve (n * k * 4) bytes.

maze: 	
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 0, 5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	


.text 0x00400000                # Start of instruction memory
.globl main

##################################################
## INITIALIZATION
## 
## Registers only used for filling maze:
##	- $s6 (maze base address)
##	- $s2 (n value)
## 	- $s3 (k value)
##	- $s7 (computing maze index)
## 
## Registers initialized for game:
##	- $s0 (preciseBallX)
##	- $s1 (preciseBallY)
##	- $s4 (speed buff tracker)
##	- $s5 (wall breaker uses left)
##################################################

main:
    lui     $sp, 0x1001         # Initialize stack pointer to the 1024th location above start of data
    ori     $sp, $sp, 0x1000    # top of the stack will be one word below
                                #   because $sp is decremented first.
    addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame
    
    
    la   $s6, maze         # Load address of maze array
    
    addi $s0, $zero, 64 # preciseBallX aka the true X value multiplied by 64
    addi $s1, $zero, 64 # preciseBallY aka the true Y value multiplied by 64
    
    
    add   $a2, $zero, $zero    # i = 0
    lw    $s2, n               # s2 = number of rows (n)
    lw    $s3, k               # s3 = number of cols (k)
    addi  $s4, $zero, 0        # s4 = row offset/maze index
    
outer_maze_display_loop:
	beq $a2, $s2, first_game_loop # i==n
	add $a1, $zero, $zero # j=0
    
inner_maze_display_loop:
	beq $a1, $s3, increment_maze_display_loop
	
    	move $s7, $s4
	
	add  $s7, $s6, $s7     # $t7 = address of maze[index]
    	lw   $a0, 0($s7)       # Load maze[index] into $a0
    
	jal putChar_atXY
	
	addi $a1, $a1, 1
	addi $s4, $s4, 4
    	j inner_maze_display_loop
increment_maze_display_loop:
	addi $a2, $a2, 1
	
	j outer_maze_display_loop

# EVERYTHING KNOWN WORKING BEFORE THIS POINT BESIDES A WEIRD PRINT ON THE BOTTOM OF THE MAZE
    
##################################################
## GAME LOOP
##
## Registers used:
##	- $s0: preciseBallX
##	- $s1: preciseBallY
##	- $s2: preciseTargetX
##	- $s3: preciseTargetY
##	- $s4: speedBuffLevel
##	- $s5: wallbreakerUsesLeft
##	- $s6
##		- For reading accelX and converting it to precise
##		- For matching the collision type
##	- $s7
##		- For reading accelY and converting it to precise
##		- For reading the collision type

first_game_loop:
    add $s4, $zero, $zero # +1 = speed buff, 0 = nothing, -1 = slow debuff
    add $s5, $zero, $zero # wall breaker uses left
game_loop:
	addi $a0, $zero, 0
	srl $a1, $s0, 6
	srl $a2, $s1, 6
	jal putChar_atXY


	jal get_accelX
	move $s6, $v0
	addi $s6, $s6, -256
	sub $s6, $zero, $s6
	
	
	jal get_accelY
	move $s7, $v0
	addi $s7, $s7, -256
	sub $s7, $zero, $s7

	addi $s2, $zero, 1
	beq $s2, $s4, speedup_movement
	addi $s2, $zero, -1
	beq $s2, $s4, slowdown_movement
after_movement_speed_adjustments:
	
	
	add $s2, $s0, $s7 # targetX = preciseBallX + preciseAccelY (accelY is actually X in game)
	add $s3, $s1, $s6 # targetY = preciseBallY + preciseAccelX (accelX is actually Y in game)
	
	srl $a1, $s2, 6
	srl $a2, $s3, 6
	jal getChar_atXY
	
	move $s7, $v0
	
	
	addi $s6, $zero, 1
	beq $s6, $s7, collision_case1
	
	addi $s6, $zero, 3
	beq $s6, $s7, collision_case3
	
	addi $s6, $zero, 4
	beq $s6, $s7, collision_case4
	
	addi $s6, $zero, 5
	beq $s6, $s7, collision_case5
	
	addi $s6, $zero, 6
	beq $s6, $s7, collision_case6
	
resume_after_collisions:
	move $s0, $s2 # preciseBallX = preciseTargetX
	move $s1, $s3 # preciseBallY = preciseTargetY
	
	move $v0, $s0
	move $v1, $s1

	blt $s0, $zero, ball_x_too_low
	blt $s1, $zero, ball_y_too_low
	
	lw $t2, n
	lw $t3, k
	srl $t4, $s0, 6 # ballX
	srl $t5, $s1, 6 # ballY
	slt $t4, $t4, $t3 # set $a0 to 0 if preciseBallX/16 is too high
	slt $t5, $t5, $t2 # set $a1 to 0 if preciseBallY/16 is too high
	
	beq $t5, $zero, ball_x_too_high
	beq $t5, $zero, ball_y_too_high
	move $s0, $v0
	move $s1, $v1
	
	addi $a0, $zero, 2
	srl $a1, $s0, 6
	srl $a2, $s1, 6
	
	jal putChar_atXY
	
	#addi $a0, $zero, 10
#	
#	jal pause
	
	
	
	j game_loop
    #jal 	generateMaze


        
collision_case1: # char 1 == wall, try wallbreaker
	bne $s5, 0, use_wallbreaker_on_full_wall
	move $s2, $s0
	move $s3, $s1
	j resume_after_collisions
	
	
collision_case4: # char 4 == slow debuff
	subi $s4, $zero, 1 # set speed buff/debuff val to -1
	
	addi $a0, $zero, 0
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallY by 16 to revert back to screen units
	
	jal putChar_atXY
	
	j resume_after_collisions
	
collision_case3: # char 3 == super speed
	addi $s4, $zero, 1 # set speed buff/debuff val to +1

	add $a0, $zero, 0
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallY by 16 to revert back to screen units
	
	jal putChar_atXY
	
	j resume_after_collisions

collision_case5: # char 5 == wall breaker
	
	addi $s5, $zero, 5
	
	add $a0, $zero, 0
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallY by 16 to revert back to screen units
	
	jal putChar_atXY
	
	j resume_after_collisions
	
	
collision_case6: # damaged wall
	
	bne $s5, 0, use_wallbreaker_on_damaged_wall
	
	add $a0, $zero, 0
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallY by 16 to revert back to screen units
	
	jal putChar_atXY
	
	j resume_after_collisions
use_wallbreaker_on_damaged_wall:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack
	
	add $a0, $zero, 0
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallXY by 16 to revert back to screen units
	
	subi $s5, $s5, 1
	jal putChar_atXY
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller

use_wallbreaker_on_full_wall:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack
	
	add $a0, $zero, 6
	srl $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	srl $a2, $s3, 6 # divide preciseBallXY by 16 to revert back to screen units
	
	subi $s5, $s5, 1
	jal putChar_atXY
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller

# $a0 = preciseBallX, $a1, preciseBallY
ensure_ball_within_bounds:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack
	
	move $v0, $a0
	move $v1, $a1
	
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller
ball_x_too_low:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack
	
	add $v0, $v0, $zero
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller
ball_y_too_low:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack
	
	add $v1, $v1, $zero
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller

ball_x_too_high:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack

	add $v0, $zero, $t3
	subi $v0, $v0, 1
	sll $v0, $v0, 6 # restore the return value to the correct units
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller
ball_y_too_high:
	addi $sp, $sp, -4   # Decrement stack pointer to make room
	sw   $ra, 0($sp)    # Save the return address on the stack

	add $v1, $zero, $t2
	subi $v1, $v1, 1
	sll $v1, $v1, 6 # restore the return value to the correct units
	
	lw   $ra, 0($sp)    # Restore the return address
	addi $sp, $sp, 4    # Restore the stack pointer
	jr   $ra           # Return to the caller


speedup_movement:
	sll $s6, $s6, 1
	sll $s7, $s7, 1
	j after_movement_speed_adjustments

slowdown_movement:
	srl $s6, $s6, 1
	srl $s7, $s7, 1
	j after_movement_speed_adjustments

exit_from_main:

    ###############################
    # END using infinite loop     #
    ###############################

                        # program may not reach here, but have it for safety
end:
    j   end             # infinite loop "trap" because we don't have syscalls to exit


######## END OF MAIN #################################################################################



.include "procs_board.asm"          # include file with helpful procedures
#.include "procs_mars.asm"

