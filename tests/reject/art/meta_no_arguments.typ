// expect-error: not exist
// Manual: typst compile --root . tests/reject/art/meta_no_arguments.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#assert.eq(type(meta), function)
#meta()
