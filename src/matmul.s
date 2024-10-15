.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    bge zero, a1, error72
    bge zero, a2, error72
    bge zero, a4, error73
    bge zero, a5, error73
    bne a2, a4, error74
    
    

    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2 8(sp)
    sw ra, 12(sp)

    mv s0, zero
    mv s2, a6

outer_loop_start:
    beq s0, a1, outer_loop_end
   
    mv s1, zero

inner_loop_start:
    beq s1, a5, inner_loop_end
    
    mul t0, s0, a2
    slli t0, t0, 2
    slli t1, s1, 2
    
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    
    add a0, a0, t0
    add a1, a3, t1
    li a3, 1
    mv a4, a5
    
    jal dot
    sw a0, 0(s2)
    addi s2, s2, 4

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    addi sp, sp, 24
    
    addi s1, s1, 1
    j inner_loop_start

inner_loop_end:
    
    addi s0, s0, 1
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    
    ret
    
error72:
    li a1, 72
    j exit2

error73:
    li a1, 73
    j exit2

error74:
    li a1, 74
    j exit2
