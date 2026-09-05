# ============================================================
# insert_sorted.s
#
# Purpose: Inserts a node into a sorted linked list, at the
#          correct position.
#
# Arguments:
#   a0 = pointer to the node to insert
#   a1 = pointer to a pointer to the head (Node **head)
#
# Returns: (none)
# ============================================================

# ====== REGISTERS LOG ========
# a0 = pointer to new node (*)
# a1 = pointer TO address of list head
#
# t0 = target ( )
# t1 = pointer_to_update (**)
# t2 = current (*)
# t3 = current->value ( )
# t4 = temp register for updating pointer_to_update [t1] 
# t5 = the pointer stored at pointer_to_update's value


insert_sorted:
	lw t0, 0(a0) # target = node->value
	mv t1, a1 # pointer_to_update
	lw t2, 0(t1) # current
	
	loop2:
		
		beqz t2, first_if # if current is NULL...
		lw t3, 0(t2)# current->value [now safe to do, since NULL case has been checked in previous line]
		bge t3, t0, first_if # if current->value >= target...
		
		# updates for next loop cycle =======
		
		# updating pointer_to_update
		mv t4, t2 # copy current somewhere temporary
		addi t4, t4, 4 # add 4 to it to get the address OF the next field
		mv t1, t4 # put that into t1, which is pointer_to_update
		
		# updating current
		lw t2, 4(t2)
		
		# if we've gotten this far, then repeat loop!
		j loop2
	
	first_if:
		sw a0, 0(t1) # pointer_to_update = &node
		sw t2, 4(a0) # node->next = current
		
		ret
		
		
		#lw t5, 0(t1) # save pointer_to_update's value
		#mv t5, a0 # set it to be new node's address
		
		
		