# ============================================================
# new_node.s
#
# Purpose: Allocates memory for a new linked-list node,
#          initializes its value and next fields, and
#          returns a pointer to it.
#
# Inputs/Arguments: a0 = value
#
# Returns: a0 = pointer to new node
# ============================================================

.globl new_node

new_node:
	mv t0, a0
	
	# get the memory
	li a0, 8 # we'll need 8 bytes of memory
	li a7, 9 # sbrk
	ecall
	
	# store value into the node
	sw t0, 0(a0)
	
	# fill next field with NULL (0)
	sw x0, 4(a0)
	
	ret
