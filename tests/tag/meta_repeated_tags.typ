// Manual: typst compile --root . tests/tag/meta_repeated_tags.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let tree = (tag.register)("test", (a: (:), b: (:)))
#let (root, a, b) = (tree.tag, tree.children.a.tag, tree.children.b.tag)
#meta(id: "one", title: [One], authors: (), tags: (a, a, b, a))
#context {
 // Membership is read from final metadata, including later declarations.
 assert.eq((a.get-doc)().map(d => d.id), ("one", "two"), message: "Repeated tag must not duplicate membership")
 assert.eq((b.get-doc)().map(d => d.id), ("one", "two"))
 // Metadata currently preserves input order and duplicates; do not impose SSG normalization.
 assert.eq((current.get)().tags.map(t => t.name), ("a", "a", "b", "a"))
}
#meta(id: "two", title: [Two], authors: (), tags: (a, b))
#meta(id: "untagged", title: [Untagged], authors: (), tags: ())
#context {
 assert.eq((a.get-doc)().map(d => d.id), ("one", "two"))
 assert.eq((b.get-doc)().map(d => d.id), ("one", "two"))
 assert.eq((root.get-doc)(), ())
}
