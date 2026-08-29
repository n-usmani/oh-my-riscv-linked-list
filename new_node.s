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

# temporary main -> **TO BE REMOVED** when testing across files:
# ============================================================
# new_node.s — with test suite
# ============================================================

.data
pass_str:    .asciz "PASS: "
fail_str:    .asciz "FAIL: "
newline:     .asciz "\n"

msg_value:   .asciz "new_node value field"
msg_next:    .asciz "new_node next field"

# ============================================================
# ADD THESE STRINGS to your .data section:
# ============================================================
msg_zero_val:    .asciz "new_node(0) value field"
msg_zero_next:   .asciz "new_node(0) next field"
msg_neg_val:     .asciz "new_node(-1) value field"
msg_neg_next:    .asciz "new_node(-1) next field"
msg_max_val:     .asciz "new_node(max int) value field"
msg_n1_val:      .asciz "node1 value field (after node2 exists)"
msg_n2_val:      .asciz "node2 value field"
msg_addr_diff:   .asciz "node1 and node2 have different addresses"

.text

# ------------------------------------------------------------
# Macro: check_word
#   Compares a word at (base_reg + offset) against an expected
#   immediate value, prints PASS/FAIL + a message.
#
#   %base     - register holding the node's address
#   %offset   - byte offset into the node (0 or 4, etc.)
#   %expected - expected value (immediate)
#   %msg      - label of a .asciiz string describing the test
# ------------------------------------------------------------
.macro check_word (%base, %offset, %expected, %msg)
    lw   t3, %offset(%base)
    li   t4, %expected
    bne  t3, t4, fail

    la   a0, pass_str
    li   a7, 4
    ecall
    j    print_msg

fail:
    la   a0, fail_str
    li   a7, 4
    ecall

print_msg:
    la   a0, %msg
    li   a7, 4
    ecall
    la   a0, newline
    li   a7, 4
    ecall
.end_macro

# ------------------------------------------------------------
main:
    li   a0, 5
    jal  ra, new_node
    mv   t0, a0             # t0 = node address, preserved across checks

    check_word (t0, 0, 5, msg_value)
    check_word (t0, 4, 0, msg_next)
    
    
    # ============================================================
# ADD THESE TEST CALLS into main, after your existing tests:
# ============================================================
 
    # ---- Test: new_node(0) ----
    # Edge case: does storing 0 work the same as any other value,
    # or does something (incorrectly) treat 0 as a special/null case?
    li   a0, 0
    jal  ra, new_node
    mv   t1, a0
    check_word (t1, 0, 0, msg_zero_val)
    check_word (t1, 4, 0, msg_zero_next)
 
    # ---- Test: new_node(-1) ----
    # Edge case: negative values. Confirms the value field isn't
    # accidentally treated as unsigned somewhere in storage/retrieval.
    li   a0, -1
    jal  ra, new_node
    mv   t1, a0
    check_word (t1, 0, -1, msg_neg_val)
    check_word (t1, 4, 0, msg_neg_next)
 
    # ---- Test: new_node(largest 32-bit int) ----
    # Edge case: a value near the boundary of what a word can hold.
    li   a0, 2147483647
    jal  ra, new_node
    mv   t1, a0
    check_word (t1, 0, 2147483647, msg_max_val)
 
    # ---- Test: two nodes allocated back-to-back don't clobber each other ----
    # This is the most important edge case for new_node specifically:
    # does calling it twice in a row give two independent, correctly
    # separated pieces of memory, or does the second call overwrite
    # data the first call already wrote?
    li   a0, 111
    jal  ra, new_node
    mv   t1, a0             # t1 = node1's address
 
    li   a0, 222
    jal  ra, new_node
    mv   t2, a0             # t2 = node2's address
 
    check_word (t1, 0, 111, msg_n1_val)   # node1 should be untouched
    check_word (t2, 0, 222, msg_n2_val)   # node2 should hold its own value
 
    # Confirms the two addresses aren't the same memory (a real bug
    # would be sbrk returning the same address twice, silently
    # overwriting node1 when node2 is created)
    beq  t1, t2, addr_fail
    la   a0, pass_str
    li   a7, 4
    ecall
    j    addr_done
addr_fail:
    la   a0, fail_str
    li   a7, 4
    ecall
addr_done:
    la   a0, msg_addr_diff
    li   a7, 4
    ecall
    la   a0, newline
    li   a7, 4
    ecall

    # exit cleanly:
    li   a7, 10
    ecall

# ------------------------------------------------------------

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
