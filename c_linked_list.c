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

void insert_sorted(Node *n, Node **head) {
    // traverse linked list until find element geq to target
    int target = n->value;
    Node **pointer_to_update = head; // pointer TO 1st ptr
    Node *current = *head;

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
        insert_sorted(current, &a);
        current = temp;

    }

    return a;
}

// THIS FUNCTION WAS WRITTEN BY CLAUDE FOR TESTING:
int list_equals(Node *head, int *expected, int count) {
    Node *current = head;
    for (int i = 0; i < count; i++) {
        if (current == NULL) return 0;           // list too short
        if (current->value != expected[i]) return 0;
        current = current->next;
    }
    return current == NULL;                       // list too long?
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
    Node *head_a = new_node(1);
    head_a->next = new_node(5);
    insert_sorted(new_node(3), &head_a);   // insert 3 between 1 and 5
    printf("Test 3 (insert_sorted, middle) expect '1 3 5': ");
    print_list(head_a);
    printf("\n");

    // ---- Test 4: insert_sorted at the tail ----
    Node *head_b = new_node(1);
    head_b->next = new_node(2);
    insert_sorted(new_node(9), &head_b);   // 9 belongs at the end
    printf("Test 4 (insert_sorted, tail) expect '1 2 9': ");
    print_list(head_b);
    printf("\n");

    // ---- Test 5: insert_sorted right after head (smallest legal insert) ----
    Node *head_c = new_node(1);
    head_c->next = new_node(10);
    insert_sorted(new_node(1), &head_c);   // duplicate value, should still work
    printf("Test 5 (insert_sorted, duplicate) expect '1 1 10': ");
    print_list(head_c);
    printf("\n");

    // ---- Test 6: merge_linked_lists, interleaved values ----
    Node *list_a = new_node(1);
    insert_sorted(new_node(4), &list_a);
    insert_sorted(new_node(7), &list_a);   // list_a: 1 4 7

    Node *list_b = new_node(2);
    insert_sorted(new_node(5), &list_b);
    insert_sorted(new_node(8), &list_b);   // list_b: 2 5 8

    Node *merged = merge_linked_lists(list_a, list_b);
    printf("Test 6 (merge, interleaved) expect '1 2 4 5 7 8': ");
    print_list(merged);
    printf("\n");

    // ---- Test 7: merge_linked_lists, one list empty ----
    Node *list_d = new_node(1);
    insert_sorted(new_node(2), &list_d);
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

    // ---- Test 9: insert_sorted with negative numbers ----
    Node *head_neg = new_node(-10);
    insert_sorted(new_node(-3), &head_neg);
    insert_sorted(new_node(0), &head_neg);
    insert_sorted(new_node(5), &head_neg);
    int expected9[] = {-10, -3, 0, 5};
    assert(list_equals(head_neg, expected9, 4));
    printf("Test 9 (insert_sorted, negatives) passed\n");

    // ---- Test 10: insert_sorted, many duplicates of the same value ----
    Node *head_dup = new_node(2);
    insert_sorted(new_node(2), &head_dup);
    insert_sorted(new_node(2), &head_dup);
    insert_sorted(new_node(2), &head_dup);
    int expected10[] = {2, 2, 2, 2};
    assert(list_equals(head_dup, expected10, 4));
    printf("Test 10 (insert_sorted, all duplicates) passed\n");

    // ---- Test 11: insert_sorted, strictly descending insert order ----
    Node *head_desc = new_node(1);
    insert_sorted(new_node(9), &head_desc);
    insert_sorted(new_node(8), &head_desc);
    insert_sorted(new_node(7), &head_desc);
    int expected11[] = {1, 7, 8, 9};
    assert(list_equals(head_desc, expected11, 4));
    printf("Test 11 (insert_sorted, descending insert order) passed\n");

    // ---- Test 12: insert_sorted, single-node list (head only, no inserts) ----
    Node *head_single = new_node(42);
    int expected12[] = {42};
    assert(list_equals(head_single, expected12, 1));
    printf("Test 12 (single-node list, no inserts) passed\n");

    // ---- Test 13: merge_linked_lists, both NULL ----
    Node *merged_both_null = merge_linked_lists(NULL, NULL);
    assert(merged_both_null == NULL);
    printf("Test 13 (merge, both NULL) passed\n");

    // ---- Test 14: merge_linked_lists, equal values across lists (tie-break) ----
    Node *tie_a = new_node(5);
    insert_sorted(new_node(5), &tie_a);   // tie_a: 5 5
    Node *tie_b = new_node(5);
    insert_sorted(new_node(5), &tie_b);   // tie_b: 5 5
    Node *merged_ties = merge_linked_lists(tie_a, tie_b);
    int expected14[] = {5, 5, 5, 5};
    assert(list_equals(merged_ties, expected14, 4));
    printf("Test 14 (merge, all equal values) passed\n");

    // ---- Test 15: merge_linked_lists, one list much longer than the other ----
    Node *short_list = new_node(4);
    Node *long_list = new_node(1);
    insert_sorted(new_node(2), &long_list);
    insert_sorted(new_node(3), &long_list);
    insert_sorted(new_node(5), &long_list);
    insert_sorted(new_node(6), &long_list);
    insert_sorted(new_node(7), &long_list);   // long_list: 1 2 3 5 6 7
    Node *merged_uneven = merge_linked_lists(short_list, long_list);
    int expected15[] = {1, 2, 3, 4, 5, 6, 7};
    assert(list_equals(merged_uneven, expected15, 7));
    printf("Test 15 (merge, uneven-length lists) passed\n");

    // ---- Test 16: merge_linked_lists, all of list b smaller than list a's tail
    // but still >= list a's head (respects insert_sorted's head limitation) ----
    Node *base_a = new_node(1);
    insert_sorted(new_node(20), &base_a);
    insert_sorted(new_node(30), &base_a);   // base_a: 1 20 30
    Node *base_b = new_node(2);
    insert_sorted(new_node(3), &base_b);
    insert_sorted(new_node(4), &base_b);    // base_b: 2 3 4
    Node *merged_front_loaded = merge_linked_lists(base_a, base_b);
    int expected16[] = {1, 2, 3, 4, 20, 30};
    assert(list_equals(merged_front_loaded, expected16, 6));
    printf("Test 16 (merge, list b clusters near list a's head) passed\n");

    printf("All extended tests completed.\n");
    return 0;
}