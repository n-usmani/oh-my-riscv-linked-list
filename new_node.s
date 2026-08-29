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
    
    # testing if print even works
    li a7, 4
    la a0, pass_str
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
