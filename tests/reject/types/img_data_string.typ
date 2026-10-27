// Manual: typst compile --root . tests/reject/types/img_data_string.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#assert.eq(type(img.data), function)
#let value = (img.data)(p: "PNG")
