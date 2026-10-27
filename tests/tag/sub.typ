// Function test: tag/sub
// Manual: typst compile --root . tests/tag/sub.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let (root, a, b) = (tag.register)("a", "b")
#let child = (a.sub)("child")
#assert.eq(child._parent, a.id)
#assert.eq(child.name, "child")
#assert.eq(child.id, (a.sub)("child").id)
#assert(child.id != (b.sub)("child").id)
#assert.eq((child.sub)("grandchild")._parent, child.id)
