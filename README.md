# RISC-V Linked List

A singly linked list implemented in RISC-V assembly (RARS). A fully-working implementation of 
the whole module was first written and tested in C; then I wrote each one in assembly.

## Functions

- `new_node(a0: value) -> a0: pointer to new node`
- `print_list(a0: head pointer)`
- `insert_sorted(a0: node to insert, a1: pointer to head pointer)`
- `merge_linked_lists(a0: pointer to head pointer of A, a1: head pointer of B)`

(See each file's header for full details.)

## Running

1. Open all `.asm` files in RARS.
2. In Settings, enable **Assemble all files currently open**.
3. Assemble, then run `main.asm` (or your own file).

## Testing

- Each function has its own test suite (single test, followed by 10+ edge cases).
- There's also a rather extensive `main` file that tests lots of cases using all four functions together.

## Merging a List with Itself

- When you try to merge a list with itself, it results in an infinite loop! No crashes or bugs, though.
- This is not currently guarded against, so beware this case.

## C reference

- `linked_list.c` is the original C implementation (written by me).
- This was used to thoroughly test the algorithm before implementing it in assembly.

## Development Notes / AI Usage

- Code for `merge_linked_lists.asm`, `insert_sorted.asm`, `new_node.asm`, `print_list.asm` was written by ME (naaira)
- Code for `linked_list.c` was also written by ME
- All logic and fixes were my decisions
- Claude was used as a debugging and testing aide in the following ways:
  - Writing code for test suites per my specific instructions
    - This includes the extensive test suite in `main.asm`
    - Most tests were decided by me; I suggested several of them to target iffy edge cases
  - Finding bugs
  - Brainstorming fixes for bugs >> I made decisions based on my mental spec and my C implementation
- **`NOTES.md** documents many of the decisions, bugs, and testing sessions
