// expect-error: duplicate label
// Manual: typst compile --root . tests/reject/indexer/mkindex_nested_duplicate.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#mkindex("same", [Outer #mkindex("same", [Inner])])
#context assert.eq(query(<typst-mode-index-label>).len(), 2)
