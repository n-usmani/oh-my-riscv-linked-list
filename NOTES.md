# Linked List Library in Assembly Language (RISC-V)

## Progress / Observations / Mistakes
- Wrote a copy of the same program in C first to ensure correctness of algorithm
- Ran test suite 1 with 9 tests, all passed
- Ran more comprehensive test suite with 7 more tests, found a bug
- If list A's first element is not the smallest, then the insertion of list B's smaller element is incorrect (e.g. list A is 4 > 5 > 8, trying to insert 1 will yield 4 > 1 > 5 > 8)

- For memory: choosing to go with `sbrk`
    
### print_list.asm
- iterating: when to check for null? probably when it's reached said node
- this would be in the form of a check for 0, but what if a node just happens to be storing 0?? that's not null.
- nevermind; just have to check the current node pointer address, not go there and look at the next field
- print_list adds a space between node values, no trailing new line
- first test passed; having Claude write 10-test suite to target standard and edge cases until function breaks
- 10-test suite passed. Outputs:
        ```Test 1 (empty list) expect nothing: 
        Test 2 (single node) expect '42': 42 
        Test 3 (contains zero) expect '5 0 7': 5 0 7 
        Test 4 (negatives) expect '-3 -1 4': -3 -1 4 
        Test 5 (duplicates) expect '2 2 2': 2 2 2 
        Test 6 (10 nodes) expect '1 2 3 4 5 6 7 8 9 10': 1 2 3 4 5 6 7 8 9 10 
        Test 7 (max int) expect '2147483647': 2147483647 
        Test 8 (min int) expect '-2147483648': -2147483648 
        Test 9a (list A) expect '100 200': 100 200 
        Test 9b (list B, right after A) expect '300 400 500': 300 400 500 
        Test 10 (out-of-order memory layout) expect '9 8': 9 8 ```

### insert_sorted.asm
- 8-test suite passed 09/05/2026 2:13 PM PST:
        ```Test 1 (insert into empty list) expect '5': 5 
        Test 2 (insert at head, smaller than existing) expect '1 10': 1 10 
        Test 3 (insert in middle) expect '1 3 5': 1 3 5 
        Test 4 (insert at tail) expect '1 2 9': 1 2 9 
        Test 5 (multiple duplicates smaller than new node) expect '2 2 2 7': 2 2 2 7 
        Test 6 (new node smaller than all duplicates) expect '4 6 6 6': 4 6 6 6 
        Test 7 (insert negative into list of positives) expect '-5 1 2': -5 1 2 
        Test 8 (single-node list, new node equal value) expect '4 4': 4 4 ```
- Third round of testing results:
        ```Test 9 (3 sequential inserts) expect '5 10 20 30 40': 5 10 20 30 40 
        Test 10 (max int into large-value list) expect '100 2000000000 2147483647': 100 2000000000 2147483647 
        Test 11 (insert into 10-node list) expect '1 3 5 7 9 10 11 13 15 17 19': 1 3 5 7 9 10 11 13 15 17 19```

### merge_linked_lists.asm
- [Note added later] Tried 10-test suite: Test B not only failed, but crashed the program
    - Error message: `Error in print_list.asm line 22: Runtime exception at 0x004001c0: Load address not aligned to word boundary 0x0000000a`
    - This was due to a one-step-too-far dereference of List B's head pointer in the return_B case
       in `merge_linked_lists.asm` (used when list A is empty but list B is not)
    - Used the register itself instead of going TO the address stored in the register and it started 
      working smoothly as you can see below ↓ ↓ ↓
- 10-test suite passed. Results:
        ```Test A (build via repeated insert_sorted) expect '1 3 5 8': 1 3 5 8 
    Test B (merge into empty A) expect '10 20': 10 20 
    Test C (merge empty B into A) expect '7 9': 7 9 
    Test D (duplicates across both lists) expect '3 3 3 3': 3 3 3 3 
    Test E (negative values via insert_sorted) expect '-5 -3 -1': -5 -3 -1 
    Test F (10-node list via sequential inserts) expect '1 2 3 4 5 6 7 8 9 10': 1 2 3 4 5 6 7 8 9 10 
    Test G (merge where B's min < A's head) expect '0 1 2': 0 1 2 
    Test H (min/max int range across merge) expect small-to-large sorted: -2147483648 0 2147483647 
    Test I (three-way chained merge A+B, then +C) expect '1 2 3 4 5 6': 1 2 3 4 5 6 
    Test J (two single-node lists merged) expect '4 9': 4 9 ```
- Next 6 tests. One (Test N) unearthed a known limitation! See bottom of file. But here are the rest:
        ```Test K (both lists genuinely empty) expect nothing: 
    Test L (empty A, multi-node B, 3+ nodes) expect '1 2 3': 1 2 3 
    Test M (non-trivial A, NULL B) expect '1 2 3 4 5': 1 2 3 4 5 
    Test O (insert_sorted, node's next field has garbage before insert) expect '3 5 9': 3 5 9 
    Test P (10 descending inserts, repeated head-replacement) expect '11 12 13 14 15 16 17 18 19 20': 11 12 13 14 15 16 17 18 19 20 ```

## Special/Interesting Cases
### Merging a List with Itself
- Attempting to merge a list with itself results in an infinite loop. No crashes or bugs.
