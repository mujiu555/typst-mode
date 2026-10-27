// expect-error: unknown image format
// Manual: typst compile --root . tests/reject/render/mkcover_bad_png.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; the runner checks the expected diagnostic.
#import "/lib/_lib.typ/lib.typ": *
#let bad = (img.data)(p: bytes((137, 80, 78, 71)))
#assert.eq(bad.payload.p.len(), 4)
#meta(id: "bad-png", title: [Bad PNG], authors: (), cover_image: bad)
#mkcover()
