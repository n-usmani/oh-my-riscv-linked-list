# ============================================================
# main.s
#
# Purpose: Test driver for merge_linked_lists — builds two
#          lists via new_node, merges them, and prints the
#          result via print_list.
#
# Expect: 1 2 3 4
# ============================================================

.globl main

.data
headA: .word 0        # starts NULL; set at runtime once nodeA1 exists


.text
main:
    # ---- Build list A: 1 -> 3 -> NULL ----
    li   a0, 3
    jal  ra, new_node
    mv   s4, a0          # s4 = nodeA2

    li   a0, 1
    jal  ra, new_node    # a0 = nodeA1
    sw   s4, 4(a0)        # nodeA1->next = nodeA2

    la   t0, headA          # sw can't target a label directly —
    sw   a0, 0(t0)            # load its address first, then store

    # ---- Build list B: 2 -> 4 -> NULL ----
    li   a0, 4
    jal  ra, new_node
    mv   s4, a0           # s4 = nodeB2

    li   a0, 2
    jal  ra, new_node     # a0 = nodeB1
    sw   s4, 4(a0)         # nodeB1->next = nodeB2
    mv   s5, a0             # s5 = nodeB1 (head of list B)

    # ---- Merge B into A ----
    la   a0, headA
    mv   a1, s5
    jal  ra, merge_linked_lists

    # ---- Print the result ----
    lw   a0, headA
    jal  ra, print_list

    li   a7, 10
    ecall
