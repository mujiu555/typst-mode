#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Function test: regressions/render/mkcover_content_author
// Manual: typst compile --root . tests/regressions/render/mkcover_content_author.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", title: [Title], authors: ([Alice],))
#mkcover()

#context assert.eq(rendered-text().matches(regex("Title")).len(), 1)
