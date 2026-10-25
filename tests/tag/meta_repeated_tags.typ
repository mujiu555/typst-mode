// Manual: typst compile --root . tests/tag/meta_repeated_tags.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let (root, a, b) = (tag.register)("a", "b")
#meta(id: "one", title: [One], authors: (), tags: (a, a, b, a))
#context {
 assert.eq((a.get-doc)().keys(), ("one",), message: "Repeated tag must not duplicate membership")
 assert.eq((b.get-doc)().keys(), ("one",))
 // Metadata currently preserves input order and duplicates; do not impose SSG normalization.
 assert.eq((current.get)().tags.map(t => t.name), ("a", "a", "b", "a"))
}
#meta(id: "two", title: [Two], authors: (), tags: (a, b))
#meta(id: "untagged", title: [Untagged], authors: (), tags: ())
#context {
 assert.eq((a.get-doc)().keys(), ("one", "two"))
 assert.eq((b.get-doc)().keys(), ("one", "two"))
 assert.eq((root.get-doc)(), (:))
}
