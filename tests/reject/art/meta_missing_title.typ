// Manual: typst compile --root . tests/reject/art/meta_missing_title.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let args = (id: "required", authors: ())
#assert(not ("title" in args))
#meta(..args)
