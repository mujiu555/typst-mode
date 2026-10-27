// expect-error: tags must contain
// Manual: typst compile --root . tests/reject/tag/meta_invalid_missing_methods.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#let bad = (name: "topic")
#assert.eq((bad,).len(), 1)
#meta(id: "invalid-tag", title: [Invalid], authors: (), tags: (bad,))
