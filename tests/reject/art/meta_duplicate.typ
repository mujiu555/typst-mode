// expect-error: duplicate document id
// Function test: reject/art/meta_duplicate
// Manual: typst compile --root . tests/reject/art/meta_duplicate.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Unrelated errors are not a passing test.
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", title: [A], authors: ())
#meta(id: "a", title: [A], authors: ())
#context assert.eq(query(<typst-mode-document-id>).len(), 2)
