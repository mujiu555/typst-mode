#import "doc.typ": current, documents
#import "indexer.typ": backlinks, indexers, mkindex

#let _meta-color = rgb("#999")
#let _taxon-color = rgb("#555")

#let _slug(body) = text(size: 0.9em, fill: rgb("#888"), underline(stroke: (thickness: 0.5pt, dash: ("dot", 1pt)), body))

#let _authors(doc) = (
  doc
    .authors
    .map(a => {
      if type(a) == dictionary { a.name } else { a }
    })
    .join(", ")
)

#let _details(doc) = {
  let parts = ()
  if doc.authors.len() > 0 { parts.push(_authors(doc)) }
  parts.push(doc.date.display("[year]-[month]-[day]"))
  if doc.tags.len() > 0 {
    parts.push(text(fill: _taxon-color, doc.tags.map(t => t.name).join(", ")))
  }
  parts
}

// Navigation does not record backlinks; only explicit lookup calls do.
// Documents without a rendered heading remain valid navigation targets.
#let _destination(doc, entries) = entries.at(doc.id, default: (loc: doc.loc)).loc

// Render the current note and register its id as a global index label.
#let mkheading(new-page: true) = context {
  let doc = (current.get)()
  assert("id" in doc, message: "Call meta before mkheading")
  if new-page { pagebreak(weak: true) }
  let taxon = if type(doc.tlb) == dictionary { doc.tlb.at("taxon", default: none) }
  if taxon != none and taxon != "" {
    block(above: 0.8em, text(weight: 600, fill: _taxon-color, upper(taxon.at(0)) + taxon.slice(1) + "."))
  }
  // Register outside the heading body: outlines replay that body.
  mkindex(doc.id, block(below: 0.3em, heading(
    depth: 1,
    text(weight: 600, doc.title) + h(0.5em) + _slug("[" + doc.id + "]"),
  )))
  let parts = _details(doc)
  let parent = (documents.final)().at(doc.parent_id, default: none)
  if parent != none and parent.id != doc.id {
    parts.push(link(_destination(parent, indexers()), "[back]"))
  }
  block(above: 0.3em, below: 0.6em, text(size: 0.9em, fill: _meta-color, parts.join(" · ")))
}

// A separate cover does not register the heading label a second time.
#let mkcover() = context {
  let doc = (current.get)()
  assert("id" in doc, message: "Call meta before mkcover")
  pagebreak(weak: true)
  align(center)[
    #v(1fr)
    #if doc.cover_image.variant == "path" {
      image(doc.cover_image.payload.p, width: 60%)
      v(1em)
    }
    #text(size: 2em, weight: 600, doc.title)
    #v(1em)
    #text(fill: _meta-color, _details(doc).join(" · "))
    #if doc.abstract != "" { block(above: 2em, doc.abstract) }
    #v(1fr)
  ]
  pagebreak(weak: true)
}

// mkindex declares a target; render-index renders the collected list.
#let render-index(title: [Index], show-backlinks: true) = context {
  heading(outlined: false, title)
  for (name, entry) in indexers() {
    block[
      #link(entry.loc, entry.content)
      #if show-backlinks {
        let refs = backlinks(name)
        if refs.len() > 0 {
          text(size: 0.8em, fill: _meta-color, [
            #h(0.5em)Referenced from:
            #refs.enumerate().map(((i, r)) => link(r.loc, str(i + 1))).join(", ")
          ])
        }
      }
    ]
  }
}

// Wishful-Thinking's note layout with tag names and the new global index.
#let template(body) = {
  set page(paper: "a4", margin: 2em, header: context {
    let doc = (current.get)()
    if "id" in doc {
      let docs = (documents.final)()
      let entries = indexers()
      let ids = docs.keys()
      let pos = ids.position(id => id == doc.id)
      let nav = ()
      if pos != none and pos > 0 {
        nav.push(link(_destination(docs.at(ids.at(pos - 1)), entries), "[prev]"))
      }
      let parent = docs.at(doc.parent_id, default: none)
      if parent != none and parent.id != doc.id {
        nav.push(link(_destination(parent, entries), "[up]"))
      }
      if pos != none and pos + 1 < ids.len() {
        nav.push(link(_destination(docs.at(ids.at(pos + 1)), entries), "[next]"))
      }
      let parts = (doc.title,)
      if doc.tags.len() > 0 { parts.push(doc.tags.map(t => t.name).join(", ")) }
      parts.push(doc.date.display("[year]-[month]-[day]"))
      text(size: 0.75em, fill: _meta-color, grid(
        columns: (auto, 1fr),
        gutter: 1em,
        align(left, nav.join(" ")), align(right, parts.join(" · ")),
      ))
    }
  })
  body
}
