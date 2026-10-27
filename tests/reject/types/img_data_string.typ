// expect-error: do not match
// Manual: typst compile --root . tests/reject/types/img_data_string.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#assert.eq(type(img.data), function)
#let value = (img.data)(p: "PNG")
