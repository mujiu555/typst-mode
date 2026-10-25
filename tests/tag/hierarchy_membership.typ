// Manual: typst compile --root . tests/tag/hierarchy_membership.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let (root, a, b) = (tag.register)("a", "b")
#let child = (a.sub)("child")
#let grandchild = (child.sub)("leaf")
#meta(id: "child-only", title: [Child], authors: (), tags: (child,))
#meta(id: "both", title: [Both], authors: (), tags: (a, child, grandchild, root))
#context {
 assert.eq((a.get-doc)().keys(), ("both",), message: "No implicit ancestor propagation")
 assert.eq((child.get-doc)().keys(), ("child-only", "both"))
 assert.eq((grandchild.get-doc)().keys(), ("both",))
 assert.eq((root.get-doc)().keys(), ("both",))
 assert.eq((b.get-doc)(), (:))
}
