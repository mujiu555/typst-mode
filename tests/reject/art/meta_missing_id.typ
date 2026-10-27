// expect-error: not exist
// Manual: typst compile --root . tests/reject/art/meta_missing_id.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#let args = (title: [Title], authors: ())
#assert(not ("id" in args))
#meta(..args)
