// Manual: typst compile --root . tests/reject/art/meta_type_parent_id.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let args = (id: "invalid", title: [Title], authors: ()) + (parent_id: 5)
#assert.eq(args.at("parent_id"), 5)
#meta(..args)
