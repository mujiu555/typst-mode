// Manual: typst compile --root . tests/reject/art/meta_missing_id.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let args = (title: [Title], authors: ())
#assert(not ("id" in args))
#meta(..args)
