// typst compile --root . tests/render/pdf_namespace.typ /tmp/tysty-pdf-namespace.pdf
#import "@local/tysty:0.1.0": *
#show: pdf.render.template
#let tree = (tag.register)("topics", (science: (:),))
#meta(id: "root", title: [Root], authors: ())
#pdf.render.mkcover()
#pdf.render.mkdoc[
  #pdf.render.lookup("child", [Child reference])
  #pdf.render.render-children([Children])
  #pdf.render.embed[
    #meta(id: "child", parent_id: "root", title: [Child], authors: (), tags: (tree.children.science.tag,))
    #pdf.render.mkdoc[Child content.]
  ]
  #pdf.render.render-tags(tree)
]
#context {
  assert.eq(indexers().keys(), ("root", "child"))
  assert.eq(backlinks("child").len(), 1)
  assert.eq(backlinks("child").first().ctx.payload, "root")
}
