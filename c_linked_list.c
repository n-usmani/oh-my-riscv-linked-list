#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

struct Node {
    int value;
    struct Node *next;
};

typedef struct Node Node;

Node* new_node(int num) {
    Node *n = malloc(sizeof(Node));
    n->value = num;
    n->next = NULL;
    return n;
}

void print_list(Node* head) {
    if (head != NULL) {
        printf("%d", head->value);
        print_list(head->next);
    }
}

void insert_sorted(Node *n, Node *head) {
    // traverse linked list until find element geq to target
    int target = n->value;
    Node **pointer_to_update = &(head->next); // address of ptr
    Node *current = head->next;

    while (1) {
        if (current == NULL || current->value >= target) {
            *pointer_to_update = n;
            n->next = current;
            break;
        } else {
            pointer_to_update = &(current->next);
            current = current->next;
        }
    }
}

Node* merge_linked_lists(Node *a, Node *b) {
    // if either list is empty, return the other
    if (a == NULL) {
        return b;
    } else if (b == NULL) {
        return a;
    }

    Node *current = b;
    Node *temp = NULL;

    while (1) {
        if (current == NULL) { break; }

        temp = current->next;
        insert_sorted(current, a);
        current = temp;

    }

    return a;
}


int main() { // tests will go here
    // TEST SUITE WRITTEN BY CLAUDE

    // ---- Test 1: new_node ----
    Node *n1 = new_node(5);
    assert(n1->value == 5);
    assert(n1->next == NULL);
    printf("Test 1 (new_node) passed\n");

    // ---- Test 2: print_list on a small manually-built list ----
    // Build 1 -> 2 -> 3 by hand, without insert_sorted, to isolate print_list
    Node *p1 = new_node(1);
    Node *p2 = new_node(2);
    Node *p3 = new_node(3);
    p1->next = p2;
    p2->next = p3;
    printf("Test 2 (print_list) expect '1 2 3': ");
    print_list(p1);
    printf("\n");

    // ---- Test 3: insert_sorted into the middle ----
    // Known limitation: insert_sorted assumes 'head' itself is already
    // the smallest element and non-NULL (it dereferences head->next
    // immediately), so every test list here starts with at least one node,
    // and every inserted value is >= that first node's value.
    Node *head_a = new_node(1);
    head_a->next = new_node(5);
    insert_sorted(new_node(3), head_a);   // insert 3 between 1 and 5
    printf("Test 3 (insert_sorted, middle) expect '1 3 5': ");
    print_list(head_a);
    printf("\n");

    // ---- Test 4: insert_sorted at the tail ----
    Node *head_b = new_node(1);
    head_b->next = new_node(2);
    insert_sorted(new_node(9), head_b);   // 9 belongs at the end
    printf("Test 4 (insert_sorted, tail) expect '1 2 9': ");
    print_list(head_b);
    printf("\n");

    // ---- Test 5: insert_sorted right after head (smallest legal insert) ----
    Node *head_c = new_node(1);
    head_c->next = new_node(10);
    insert_sorted(new_node(1), head_c);   // duplicate value, should still work
    printf("Test 5 (insert_sorted, duplicate) expect '1 1 10': ");
    print_list(head_c);
    printf("\n");

    // ---- Test 6: merge_linked_lists, interleaved values ----
    Node *list_a = new_node(1);
    insert_sorted(new_node(4), list_a);
    insert_sorted(new_node(7), list_a);   // list_a: 1 4 7

    Node *list_b = new_node(2);
    insert_sorted(new_node(5), list_b);
    insert_sorted(new_node(8), list_b);   // list_b: 2 5 8

    Node *merged = merge_linked_lists(list_a, list_b);
    printf("Test 6 (merge, interleaved) expect '1 2 4 5 7 8': ");
    print_list(merged);
    printf("\n");

    // ---- Test 7: merge_linked_lists, one list empty ----
    Node *list_d = new_node(1);
    insert_sorted(new_node(2), list_d);
    Node *merged_empty = merge_linked_lists(list_d, NULL);
    printf("Test 7 (merge, b empty) expect '1 2': ");
    print_list(merged_empty);
    printf("\n");

    // ---- Test 8: merge_linked_lists, both lists single-node ----
    Node *single_a = new_node(3);
    Node *single_b = new_node(6);
    Node *merged_singles = merge_linked_lists(single_a, single_b);
    printf("Test 8 (merge, two single nodes) expect '3 6': ");
    print_list(merged_singles);
    printf("\n");

    printf("All tests completed.\n");
    return 0;

}