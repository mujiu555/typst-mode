// Manual: typst compile --root . tests/reject/tag/meta_invalid_string.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let bad = "topic"
#assert.eq((bad,).len(), 1)
#meta(id: "invalid-tag", title: [Invalid], authors: (), tags: (bad,))
