#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ": entities

// Body content must be emitted exactly once, after its document is indexed.
// Embedded documents inherit heading depth and restore the enclosing scope.
#meta(id: "outer", title: [Outer], authors: (), abstract: "Summary")
#metadata("before") <before-doc>
#mkdoc(new-page: false)[
  #metadata("outer body") <doc-body>
  #context {
    assert.eq((current.get)().id, "outer")
    assert.eq((entities.get)(), ("outer",))
    assert.eq(indexers().at("outer").label, "outer")
  }
  #embed[
    #meta(id: "inner", parent_id: "outer", title: [Inner], authors: ())
    #mkdoc()[
      #metadata("inner body") <doc-body>
      #context {
        assert.eq((current.get)().id, "inner")
        assert.eq((entities.get)(), ("outer", "inner"))
      }
    ]
  ]
  #context { assert.eq((current.get)().id, "outer") }
]
#context {
  let bodies = query(<doc-body>)
  assert.eq(bodies.map(m => m.value), ("outer body", "inner body"))
  assert.eq(bodies.first().location().page(), query(<before-doc>).first().location().page())
  assert(bodies.last().location().page() > bodies.first().location().page())
  assert.eq(query(heading).map(h => h.level), (1, 2))
  assert.eq((entities.final)(), ("outer", "inner"))
  assert.eq(query(<typst-mode-index-label>).map(m => m.value), ("outer", "inner"))
  assert.eq((current.final)().id, "outer")
  assert.eq(backlinks("outer"), (), message: "Parent navigation must not create lookup backlinks")
}
