.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
  
    mv a1, s0
    mv a2, zero
    jal fopen
    li t0, -1
    beq a0, t0, error90
    mv s3, a0
    
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error91

    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error91

    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t2, t0, t1
    slli t2, t2, 2
    mv a0, t2
    jal malloc
    beq a0, zero, error88
    mv s4, a0
    
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t1, t1, t2
    slli t1, t1, 2
    
    mv a1, s3
    mv a2, s4
    mv a3, t1
    jal fread
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t1, t1, t2
    slli t1, t1, 2
    bne a0, t1, error91
    
    mv a1, s3
    jal fclose
    bne a0, zero, error92
    
    mv a0, s4
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)  
	addi sp, sp, 24
    ret

error88:
    li a1, 88
    j exit2

error90:
    li a1, 90
    j exit2
    
error91:
    li a1, 91
    j exit2
    
error92:
    li a1, 92
    j exit2
    