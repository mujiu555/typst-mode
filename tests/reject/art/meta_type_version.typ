// expect-error: do not match
// Manual: typst compile --root . tests/reject/art/meta_type_version.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#let args = (id: "invalid", title: [Title], authors: ()) + (version: 5)
#assert.eq(args.at("version"), 5)
#meta(..args)
