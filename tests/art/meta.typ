// Function test: art/meta
// Manual: typst compile --root . tests/art/meta.typ /tmp/typst-unit-test.pdf
#import "@local/tysty:0.1.0": *
#meta(id: "unit", title: [Title], authors: ("Alice",), abstract: "Abstract")
#context {
 let d = (current.get)()
 assert.eq(d.id, "unit")
 assert.eq(d.title, [Title])
 assert.eq(d.authors, ("Alice",))
 assert.eq(d.abstract, "Abstract")
 assert.eq(d.category.variant, "null")
 assert.eq(d.cover_image.variant, "null")
 assert.eq((documents.final)().keys(), ("unit",))
 assert.eq(query(<typst-mode-document-id>).len(), 1)
}
