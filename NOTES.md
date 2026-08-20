# Linked List Library in Assembly Language (RISC-V)

## Progress / Observations / Mistakes
    - Wrote a copy of the same program in C first to ensure correctness of algorithm
    - Ran test suite 1 with 9 tests, all passed
    - Ran more comprehensive test suite with 7 more tests, found a bug
        - If list A's first element is not the smallest, then the insertion of list B's smaller element is incorrect (e.g. list A is 4 > 5 > 8, trying to insert 1 will yield 4 > 1 > 5 > 8)