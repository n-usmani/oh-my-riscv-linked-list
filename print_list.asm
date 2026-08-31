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
# THIS TEST SUITE WAS WRITTEN BY CLAUDE. The function was written by me.
#
# Each test prints a label first, then the list's output, then
# a newline — so you can visually confirm actual vs. expected.
# No automatic PASS/FAIL here since print_list has no return
# value to check against; this is eyeball verification, same
# spirit as your C suite's early "expect '1 2 3'" tests.
# ============================================================

.data
# ---- Test 1: empty list (head = NULL) ----
msg1: .asciz "Test 1 (empty list) expect nothing: "

# ---- Test 2: single node ----
msg2: .asciz "\nTest 2 (single node) expect '42': "
t2n1: .word 42
      .word 0

# ---- Test 3: list containing a zero value ----
msg3: .asciz "\nTest 3 (contains zero) expect '5 0 7': "
t3n1: .word 5
      .word t3n2
t3n2: .word 0
      .word t3n3
t3n3: .word 7
      .word 0

# ---- Test 4: list with negative values ----
msg4: .asciz "\nTest 4 (negatives) expect '-3 -1 4': "
t4n1: .word -3
      .word t4n2
t4n2: .word -1
      .word t4n3
t4n3: .word 4
      .word 0

# ---- Test 5: duplicate values ----
msg5: .asciz "\nTest 5 (duplicates) expect '2 2 2': "
t5n1: .word 2
      .word t5n2
t5n2: .word 2
      .word t5n3
t5n3: .word 2
      .word 0

# ---- Test 6: larger list, stresses loop iteration count ----
msg6: .asciz "\nTest 6 (10 nodes) expect '1 2 3 4 5 6 7 8 9 10': "
t6n1: .word 1
      .word t6n2
t6n2: .word 2
      .word t6n3
t6n3: .word 3
      .word t6n4
t6n4: .word 4
      .word t6n5
t6n5: .word 5
      .word t6n6
t6n6: .word 6
      .word t6n7
t6n7: .word 7
      .word t6n8
t6n8: .word 8
      .word t6n9
t6n9: .word 9
      .word t6n10
t6n10: .word 10
       .word 0

# ---- Test 7: max int value ----
msg7: .asciz "\nTest 7 (max int) expect '2147483647': "
t7n1: .word 2147483647
      .word 0

# ---- Test 8: min int value (most negative) ----
msg8: .asciz "\nTest 8 (min int) expect '-2147483648': "
t8n1: .word -2147483648
      .word 0

# ---- Test 9: two lists printed back-to-back, confirm no state leaks between calls ----
msg9a: .asciz "\nTest 9a (list A) expect '100 200': "
t9a1: .word 100
      .word t9a2
t9a2: .word 200
      .word 0
msg9b: .asciz "\nTest 9b (list B, right after A) expect '300 400 500': "
t9b1: .word 300
      .word t9b2
t9b2: .word 400
      .word t9b3
t9b3: .word 500
      .word 0

# ---- Test 10: nodes NOT laid out in memory in list order
# (t10n2 declared before t10n1 in memory, but list order is 1 -> 2)
# confirms traversal follows next pointers, not memory address order ----
msg10: .asciz "\nTest 10 (out-of-order memory layout) expect '9 8': "
t10n2: .word 8
       .word 0
t10n1: .word 9
       .word t10n2


.text
main:
    # ---- Test 1 ----
    la   a0, msg1
    li   a7, 4
    ecall
    li   a0, 0             # NULL head
    jal  ra, print_list

    # ---- Test 2 ----
    la   a0, msg2
    li   a7, 4
    ecall
    la   a0, t2n1
    jal  ra, print_list

    # ---- Test 3 ----
    la   a0, msg3
    li   a7, 4
    ecall
    la   a0, t3n1
    jal  ra, print_list

    # ---- Test 4 ----
    la   a0, msg4
    li   a7, 4
    ecall
    la   a0, t4n1
    jal  ra, print_list

    # ---- Test 5 ----
    la   a0, msg5
    li   a7, 4
    ecall
    la   a0, t5n1
    jal  ra, print_list

    # ---- Test 6 ----
    la   a0, msg6
    li   a7, 4
    ecall
    la   a0, t6n1
    jal  ra, print_list

    # ---- Test 7 ----
    la   a0, msg7
    li   a7, 4
    ecall
    la   a0, t7n1
    jal  ra, print_list

    # ---- Test 8 ----
    la   a0, msg8
    li   a7, 4
    ecall
    la   a0, t8n1
    jal  ra, print_list

    # ---- Test 9 ----
    la   a0, msg9a
    li   a7, 4
    ecall
    la   a0, t9a1
    jal  ra, print_list

    la   a0, msg9b
    li   a7, 4
    ecall
    la   a0, t9b1
    jal  ra, print_list

    # ---- Test 10 ----
    la   a0, msg10
    li   a7, 4
    ecall
    la   a0, t10n1
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
		li a7, 11
		ecall
	
		# move up the chain
		lw t0, 4(t0)
	
		j loop
	
	exit:
		ret