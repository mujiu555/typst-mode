// Manual: typst compile --root . tests/tag/hierarchy_membership.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let tree = (tag.register)("test", (a: (:), b: (:)))
#let (root, a, b) = (tree.tag, tree.children.a.tag, tree.children.b.tag)
#let child = (a.sub)("child")
#let grandchild = (child.sub)("leaf")
#meta(id: "child-only", title: [Child], authors: (), tags: (child,))
#meta(id: "both", title: [Both], authors: (), tags: (a, child, grandchild, root))
#context {
 assert.eq((a.get-doc)().map(d => d.id), ("both",), message: "No implicit ancestor propagation")
 assert.eq((child.get-doc)().map(d => d.id), ("child-only", "both"))
 assert.eq((grandchild.get-doc)().map(d => d.id), ("both",))
 assert.eq((root.get-doc)().map(d => d.id), ("both",))
 assert.eq((b.get-doc)(), ())
}
