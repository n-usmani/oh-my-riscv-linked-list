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

#***
# ============================================================
# insert_sorted extended test suite
# Paste .data block into your .data section, and the main-body
# block into main. Each test prints a label, then the resulting
# list via print_list, so you can visually confirm.
# ============================================================

.data
msg1: .asciz "Test 1 (insert into empty list) expect '5': "
head1: .word 0              # empty list — head starts as NULL
newnode1: .word 5
          .word 0

msg2: .asciz "\nTest 2 (insert at head, smaller than existing) expect '1 10': "
head2: .word node2a
node2a: .word 10
        .word 0
newnode2: .word 1
          .word 0

msg3: .asciz "\nTest 3 (insert in middle) expect '1 3 5': "
head3: .word node3a
node3a: .word 1
        .word node3b
node3b: .word 5
        .word 0
newnode3: .word 3
          .word 0

msg4: .asciz "\nTest 4 (insert at tail) expect '1 2 9': "
head4: .word node4a
node4a: .word 1
        .word node4b
node4b: .word 2
        .word 0
newnode4: .word 9
          .word 0

msg5: .asciz "\nTest 5 (multiple duplicates smaller than new node) expect '2 2 2 7': "
head5: .word node5a
node5a: .word 2
        .word node5b
node5b: .word 2
        .word node5c
node5c: .word 2
        .word 0
newnode5: .word 7
          .word 0

msg6: .asciz "\nTest 6 (new node smaller than all duplicates) expect '4 6 6 6': "
head6: .word node6a
node6a: .word 6
        .word node6b
node6b: .word 6
        .word node6c
node6c: .word 6
        .word 0
newnode6: .word 4
          .word 0

msg7: .asciz "\nTest 7 (insert negative into list of positives) expect '-5 1 2': "
head7: .word node7a
node7a: .word 1
        .word node7b
node7b: .word 2
        .word 0
newnode7: .word -5
          .word 0

msg8: .asciz "\nTest 8 (single-node list, new node equal value) expect '4 4': "
head8: .word node8a
node8a: .word 4
        .word 0
newnode8: .word 4
          .word 0


.text
main:
    # ---- Test 1 ----
    la   a0, msg1
    li   a7, 4
    ecall
    la   a0, newnode1
    la   a1, head1
    jal  ra, insert_sorted
    lw   a0, head1
    jal  ra, print_list

    # ---- Test 2 ----
    la   a0, msg2
    li   a7, 4
    ecall
    la   a0, newnode2
    la   a1, head2
    jal  ra, insert_sorted
    lw   a0, head2
    jal  ra, print_list

    # ---- Test 3 ----
    la   a0, msg3
    li   a7, 4
    ecall
    la   a0, newnode3
    la   a1, head3
    jal  ra, insert_sorted
    lw   a0, head3
    jal  ra, print_list

    # ---- Test 4 ----
    la   a0, msg4
    li   a7, 4
    ecall
    la   a0, newnode4
    la   a1, head4
    jal  ra, insert_sorted
    lw   a0, head4
    jal  ra, print_list

    # ---- Test 5 ----
    la   a0, msg5
    li   a7, 4
    ecall
    la   a0, newnode5
    la   a1, head5
    jal  ra, insert_sorted
    lw   a0, head5
    jal  ra, print_list

    # ---- Test 6 ----
    la   a0, msg6
    li   a7, 4
    ecall
    la   a0, newnode6
    la   a1, head6
    jal  ra, insert_sorted
    lw   a0, head6
    jal  ra, print_list

    # ---- Test 7 ----
    la   a0, msg7
    li   a7, 4
    ecall
    la   a0, newnode7
    la   a1, head7
    jal  ra, insert_sorted
    lw   a0, head7
    jal  ra, print_list

    # ---- Test 8 ----
    la   a0, msg8
    li   a7, 4
    ecall
    la   a0, newnode8
    la   a1, head8
    jal  ra, insert_sorted
    lw   a0, head8
    jal  ra, print_list

    li   a0, '\n'
    li   a7, 11
    ecall

    li   a7, 10
    ecall

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

#***

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
		
		
		