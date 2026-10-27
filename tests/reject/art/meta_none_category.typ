// expect-error: not exist
// Manual: typst compile --root . tests/reject/art/meta_none_category.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
// Omitted is different from explicitly none: these schema fields are not nullable.
#let args = (id: "invalid-none", title: [Title], authors: ()) + (category: none)
#assert.eq(args.at("category"), none)
#meta(..args)
