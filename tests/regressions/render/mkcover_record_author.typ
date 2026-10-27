#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Function test: regressions/render/mkcover_record_author
// Manual: typst compile --root . tests/regressions/render/mkcover_record_author.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/lib.typ": *
#let a = (author.new)(name: "Alice", affiliation: "Org", email: "a@b", orcid: "123")
#meta(id: "a", title: [Title], authors: (a,))
#mkcover()

#context assert.eq(rendered-text().matches(regex("Title")).len(), 1)
