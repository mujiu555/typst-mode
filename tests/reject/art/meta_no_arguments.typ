// Manual: typst compile --root . tests/reject/art/meta_no_arguments.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#assert.eq(type(meta), function)
#meta()
