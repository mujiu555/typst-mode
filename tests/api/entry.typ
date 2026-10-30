// Run as both PDF and HTML. entry declares metadata and renders its body.
#import "@local/tysty:0.1.0": *
#show: template
#set-base("https://example.com/notes/")
#entry(id: "root", title: [Entry root], authors: (), file_path: "root.typ")[
  #lookup("child", [Child link])
  #render-children([Children])
]
#embed[
  #render.entry(id: "child", parent_id: "root", title: [Entry child], authors: (), file_path: "child.typ")[Child body]
]
#context {
  assert.eq((current.get)().id, "root")
  let docs = (documents.final)()
  assert.eq(docs.root.parent_id, "root")
  assert.eq(docs.child.parent_id, "root")
  assert.eq(indexers().keys(), ("root", "child"))
  assert.eq(backlinks("child").first().ctx.payload, "root")
  assert.eq((pdf.render.file_base.get)(), "https://example.com/notes/")
  assert.eq((html.render.file_base.get)(), "https://example.com/notes/")
  if target() == "paged" {
    assert(query(link).any(l => l.dest == "https://example.com/notes/child.typ"))
  }
}
