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

#
# declare global variables here
seed: .word 1
# Maze dimensions: n = number of rows, k = number of columns.
n:      .word 25         # number of rows
k:      .word 40         # number of columns
# Each cell is an int (4 bytes) so we reserve (n * k * 4) bytes.

maze: 	
#	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#	.word  1, 2, 0, 0, 3, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 1
#	.word  1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#	.word  1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#	.word  1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#	.word  1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
#	.word  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#	.word  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
.word 1, 2, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1, 1
.word 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 5, 1, 0, 1, 1
.word 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 5, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 1, 0, 1, 1, 1, 4, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 0, 0, 1, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 1, 3, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 5, 1, 0, 1, 0, 1, 0, 1, 1
.word 1, 5, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 4, 1, 0, 0, 0, 1, 0, 1, 0, 0, 4, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1
.word 1, 4, 1, 0, 0, 0, 0, 0, 1, 3, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1
.word 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1
.word 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 5, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 4, 1, 1
.word 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1
.word 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 5, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1
.word 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1
.word 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 5, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1
.word 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1
.word 1, 3, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 1, 0, 0, 0, 1, 4, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 1, 1, 5, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1
.word 1, 0, 1, 0, 0, 4, 1, 0, 1, 4, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 1, 0, 1, 1
.word 1, 5, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1
.word 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31
.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1


# each entry: dr, dc
dirTable:
    .word -1,  0    # up
    .word  1,  0    # down
    .word  0, -1    # left
    .word  0,  1    # right

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
    
    # fill maze
    la   $s6, maze         # Load address of maze array
    lw    $s2, n               # s2 = number of rows (n)
    lw    $s3, k               # s3 = number of cols (k)
    
    
    add   $a2, $zero, $zero    # i = 0
    addi  $s4, $zero, 0        # s4 = row offset/maze index

outer_maze_display_loop:
	beq $a2, $s2, init_hud # i==n
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
	
	
init_hud:
    addi $a0, $zero, 18
    addi $a1, $zero, 19
    addi $a2, $zero, 26
    jal putChar_atXY
    addi $a0, $zero, 28
    addi $a1, $zero, 20
    addi $a2, $zero, 26
    jal putChar_atXY
    addi $a0, $zero, 15
    addi $a1, $zero, 21
    addi $a2, $zero, 26
    jal putChar_atXY
    addi $a0, $zero, 26
    addi $a1, $zero, 3
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 24
    addi $a1, $zero, 4
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 16
    addi $a1, $zero, 5
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 16
    addi $a1, $zero, 6
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 15
    addi $a1, $zero, 7
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 29
    addi $a1, $zero, 25
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 13
    addi $a1, $zero, 26
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 20
    addi $a1, $zero, 27
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 20
    addi $a1, $zero, 28
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 14
    addi $a1, $zero, 29
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 25
    addi $a1, $zero, 30
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 16
    addi $a1, $zero, 31
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 13
    addi $a1, $zero, 32
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 19
    addi $a1, $zero, 33
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 16
    addi $a1, $zero, 34
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 25
    addi $a1, $zero, 35
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 26
    addi $a1, $zero, 36
    addi $a2, $zero, 27
    jal putChar_atXY
    addi $a0, $zero, 22
    addi $a1, $zero, 3
    addi $a2, $zero, 29
    jal putChar_atXY
    addi $a0, $zero, 23
    addi $a1, $zero, 4
    addi $a2, $zero, 29
    jal putChar_atXY
    addi $a0, $zero, 25
    addi $a1, $zero, 5
    addi $a2, $zero, 29
    jal putChar_atXY
    addi $a0, $zero, 21
    addi $a1, $zero, 6
    addi $a2, $zero, 29
    jal putChar_atXY
    addi $a0, $zero, 13
    addi $a1, $zero, 7
    addi $a2, $zero, 29
    jal putChar_atXY
    addi $a0, $zero, 20
    addi $a1, $zero, 8
    addi $a2, $zero, 29
    jal putChar_atXY
    
    addi $a0, $zero, 30
    addi $a1, $zero, 25
    addi $a2, $zero, 29
    jal putChar_atXY
    
	addi $a0, $zero, 7
	addi $a1, $zero, 0
	addi $a2, $zero, 25
hud_loop:
	jal putChar_atXY
	addi $a1, $a1, 1
	bne $a1, 40, hud_loop
	
# EVERYTHING BEFORE THIS LINE WORKING

    
##################################################
## GAME LOOP
##
## Registers used:
##	- $s0: preciseBallX
##	- $s1: preciseBallY
##	- : preciseTargetX
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
    addi $s0, $zero, 64 # preciseBallX aka the true X value multiplied by 64
    addi $s1, $zero, 64 # preciseBallY aka the true Y value multiplied by 64
    add $s4, $zero, $zero # +1 = speed buff, 0 = nothing, -1 = slow debuff
    add $s5, $zero, $zero # wall breaker uses left
game_loop:
	addi $a0, $zero, 0x00000000
	jal put_leds
	jal sound_off
	
	lw $t0, n
	lw $t1, k
	
	srl $t2, $s0, 6
	srl $t3, $s1, 6
	addi $t2, $t2, 1
	addi $t3, $t3, 2
	
	bne $t2, $t1, after_win_checks
	beq $t3, $t0, game_won

	

after_win_checks:

	jal get_accelX
	addi $s6, $v0, -256 # [-256,256]
	sra $s6, $s6, 5
	
	jal get_accelY
	addi $s7, $v0, -256 # [-256,256]
	sra $s7, $s7, 5
	
	sra $t1,$s6,31   
	xor $t0,$s6,$t1  
	sub $t0,$t0,$t1   
	
	sra $t3,$s7,31   
	xor $t2,$s7,$t3 
	sub $t2,$t2,$t3   
	
	
	andi $a1, $t0, 0x00F0
	addi $a0, $zero, 1
	#jal put_7seg
	andi $a1, $t0, 0x000F
	addi $a0, $zero, 0
	#jal put_7seg
	
	andi $a1, $t2, 0x00F0
	addi $a0, $zero, 5
	#jal put_7seg
	andi $a1, $t2, 0x000F
	addi $a0, $zero, 4
	#jal put_7seg
	


	addi $t2, $zero, 1
	beq $t2, $s4, speedup_movement
	addi $t2, $zero, -1
	beq $t2, $s4, slowdown_movement
after_movement_speed_adjustments:
	
	
	add $s2, $s0, $s7 # targetX = preciseBallX + preciseAccelY (accelY is actually X in game, direction is inverted)
	sub $s3, $s1, $s6 # targetY = preciseBallY + preciseAccelX (accelX is actually Y in game)
	
	
	srl $a1, $s2, 6
	srl $a2, $s3, 6
	jal getChar_atXY
	
	move $s7, $v0
	
	
	addi $t0, $zero, 1
	beq $t0, $s7, collision_case1
	
	addi $t0, $zero, 3
	beq $t0, $s7, collision_case3
	
	addi $t0, $zero, 4
	beq $t0, $s7, collision_case4
	
	addi $t0, $zero, 5
	beq $t0, $s7, collision_case5
	
	addi $t0, $zero, 6
	beq $t0, $s7, collision_case6
	
	addi $t0, $zero, 7
	beq $t0, $s7, collision_case7
	
resume_after_collisions:

	
#	move $v0, $s2
#	move $v1, $s3

#	blt $s0, $zero, ball_x_too_low
after_ball_x_too_low:
#	blt $s1, $zero, ball_y_too_low
after_ball_y_too_low:
	
#	lw $t2, n
#	lw $t3, k
#	srl $t4, $s0, 6 # ballX
#	srl $t5, $s1, 6 # ballY
#	slt $t4, $t4, $t3 # set $a0 to 0 if preciseBallX/64 is too high
#	slt $t5, $t5, $t2 # set $a1 to 0 if preciseBallY/64 is too high
#	
#	beq $t5, $zero, ball_x_too_high
after_ball_x_too_high:
#	beq $t5, $zero, ball_y_too_high
after_ball_y_too_high:
#	move $s2, $v0
#	move $s3, $v1

	

	bne $s0, $s2, show_player_pos
	bne $s1, $s3, show_player_pos
	
	
resume_after_show_player_pos:
	addi $a0, $zero, 1
	jal pause
	
	j game_loop
    #jal 	generateMaze


show_player_pos:
	addi $a0, $zero, 0
	sra $a1, $s0, 6
	sra $a2, $s1, 6
	jal putChar_atXY
	
	move $s0, $s2 # preciseBallX = preciseTargetX
	move $s1, $s3 # preciseBallY = preciseTargetY
	
	addi $a0, $zero, 2
	sra $a1, $s0, 6
	sra $a2, $s1, 6
	
	jal putChar_atXY
	
	j resume_after_show_player_pos
        
collision_case1: # char 1 == wall, try wallbreaker
	bne $s5, 0, use_wallbreaker_on_full_wall
collision_case_1_pt2:
	move $s2, $s0
	move $s3, $s1
	sra $s2, $s2, 6
	sra $s3, $s3, 6
	sll $s2, $s2, 6
	sll $s3, $s3, 6
	j resume_after_collisions
	
collision_case4: # char 4 == slow debuff
	subi $s4, $zero, 1 # set speed buff/debuff val to -1
	jal update_speed_hud
	
	addi $a0, $zero, 0xF0F0F0F0
	jal put_leds
	
	addi $a0, $zero, 17500
	jal put_sound
	
	j resume_after_collisions
	
collision_case3: # char 3 == super speed
	addi $s4, $zero, 1 # set speed buff/debuff val to +1
	jal update_speed_hud
	
	addi $a0, $zero, 0xFFFFFFFF
	jal put_leds
	
	addi $a0, $zero, 10000
	jal put_sound
	
	j resume_after_collisions

collision_case5: # char 5 == wall breaker
	addi $s5, $zero, 5
	jal update_wallbreaker_hud
	
	addi $a0, $zero, 0xFFFFFFFF
	jal put_leds
	
	addi $a0, $zero, 10000
	jal put_sound
	
	j resume_after_collisions
	
	
collision_case6: # damaged wall
	bne $s5, 0, use_wallbreaker_on_damaged_wall
collision_case6_pt2:
	
	j resume_after_collisions
	
collision_case7: # hud barrier
	move $s2, $s0
	move $s3, $s1
	j resume_after_collisions
use_wallbreaker_on_damaged_wall:
	add $a0, $zero, 0
	sra $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	sra $a2, $s3, 6 # divide preciseBallXY by 16 to revert back to screen units

	jal putChar_atXY
	
	subi $s5, $s5, 1
	jal update_wallbreaker_hud
	
	addi $a0, $zero, 45000
	jal put_sound
	
	j collision_case6_pt2

use_wallbreaker_on_full_wall:


	add $a0, $zero, 6
	sra $a1, $s2, 6 # divide preciseBallX by 16 to revert back to screen units
	sra $a2, $s3, 6 # divide preciseBallXY by 16 to revert back to screen units
	
	lw $t0, n
	lw $t1, k
	
	# CHECK FOR BOUNDS
	beq $a1, $zero, collision_case_1_pt2
	beq $a2, $zero, collision_case_1_pt2
	slt $t2, $a1, $t1
	beq $t2, $zero, collision_case_1_pt2
	slt $t2, $a2, $t0
	beq $t2, $zero, collision_case_1_pt2
	
	move $s2, $s0
	move $s3, $s1
	
	jal putChar_atXY
	
	subi $s5, $s5, 1
	jal update_wallbreaker_hud
	
	addi $a0, $zero, 35000
	jal put_sound
	
	j collision_case_1_pt2

ball_x_too_low:
	add $v0, $zero, $zero
	
	j after_ball_x_too_low
ball_y_too_low:
	add $v1, $zero, $zero
	
	j after_ball_y_too_low

ball_x_too_high:
	add $v0, $zero, $t3
	subi $v0, $v0, 1
	sll $v0, $v0, 6 # restore the return value to the correct units
	
	j after_ball_x_too_high
ball_y_too_high:
	add $v1, $zero, $t2
	addi $v1, $v1, -1
	sll $v1, $v1, 6 # restore the return value to the correct units
	
	j after_ball_y_too_high


speedup_movement:
	sll $s6, $s6, 1
	sll $s7, $s7, 1
	j after_movement_speed_adjustments

slowdown_movement:
	sra $s6, $s6, 1
	sra $s7, $s7, 1
	j after_movement_speed_adjustments
	
	
update_speed_hud:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	bne $s4, $zero, clear_old_speed_hud
	j return_update_speed_hud
clear_old_speed_hud:
	addi $a0, $zero, 0
	addi $a1, $zero, 3
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a1, $zero, 4
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a1, $zero, 5
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a1, $zero, 6
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a1, $zero, 7
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a1, $zero, 8
	addi $a2, $zero, 29
	jal putChar_atXY

	beq $s4, -1, write_slow_speed
	beq $s4, 1, write_fast_speed
write_fast_speed:
	addi $a0, $zero, 17
	addi $a1, $zero, 3
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 13
	addi $a1, $zero, 4
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 26
	addi $a1, $zero, 5
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 27
	addi $a1, $zero, 6
	addi $a2, $zero, 29
	jal putChar_atXY
	
	j return_update_speed_hud
write_slow_speed:
	addi $a0, $zero, 26
	addi $a1, $zero, 3
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 20
	addi $a1, $zero, 4
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 23
	addi $a1, $zero, 5
	addi $a2, $zero, 29
	jal putChar_atXY
	
	addi $a0, $zero, 29
	addi $a1, $zero, 6
	addi $a2, $zero, 29
	jal putChar_atXY
	
	j return_update_speed_hud
return_update_speed_hud:
	lw	$ra, 0($sp)
    	addi 	$sp, $sp, 4
	jr $ra
	
update_wallbreaker_hud:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	beq $s5, $zero, update_wallbreaker_hud_none
	addi $a0, $s5, 7
	addi $a1, $zero, 25
    	addi $a2, $zero, 29
    	jal putChar_atXY
    	lw	$ra, 0($sp)
    	addi 	$sp, $sp, 4
	jr $ra
update_wallbreaker_hud_none:
    	addi $a0, $zero, 30
    	addi $a1, $zero, 25
    	addi $a2, $zero, 29
    	jal putChar_atXY
    	lw	$ra, 0($sp)
    	addi 	$sp, $sp, 4
    	jr $ra
	

game_won:
	addi $a0, $zero, 0xFFFFFFFF
	jal put_leds

	addi $a2, $zero, 0
	lw $s2, n
	lw $s3, k
	addi $a0, $zero, 0
outer_clear_loop:
	beq $a2, $s2, second_stage_game_won # 
	add $a1, $zero, $zero # j
    
inner_clear_loop:
	beq $a1, $s3, increment_clear_loop
    
	jal putChar_atXY
	addi $a1, $a1, 1
    	j inner_clear_loop
increment_clear_loop:
	addi $a2, $a2, 1
	
	j outer_clear_loop
	
	
	
second_stage_game_won:
	addi $a0, $zero, 31
	addi $a1, $zero, 18
	addi $a2, $zero, 12
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 19
	addi $a2, $zero, 12
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 20
	addi $a2, $zero, 12
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 21
	addi $a2, $zero, 12
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 22
	addi $a2, $zero, 12
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 18
	addi $a2, $zero, 14
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 19
	addi $a2, $zero, 14
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 20
	addi $a2, $zero, 14
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 21
	addi $a2, $zero, 14
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 22
	addi $a2, $zero, 14
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 22
	addi $a2, $zero, 13
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 18
	addi $a2, $zero, 13
	jal putChar_atXY
	
	
	addi $a0, $zero, 31
	addi $a1, $zero, 18
	addi $a2, $zero, 15
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 21
	addi $a2, $zero, 15
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 20
	addi $a2, $zero, 17
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 22
	addi $a2, $zero, 18
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 24
	addi $a2, $zero, 15
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 16
	addi $a2, $zero, 13
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 18
	addi $a2, $zero, 10
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 21
	addi $a2, $zero, 10
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 15
	addi $a2, $zero, 11
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 24
	addi $a2, $zero, 11
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 15
	addi $a2, $zero, 17
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 24
	addi $a2, $zero, 9
	jal putChar_atXY
	
	addi $a0, $zero, 31
	addi $a1, $zero, 26
	addi $a2, $zero, 17
	jal putChar_atXY
	
	
	addi $a0, $zero, 2
	addi $a1, $zero, 20
	addi $a2, $zero, 13
	jal putChar_atXY
	j end
	
#---------------------------------------------------------
# rand:  a simple 32-bit xorshift, returns new seed in $v0
#   seed lives in memory word “seed”.  uses only shifts/xor.
#---------------------------------------------------------
rand:
    lw    $t0, seed
    sll   $t1, $t0,  13
    xor   $t0, $t0, $t1
    sra   $t2, $t0,  17
    xor   $t0, $t0, $t2
    sll   $t1, $t0,   5
    xor   $t0, $t0, $t1
    sw    $t0, seed
    move  $v0, $t0
    jr    $ra
	
    ###############################
    # END using infinite loop     #
    ###############################

                        # program may not reach here, but have it for safety
end:
    j   end             # infinite loop "trap" because we don't have syscalls to exit


######## END OF MAIN #################################################################################


## Letter Mappings
# 8: 1
# 9: 2
# 10: 3
# 11: 4
# 12: 5
# 13: A
# 14: B
# 15: D
# 16: E
# 17: F
# 18: H
# 19: K
# 20: L
# 21: M
# 22: N
# 23: O
# 24: P
# 25: R
# 26: S
# 27: T
# 28: U
# 29: W
# 30: 0


.include "procs_board.asm"          # include file with helpful procedures
#.include "procs_mars.asm"
