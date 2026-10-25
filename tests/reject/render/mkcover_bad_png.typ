// Manual: typst compile --root . tests/reject/render/mkcover_bad_png.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "/lib/_lib.typ/lib.typ": *
#let bad = (img.data)(p: bytes((137, 80, 78, 71)))
#assert.eq(bad.payload.p.len(), 4)
#meta(id: "bad-png", title: [Bad PNG], authors: (), cover_image: bad)
#mkcover()
