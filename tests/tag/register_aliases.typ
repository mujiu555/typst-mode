// Manual: typst compile --root . tests/tag/register_aliases.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let (root, first, duplicate) = (tag.register)("same", "same")
#let (other-root, same-again, unrelated) = (tag.register)("same", "other")
#assert.eq(first.id, duplicate.id)
#assert.eq(first.id, same-again.id)
#meta(id: "alias", title: [Alias], authors: (), tags: (first, duplicate))
#context {
 assert.eq((same-again.get-doc)().keys(), ("alias",))
 assert.eq((duplicate.get-doc)().len(), 1)
 assert.eq((unrelated.get-doc)(), (:))
}
