// Manual: typst compile --root . tests/doc/final_at_middle.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let tree = (tag.register)("test", (topic: (:),))
#let (root, topic) = (tree.tag, tree.children.topic.tag)
#meta(id: "first", title: [First], authors: (), tags: (topic,))
#mkdoc(new-page: false)[]
#lookup("last", [Forward])
#context {
 assert.eq((current.get)().id, "first")
 assert.eq((documents.get)().keys(), ("first",))
 assert.eq((documents.final)().keys(), ("first", "last"))
 assert.eq((current.final)().id, "last")
 assert.eq(indexers().keys(), ("first", "last"))
 assert.eq(backlinks("last").len(), 2)
 assert.eq((topic.get-doc)().map(d => d.id), ("first", "last"))
 [Final documents: #((documents.final)().len()). Final links: #(backlinks("last").len()).]
}
#meta(id: "last", title: [Last], authors: (), tags: (topic,))
#mkdoc(new-page: false)[]
#lookup("last", [Later])
