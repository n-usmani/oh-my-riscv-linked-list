# ============================================================
# merge_linked_lists.s
#
# Purpose: Merges two sorted linked lists into one sorted list.
#
# Arguments:
#   a0 = pointer to a pointer to list A's head (Node **a)
#   a1 = pointer to head of list B (Node *b)
#
# Returns: (none) — merged result accumulates into list A,
#          reachable via the same pointer passed in a0
# ============================================================

# ====== REGISTERS LOG ========
# a0 = pointer to address OF head of list A (**)
# a1 = pointer to head of list B (*)
#
# s0 = pointer to head of list A (*)
# s1 = current (*)
# s2 = temp ( )
# s3 = address of list B first node (*)

merge_linked_lists:
	# save 4 registers values (i am a callee at present.) ~~~
	addi sp, sp, -20
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw ra, 16(sp) 
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	lw s0, 0(a0) # pointer to list A head
	beqz s0, return_B # if list A NULL, branch out!
	beqz a1, return_A # if list B NULL, branch out
	
	mv s1, a1 # current = list_B_head
	mv s2, x0 # temp = 0
	
	loop3:
		beqz s1, return_A # if current == NULL, branch to return_A
		
		lw s2, 4(s1) # temp = current->next
		
		# CALLING INSERT_SORTED ~~~~~~~~
		addi sp, sp, -12
		sw a0, 0(sp)
		sw a1, 4(sp)
		sw ra, 8(sp)
		
		mv a1, a0 # a1 = double pointer to list A head (**) (list we wanna insert into)
		mv a0, s1 # a0 = current node (to be inserted)
		
		jal ra, insert_sorted
		
		lw ra, 8(sp)
		lw a1, 4(sp)
		lw a0, 0(sp)
		addi sp, sp, 12
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		mv s1, s2 # current = temp
		
		j loop3
	
	return_B:
		beqz a1, return_A # if list B NULL, branch to return_A
		
		lw s3, 0(a1) # load address of list B's first node
		sw s3, 0(a0) # list A head now points to list B first item.
	
	return_A:
		lw ra, 16(sp)
		lw s3, 12(sp)
		lw s2, 8(sp)
		lw s1, 4(sp)
		lw s0, 0(sp)
		addi sp, sp, 20
		
		ret
	
	
	
