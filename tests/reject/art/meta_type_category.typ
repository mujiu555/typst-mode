// Manual: typst compile --root . tests/reject/art/meta_type_category.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let args = (id: "invalid", title: [Title], authors: ()) + (category: "null")
#assert.eq(args.at("category"), "null")
#meta(..args)
