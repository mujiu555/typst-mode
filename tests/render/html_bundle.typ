// typst compile --root . --features html,bundle --format bundle tests/render/html_bundle.typ /tmp/tysty-html-bundle
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png
#show: html.render.bundle
#let tree = (tag.register)("topics", (science: (:),))
#let science = tree.children.science.tag

#html.render.page("index.html", title: "Notebook & notes")[
  #meta(id: "root", title: [Notebook & notes], authors: ("Alice",), tags: (science,), cover_image: (img.data)(png))
  #html.render.mkcover()
  #html.render.mkdoc[
    #html.render.lookup("child", [Read the child])
    #html.render.render-children([Children])
    #html.render.render-tags(tree)
  ]
]

#html.render.page("notes/child.html", title: "Child")[
  #meta(id: "child", parent_id: "root", title: [Child], authors: ())
  #html.render.mkdoc[
    #html.render.lookup("root", [Return to root])
    #embed[
      #meta(id: "nested", parent_id: "child", title: [Nested], authors: ())
      #html.render.mkdoc(new-page: false)[Nested content.]
    ]
    #html.render.lookup("root", [Restored child context])
  ]
  #context {
    assert.eq((current.get)().id, "child")
    assert.eq(indexers().keys(), ("root", "child", "nested", "standalone"))
    assert.eq(backlinks("root").map(r => r.ctx.payload), ("child", "child"))
    assert.eq(backlinks("child").first().ctx.payload, "root")
  }
]

#html.render.page("standalone.html", title: "Standalone index")[
  #mkindex("standalone", [Independent target])
  #html.render.lookup("standalone", [Independent reference])
  #context {
    assert.eq((current.get)(), (:))
    assert.eq(backlinks("standalone").first().ctx.variant, "null")
  }
]
