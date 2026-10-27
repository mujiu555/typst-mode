// Function test: reject/indexer/mkindex_duplicate
// Manual: typst compile --root . tests/reject/indexer/mkindex_duplicate.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Check the diagnostic manually; unrelated errors are not a passing test.
#import "/lib/_lib.typ/lib.typ": *
#mkindex("a", [A])
#mkindex("a", [B])
#context assert.eq(query(<typst-mode-index-label>).len(), 2)
