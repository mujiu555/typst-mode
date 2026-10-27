// Function test: tag/add_doc_get_doc
// Manual: typst compile --root . tests/tag/add_doc_get_doc.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let (root, t, other) = (tag.register)("topic", "other")
#(t.add-doc)((id: "a", title: "A"))
#(t.add-doc)((id: "b", title: "B"))
#(t.add-doc)((id: "a", title: "Updated"))
#context {
 assert.eq((t.get-doc)().keys(), ("a", "b"))
 assert.eq((t.get-doc)().a.title, "Updated")
 assert.eq((other.get-doc)(), (:))
}
