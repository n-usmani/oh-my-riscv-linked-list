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

# ============================================================
# Paste this ABOVE print_list.s
#
# Builds a 3-node list (1 -> 2 -> 3 -> NULL) by hand, directly
# in .data, so this test doesn't depend on new_node working —
# keeps print_list's test isolated to just print_list itself.
# ============================================================

.data
node1: .word 1          # value = 1
       .word node2      # next = address of node2
node2: .word 2          # value = 2
       .word node3      # next = address of node3
node3: .word 3          # value = 3
       .word 0          # next = NULL

.text
main:
    la   a0, node1       # a0 = head pointer (address of node1)
    jal  ra, print_list

    li   a7, 10           # exit
    ecall

# ============================================================
# print_list goes here, unchanged
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
		li a7, 11
		ecall
	
		# move up the chain
		lw t0, 4(t0)
	
		j loop
	
	exit:
		ret