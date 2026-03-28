#import "Hash_Table";
Basic :: #import "Basic";

// returns all keys that exist in both table_a and table_b.
// the result is allocated with the temporary allocator. (is that a good idea, shouldn't the caller have control over the allocator)?
table_shared_keys :: (table_a: *Table($Key, $Value_A), table_b: *Table(Key, $Value_B)) -> [] Key {
    results: [..] Key;
    results.allocator = Basic.temporary_allocator;

    // Iterate over the smaller table for efficiency.
    if table_a.count <= table_b.count {
        for table_a.entries {
            if it.hash < FIRST_VALID_HASH  continue;
            if table_contains(table_b, it.key) {
                Basic.array_add(*results, it.key);
            }
        }
    } else {
        for table_b.entries {
            if it.hash < FIRST_VALID_HASH  continue;
            if table_contains(table_a, it.key) {
                Basic.array_add(*results, it.key);
            }
        }
    }

    return results;
}

// returns all keys that exist in table_a but not in table_b.
// the result is allocated with the temporary allocator.
table_keys_only_in :: (table_a: *Table($Key, $Value_A), table_b: *Table(Key, $Value_B)) -> [] Key {
    results: [..] Key;
    results.allocator = Basic.temporary_allocator;

    for table_a.entries {
        if it.hash < FIRST_VALID_HASH  continue;
        if !table_contains(table_b, it.key) {
            Basic.array_add(*results, it.key);
        }
    }

    return results;
}
