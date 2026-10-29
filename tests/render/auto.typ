// Compile this same source as PDF and HTML to exercise target dispatch.
#import "/lib/_lib.typ/lib.typ": *
#show: template
#let tree = (tag.register)("topics", (science: (:),))
#mkindex("standalone", [Independent target])
#lookup("standalone", [Independent reference])
#meta(id: "root", title: [Auto root], authors: ())
#mkcover()
#mkdoc[
  #lookup("child", [Forward reference])
  #render-children([Children])
  #render-tags(tree)
]
#meta(id: "child", parent_id: "root", title: [Auto child], authors: (), tags: (tree.children.science.tag,))
#mkdoc(new-page: false)[Child content.]
#context {
  assert.eq(backlinks("standalone").first().ctx.variant, "null")
  assert.eq(backlinks("child").len(), 1)
  assert.eq(backlinks("child").first().ctx.payload, "root")
  let active = if target() == "html" { html.render.entities } else { pdf.render.entities }
  assert.eq((active.final)(), ("root", "child"))
}
