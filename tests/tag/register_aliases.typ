// Manual: typst compile --root . tests/tag/register_aliases.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let root = (tag.register)("aliases", (:)).tag
#let first = (root.sub)("same")
#let duplicate = (root.sub)("same")
#let tree = (tag.register)("aliases", (same: (:), other: (:)))
#let same-again = tree.children.same.tag
#let unrelated = tree.children.other.tag
#assert.eq(first.id, duplicate.id)
#assert.eq(first.id, same-again.id)
#meta(id: "alias", title: [Alias], authors: (), tags: (first, duplicate))
#context {
 assert.eq((same-again.get-doc)().map(d => d.id), ("alias",))
 assert.eq((duplicate.get-doc)().len(), 1)
 assert.eq((unrelated.get-doc)(), ())
}
