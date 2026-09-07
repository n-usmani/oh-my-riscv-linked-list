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
pass_str: .asciz "PASS: "
fail_str: .asciz "FAIL: "

headA: .word 0        # starts NULL; set at runtime once nodeA1 exists

msgA: .asciz "Test A (build via repeated insert_sorted) expect '1 3 5 8': "
msgB: .asciz "\nTest B (merge into empty A) expect '10 20': "
msgC: .asciz "\nTest C (merge empty B into A) expect '7 9': "
msgD: .asciz "\nTest D (duplicates across both lists) expect '3 3 3 3': "
msgE: .asciz "\nTest E (negative values via insert_sorted) expect '-5 -3 -1': "
msgF: .asciz "\nTest F (10-node list via sequential inserts) expect '1 2 3 4 5 6 7 8 9 10': "
msgG: .asciz "\nTest G (merge where B's min < A's head) expect '0 1 2': "
msgH: .asciz "\nTest H (min/max int range across merge) expect small-to-large sorted: "
msgI: .asciz "\nTest I (three-way chained merge A+B, then +C) expect '1 2 3 4 5 6': "
msgJ: .asciz "\nTest J (two single-node lists merged) expect '4 9': "
headEmpty: .word 0     # reused as a scratch "empty list" head across tests
msgK: .asciz "\nTest K (both lists genuinely empty) expect nothing: "
msgL: .asciz "\nTest L (empty A, multi-node B, 3+ nodes) expect '1 2 3': "
msgM: .asciz "\nTest M (non-trivial A, NULL B) expect '1 2 3 4 5': "
msgN: .asciz "\nTest N (WARNING: self-merge, list into itself) risk of infinite loop/corruption: "
msgO: .asciz "\nTest O (insert_sorted, node's next field has garbage before insert) expect '3 5 9': "
msgP: .asciz "\nTest P (10 descending inserts, repeated head-replacement) expect '11 12 13 14 15 16 17 18 19 20': "


.text
main:  
        # ---- Test A: build a list purely via repeated insert_sorted ----
    la   a0, msgA
    li   a7, 4
    ecall
    la   t0, headEmpty      # reset scratch head to NULL for this test
    sw   x0, 0(t0)
    li   a0, 5
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 3
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 8
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 1
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    lw   a0, headEmpty
    jal  ra, print_list
    
        # ---- Test B: merge two nodes into a genuinely empty A ----
    la   a0, msgB
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 20
    jal  ra, new_node
    mv   s6, a0
    li   a0, 10
    jal  ra, new_node
    sw   s6, 4(a0)
    mv   s7, a0              # s7 = head of list B (10 -> 20)
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
 
        # ---- Test C: merge NULL list B into a non-empty A ----
    la   a0, msgC
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 9
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 7
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    la   a0, headEmpty
    li   a1, 0                # list B = NULL
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
        # ---- Test D: duplicates spread across both lists ----
    la   a0, msgD
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 3
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 3
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 3
    jal  ra, new_node
    mv   s6, a0                  # list B node 1
    li   a0, 3
    jal  ra, new_node
    sw   s6, 4(a0)
    mv   s7, a0                    # s7 = head of list B (3 -> 3)
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
        # ---- Test E: negative values via insert_sorted ----
    la   a0, msgE
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, -1
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, -5
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, -3
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    lw   a0, headEmpty
    jal  ra, print_list
    
        # ---- Test F: 10-node list, stresses insert_sorted's loop ----
    la   a0, msgF
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   s5, 1
    insertF_loop:
    	mv   a0, s5
    	jal  ra, new_node
    	la   a1, headEmpty
    	jal  ra, insert_sorted
    	addi s5, s5, 1
    	li   t1, 10
    	ble  s5, t1, insertF_loop
    	lw   a0, headEmpty
    	jal  ra, print_list
    
    
        # ---- Test G: merge where B's minimum value is smaller than A's head
    # (this is the case that required the Node** fix — worth confirming
    # the head genuinely gets replaced, not just left broken) ----
    la   a0, msgG
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 1
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 2
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted        # A: 1 2
    li   a0, 0
    jal  ra, new_node
    mv   s7, a0                    # B: just 0, smaller than A's head
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
        # ---- Test H: min/max int boundary values across a merge ----
    la   a0, msgH
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 0
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, -2147483648
    jal  ra, new_node
    mv   s7, a0
    li   a0, 2147483647
    jal  ra, new_node
    sw   a0, 4(s7)              # s7->next = max int node (min -> max)
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test I: chained merges — merge A+B, then merge that result with C ----
    la   a0, msgI
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 1
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 4
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted        # A: 1 4
    li   a0, 5
    jal  ra, new_node
    mv   s6, a0
    li   a0, 2
    jal  ra, new_node
    sw   s6, 4(a0)
    mv   s7, a0                    # B: 2 -> 5
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists    # A now: 1 2 4 5
    li   a0, 6
    jal  ra, new_node
    mv   s6, a0
    li   a0, 3
    jal  ra, new_node
    sw   s6, 4(a0)
    mv   s7, a0                    # C: 3 -> 6
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists    # A now: 1 2 3 4 5 6
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test J: two single-node lists merged ----
    la   a0, msgJ
    li   a7, 4
    ecall
    li   a0, 9
    jal  ra, new_node
    la   t0, headEmpty
    sw   a0, 0(t0)
    li   a0, 4
    jal  ra, new_node
    mv   s7, a0
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test K: both A and B genuinely empty ----
    # Directly exercises the untested combination: merge_linked_lists
    # hits return_B (A is NULL), then INSIDE return_B, hits its own
    # beqz a1, return_A check (B is also NULL) — a path no prior test
    # has reached, since every earlier "empty A" test (B) had a
    # non-empty B, and every earlier "empty B" test (C) had a
    # non-empty A.
    la   a0, msgK
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    la   a0, headEmpty
    li   a1, 0
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test L: empty A, multi-node B (3+ nodes) ----
    # Test B only checked a 2-node B. This confirms return_B's
    # direct pointer-redirect (sw a1, 0(a0)) preserves B's ENTIRE
    # chain, not just the first node/link.
    la   a0, msgL
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 3
    jal  ra, new_node
    mv   s6, a0
    li   a0, 2
    jal  ra, new_node
    sw   s6, 4(a0)
    mv   s7, a0
    li   a0, 1
    jal  ra, new_node
    sw   s7, 4(a0)
    mv   s7, a0                    # s7 = head of B (1 -> 2 -> 3)
    la   a0, headEmpty
    mv   a1, s7
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test M: non-trivial A (5 nodes), NULL B ----
    # Directly exercises the EARLY beqz a1, return_A check (before
    # the loop even starts) with a non-trivial A, confirming A is
    # left completely unchanged by a no-op merge.
    la   a0, msgM
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   s5, 1
  insertM_loop:
    mv   a0, s5
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    addi s5, s5, 1
    li   t1, 5
    ble  s5, t1, insertM_loop
    la   a0, headEmpty
    li   a1, 0
    jal  ra, merge_linked_lists
    lw   a0, headEmpty
    jal  ra, print_list
 
 
     # ---- Test N: self-merge — list merged into itself ----
    # WARNING: this is expected to potentially misbehave (infinite
    # loop or corruption), per the aliasing concern raised — the
    # function was never designed to handle A and B being the same
    # list. If RARS hangs here, that CONFIRMS the suspected bug;
    # stop execution and treat this as a documented, known
    # limitation rather than something to "fix" blindly.
    
    # *** NOTE: removed contents of Test N to NOTES.md file to prevent infinite loop during the rest of testing. ***
    
    
        # ---- Test O: insert_sorted with a garbage (non-NULL, non-zero)
    # value already sitting in the new node's next field ----
    # insert_sorted should unconditionally overwrite next regardless
    # of what was there before — this confirms that assumption.
    la   a0, msgO
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   a0, 5
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 9
    jal  ra, new_node
    li   t2, 999999             # garbage, definitely not a real address
    sw   t2, 4(a0)                 # manually corrupt next BEFORE inserting
    la   a1, headEmpty
    jal  ra, insert_sorted
    li   a0, 3
    jal  ra, new_node
    li   t2, -1                  # different garbage pattern
    sw   t2, 4(a0)
    la   a1, headEmpty
    jal  ra, insert_sorted
    lw   a0, headEmpty
    jal  ra, print_list
    
    
        # ---- Test P: 10 descending inserts — repeated head-replacement ----
    # Test G proved head-replacement works ONCE. This proves it holds
    # up correctly across many consecutive replacements in a row.
    la   a0, msgP
    li   a7, 4
    ecall
    la   t0, headEmpty
    sw   x0, 0(t0)
    li   s5, 20
insertP_loop:
    mv   a0, s5
    jal  ra, new_node
    la   a1, headEmpty
    jal  ra, insert_sorted
    addi s5, s5, -1
    li   t1, 11
    bge  s5, t1, insertP_loop
    lw   a0, headEmpty
    jal  ra, print_list


    # exit cleanly:
    li   a7, 10
    ecall
    
# *** END OF FILE ***
