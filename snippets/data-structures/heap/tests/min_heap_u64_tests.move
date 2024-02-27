#[test_only]
/// This is a test only module specifically for holding tests, it will not be compiled into a published module
module deploy_addr::min_heap_u64_tests {
    use std::vector;
    use deploy_addr::min_heap_u64::{Self, heap_sort};

    #[test]
    /// Tests various sucessful heap operations
    fun test_heap_creation() {
        let inputs = vector[
            vector[],
            vector[0],
            vector[0, 0],
            vector[0, 1],
            vector[1, 0],
            vector[1, 0, 0],
            vector[1, 1, 0],
            vector[1, 1, 1],
            vector[0, 1, 1],
            vector[0, 0, 1],
            vector[0, 0, 0, 1],
            vector[0, 0, 1, 1],
            vector[0, 1, 1, 1],
            vector[1, 1, 1, 1],
            vector[10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
            vector[5, 1, 2, 4, 2, 99, 0, 1, 1, 234, 525, 123, 2, 21313, 5455, 0, 0, 523]
        ];
        vector::for_each(inputs, |input| {
            let heap = min_heap_u64::from_vec(input);
            let output = min_heap_u64::to_vec(heap);
            is_heap_ordered(&output)
        })
    }

    #[test]
    /// Tests various sucessful heap operations
    fun test_heap_sort() {
        let inputs = vector[
            vector[],
            vector[0],
            vector[0, 0],
            vector[0, 1],
            vector[1, 0],
            vector[1, 0, 0],
            vector[1, 1, 0],
            vector[1, 1, 1],
            vector[0, 1, 1],
            vector[0, 0, 1],
            vector[0, 0, 0, 1],
            vector[0, 0, 1, 1],
            vector[0, 1, 1, 1],
            vector[1, 1, 1, 1],
            vector[10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
            vector[5, 1, 2, 4, 2, 99, 0, 1, 1, 234, 525, 123, 2, 21313, 5455, 0, 0, 523]
        ];
        vector::for_each(inputs, |input| {
            let sorted = heap_sort(input);
            is_vec_sorted(&sorted)
        })
    }

    #[test]
    fun heap_e2e_test() {
        let heap = min_heap_u64::new();
        assert!(min_heap_u64::is_empty(&heap), 1);
        min_heap_u64::insert(&mut heap, 2);
        assert!(min_heap_u64::min(&heap) == 2, 1);
        min_heap_u64::insert(&mut heap, 1);
        assert!(min_heap_u64::min(&heap) == 1, 1);
        min_heap_u64::insert(&mut heap, 0);
        assert!(min_heap_u64::min(&heap) == 0, 1);
        min_heap_u64::insert(&mut heap, 0);
        assert!(min_heap_u64::min(&heap) == 0, 1);

        assert!(!min_heap_u64::is_empty(&heap), 1);
        assert!(4 == min_heap_u64::size(&heap), 1);
        assert!(0 == min_heap_u64::pop(&mut heap), 2);
        assert!(0 == min_heap_u64::pop(&mut heap), 2);
        assert!(1 == min_heap_u64::pop(&mut heap), 2);
        assert!(2 == min_heap_u64::pop(&mut heap), 2);
    }

    #[test]
    #[expected_failure(abort_code = 1, location = min_heap_u64)]
    /// Checks that a left child will fail if out of order
    fun test_pop_empty() {
        min_heap_u64::pop(&mut min_heap_u64::new());
    }

    #[test]
    #[expected_failure(abort_code = 1, location = min_heap_u64)]
    /// Checks that a left child will fail if out of order
    fun test_min_empty() {
        min_heap_u64::min(&mut min_heap_u64::new());
    }

    #[test]
    /// Tests the check order function to ensure that in order heaps are correctly followed
    fun test_check_order() {
        let heaps = vector[
            vector[],
            vector[0],
            vector[0, 0],
            vector[0, 1],
            vector[0, 0, 0],
            vector[0, 1, 0],
            vector[0, 0, 1],
            vector[0, 1, 1],
            vector[1, 1, 1],
            vector[1, 1, 1],
        ];
        vector::for_each(heaps, |heap| {
            is_heap_ordered(&heap)
        })
    }

    #[test]
    #[expected_failure(abort_code = 1, location = Self)]
    /// Checks that a left child will fail if out of order
    fun test_check_false() {
        is_heap_ordered(&vector[1, 0])
    }

    #[test]
    #[expected_failure(abort_code = 2, location = Self)]
    /// Checks that a right child will fail if out of order
    fun test_check_false_2() {
        is_heap_ordered(&vector[1, 1, 0])
    }

    /// Helper function to check the order of a heap
    fun is_heap_ordered(heap: &vector<u64>) {
        let length = vector::length(heap);
        for (i in 0..length) {
            let left = 2 * i + 1;
            let right = left + 1;
            let cur = *vector::borrow(heap, i);

            // Ensure if there are children, that they're greater than the current value
            if (left < length) {
                let left_val = *vector::borrow(heap, left);
                assert!(cur <= left_val, 1);
            };
            if (right < length) {
                let right_val = *vector::borrow(heap, right);
                assert!(cur <= right_val, 2);
            }
        }
    }


    /// Helper function to check the sorting of a vec
    fun is_vec_sorted(input: &vector<u64>) {
        let length = vector::length(input);
        if (length == 0) { return };

        let previous = vector::borrow(input, 0);
        for (i in 1..length) {
            let cur = vector::borrow(input, i);
            assert!(*previous <= *cur, 99);
            previous = cur;
        }
    }
}
