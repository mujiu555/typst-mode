#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/state.typ": _mkstate
#let s = _mkstate("coverage-counter", 0)
#let alias = _mkstate("coverage-counter", 0)
#let other = _mkstate("coverage-other", 10)
#assert.eq(s.sym, alias.sym)
#assert.ne(s.sym, other.sym)
#assert.ne(_mkstate("", ()).sym, _mkstate("λ", ()).sym)
#context { assert.eq((s.get)(), 0); assert.eq((current.get)(), (:)) }
#(s.update)(1)
#metadata("checkpoint") <checkpoint>
#(s.update)(n => n + 2)
#context {
  assert.eq((s.get)(), 3)
  assert.eq((alias.get)(), 3)
  assert.eq((other.final)(), 10)
  assert.eq((s.at)(query(<checkpoint>).first().location()), 1)
  assert.eq((s.final)(), 3)
}
#let tree = (tag.register)("coverage", (science: (physics: (:),), empty: (:)))
#let root = tree.tag
#let science = tree.children.science.tag
#let physics = tree.children.science.children.physics.tag
#assert.eq(root._parent, "")
#assert.eq(science._parent, root.id)
#assert.eq(physics._parent, science.id)
#assert.eq((physics.sub)("deep")._parent, physics.id)
#assert.eq((tag.register)("coverage", (:)).tag.id, root.id)
#assert.ne((tag.register)("other", (:)).tag.id, root.id)
#assert.ne((science.sub)("same").id, (physics.sub)("same").id)
#meta(id: "parent", title: [Parent], authors: (), tags: (root,))
#metadata("parent") <parent-position>
#context { assert.eq((current.get)().parent_id, "parent") }
#embed[
  #context { assert.eq((current.get)().id, "parent") }
  #meta(id: "child", parent_id: "parent", title: [Child], authors: ("A",), tags: (physics, physics))
  #embed[
    #meta(id: "grandchild", parent_id: "child", title: [Grandchild], authors: ())
    #context { assert.eq((current.get)().id, "grandchild") }
  ]
  #context { assert.eq((current.get)().id, "child") }
]
#context { assert.eq((current.get)().id, "parent") }
#for i in range(12) {
  embed[
    #meta(id: "sibling-" + str(i), parent_id: "parent", title: [Sibling], authors: ())
    #context { assert.eq((current.get)().id, "sibling-" + str(i)) }
  ]
}
#context {
  assert.eq((current.final)().id, "parent")
  assert.eq((current.at)(query(<parent-position>).first().location()).id, "parent")
  assert.eq((documents.final)().len(), 15)
  assert.eq((physics.get-doc)().map(d => d.id), ("child",))
  assert.eq((science.get-doc)(), ())
  assert.eq((root.get-doc)().map(d => d.id), ("parent",))
  let doc = (documents.final)().at("parent")
  assert.eq(doc.cover_image.variant, "null")
  assert.eq(doc.category.variant, "null")
  assert.eq(doc.keywords, ())
  assert.eq(doc.tlb, (:))
}
#(current.update)(d => d + (title: [Changed],))
#context { assert.eq((current.get)().title, [Changed]) }
