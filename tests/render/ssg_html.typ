// Outside a bundle, ssg.render.mkdoc falls back to HTML rendering.
#import "@local/tysty:0.1.0": *
#show: html.render.template
#meta(id: "single", title: [Single SSG fallback], authors: ())
#ssg.render.mkdoc[Fallback body.]
#context {
  assert.eq(indexers().keys(), ("single",))
  assert.eq(ssg.render.entities(), ())
  assert.eq(html.render.entities(), ("single",))
}
