// Manual: typst compile --root . tests/tag/embedded_and_many.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let (root, shared, child-tag) = (tag.register)("shared", "child")
#meta(id: "parent", title: [Parent], authors: (), tags: (shared,))
#for i in range(20) {
 embed([#meta(id: "child-" + str(i), title: [Child], authors: (), tags: (shared, shared, child-tag))])
}
#context {
 assert.eq((current.get)().id, "parent")
 assert.eq((shared.get-doc)().len(), 21)
 assert.eq((child-tag.get-doc)().len(), 20)
 assert.eq((documents.final)().len(), 21)
}
