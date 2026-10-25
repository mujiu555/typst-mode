// Function test: tag/register
// Manual: typst compile --root . tests/tag/register.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let (root, a, b) = (tag.register)("a", "b")
#assert.eq(root._parent, "")
#assert.eq(a._parent, root.id)
#assert.eq(a.name, "a")
#assert(a.id != b.id)
#assert.eq((tag.register)().len(), 1)
