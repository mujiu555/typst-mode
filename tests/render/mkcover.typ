#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Function test: render/mkcover
// Manual: typst compile --root . tests/render/mkcover.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "unit", title: [Title], authors: ("Alice",))
#mkcover()
#context {
 assert.eq(rendered-text().matches(regex("Title")).len(), 1)
 assert(rendered-text().contains("Title"))
 assert.eq(indexers(), (:), message: "Cover must not register a duplicate heading")
}
