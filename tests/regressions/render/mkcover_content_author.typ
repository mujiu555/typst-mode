// Function test: regressions/render/mkcover_content_author
// Manual: typst compile --root . tests/regressions/render/mkcover_content_author.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", title: [Title], authors: ([Alice],))
#mkcover()

#context assert.eq(query(title).len(), 1)
