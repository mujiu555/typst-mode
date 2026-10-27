// Function test: tag/register
// Manual: typst compile --root . tests/tag/register.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let tree = (tag.register)("test", (a: (:), b: (:)))
#let (root, a, b) = (tree.tag, tree.children.a.tag, tree.children.b.tag)
#assert.eq(root._parent, "")
#assert.eq(a._parent, root.id)
#assert.eq(a.name, "a")
#assert(a.id != b.id)
#assert.eq((tag.register)("empty", (:)).children, (:))
