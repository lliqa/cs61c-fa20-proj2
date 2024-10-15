.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    
    bge zero, a1, error77

    # Prologue
    
    mv t0, x0
    mv t1, x0
    lw t2, 0(a0)

loop_start:
    beq t0, a1, loop_end
    lw t3, 0(a0)
    
    bge t2, t3, loop_continue
    mv t1, t0
    mv t2, t3

loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start

loop_end:
    mv a0, t1

    # Epilogue


    ret

error77:
    li a1, 77
    j exit2