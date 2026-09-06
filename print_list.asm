# ============================================================
# print_list.s
#
# Purpose: Traverses a linked list and prints each node's
#          value field.
#
# Arguments: a0 = head pointer
#
# Returns: (none)
# ============================================================

print_list:
	mv t0, a0
	
	loop:
		beq x0, t0, exit # exit if the current pointer is 0
	
	
		# print current node's value
		lw a0, 0(t0)
		li a7, 1
		ecall
		
		# add a space
		li a0, ' '
		li a7, 11 # print character service number
		ecall
	
		# move up the chain
		lw t0, 4(t0)
	
		j loop
	
	exit:
		ret