// Consumer contract: every supported top-level entry is imported from the package.
#import "@local/tysty:0.1.0": meta, backlinks, indexers, mkindex, tag, author, category, img, current, documents, pdf, html, ssg, render, embed, entry, lookup, mkcover, mkdoc, mkoutline, render-children, render-tags, set-base, template
#for fn in (meta, backlinks, indexers, mkindex, embed, entry, lookup, mkcover, mkdoc, mkoutline, render-children, render-tags, set-base, template) {
  assert.eq(type(fn), function)
}
#for (top-level, namespaced) in (
  (embed, render.embed), (entry, render.entry), (lookup, render.lookup),
  (mkcover, render.mkcover), (mkdoc, render.mkdoc), (mkoutline, render.mkoutline),
  (render-children, render.render-children), (render-tags, render.render-tags),
  (set-base, render.set-base), (template, render.template),
) {
  assert.eq(top-level, namespaced)
}
#for renderer in (pdf.render, html.render) {
  for fn in (renderer.embed, renderer.lookup, renderer.mkcover, renderer.mkdoc, renderer.render-children, renderer.render-tags, renderer.template) {
    assert.eq(type(fn), function)
  }
}
#assert.eq(type(ssg.mkoutline), function)
#assert.eq(type(ssg.ref), function)
#assert.eq(type(html.render.stylesheet), str)
#assert(html.render.stylesheet.len() > 0)
