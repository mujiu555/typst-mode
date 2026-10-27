#import "doc.typ": current, documents
#import "types.typ": author
#import "indexer.typ": backlinks, indexers, mkindex
#import "state.typ": _mkstate
#import "util.typ": _match

#let entities = _mkstate(
  "ac70da6c-0504-423b-b152-b40b80ffc95f",
  (),
)

#let _meta-color = rgb("#999")
#let _nav-color = rgb("#555")
#let _taxon-color = rgb("#555")

#let _slug(body) = text(size: 0.9em, fill: rgb("#888"), underline(stroke: (thickness: 0.5pt, dash: ("dot", 1pt)), body))

#let _authors(doc) = (
  doc
    .authors
    .map(a => {
      if _match(author, a) { link(a.home, a.name) } else if _match(str, a) { a }
    })
    .join(", ")
)
#let _content-to-text(body) = {
  if type(body) == str {
    return body
  }
  if body.has("text") {
    return body.text
  }
  if body.has("children") {
    return body.children.map(_content-to-text).join("")
  }
  ""
}

#let _truncate-middle(body, max: 20) = {
  let chars = _content-to-text(body).clusters()
  if chars.len() <= max {
    return body
  }
  let left = calc.ceil((max - 1) / 2)
  let right = max - 1 - left
  chars.slice(0, left).join() + "…" + chars.slice(chars.len() - right).join()
}

#let _details(doc) = {
  let parts = ()
  if doc.authors.len() > 0 { parts.push(_authors(doc)) }
  parts.push(doc.date.display("[year]-[month]-[day]"))
  if doc.tags.len() > 0 {
    parts.push(text(fill: _taxon-color, doc.tags.map(t => t.name).join(", ")))
  }
  parts
}

// Render the current note and register its id as a global index label.
#let mkdoc(new-page: true, content) = context {
  let doc = (current.get)()
  (entities.update)(dc => {
    dc + (doc.id,)
  })
  assert("id" in doc, message: "Call meta before mkheading")
  if new-page { pagebreak(weak: true) }
  // Register outside the heading body: outlines replay that body.
  mkindex(doc.id, block(below: 0.3em, heading(
    depth: 1,
    text(weight: 600, doc.title) + h(0.5em) + link(doc.file_path, _slug("[" + doc.id + "]")),
  )))
  let parts = _details(doc)
  let parent-id = doc.parent_id
  if parent-id != doc.id and parent-id in (entities.final)() {
    parts.push(link(indexers().at(parent-id).loc, "[back]"))
  }
  block(above: 0.3em, below: 0.6em, text(size: 0.9em, fill: _meta-color, parts.join(" · ")))
  if doc.abstract != "" {
    block(above: 0.6em, below: 1em, doc.abstract)
  }
  content
}

// A separate cover does not register the heading label a second time.
#let mkcover() = context {
  let doc = (current.get)()
  assert("id" in doc, message: "Call meta before mkcover")
  pagebreak(weak: true)
  align(center)[
    #v(1fr)
    #if doc.cover_image.variant in ("path", "data") {
      image(doc.cover_image.payload.p, width: 60%)
      v(1em)
    }
    #text(size: 2em, weight: 600, doc.title)
    #v(1em)
    #text(fill: _meta-color, _details(doc).join(" · "))
    #if doc.abstract != "" { block(above: 2em, doc.abstract) }
    #v(1fr)

    #set document(
      title: doc.title,
      author: doc.authors.map(v => if type(v) == str {
        v
      } else {
        v.name
      }),
      date: doc.date,
      description: doc.description,
      keywords: doc.keywords,
    )

  ]
  pagebreak(weak: true)
}

// Shared outline row, using the destination's page counter and numbering.
#let _document-row(doc, loc) = {
  let page-format = loc.page-numbering()
  let page-label = numbering(
    if page-format == none { "1" } else { page-format },
    ..counter(page).at(loc),
  )
  block(width: 100%, link(loc, doc.title + h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em) + page-label))
}

#let render-children(
  title,
) = context {
  let doc = (current.get)()
  let docs = (documents.final)()
  let entries = indexers()
  let ids = (entities.final)()

  let children = docs
    .values()
    .filter(
      d => d.parent_id == doc.id and d.id != doc.id and d.id in ids and d.id in entries,
    )

  if children.len() > 0 {
    heading(level: 2, outlined: false, title)

    for child in children {
      _document-row(child, entries.at(child.id).loc)
    }
  }
}

// Render a tree returned by tag.register, including its root. Each tag owns
// only its immediate child tags and documents explicitly declaring that tag.
// Read final metadata so this list can also precede the document headings.
#let render-tags(tree) = context {
  let entries = indexers()
  let ids = (entities.final)()
  let docs = (documents.final)().values().filter(doc => doc.id in ids and doc.id in entries)

  let render-node(node) = {
    let items = node.children.values().map(child => render-node(child))
    for doc in docs.filter(doc => doc.tags.any(tag => tag.id == node.tag.id)) {
      items.push(list.item(_document-row(doc, entries.at(doc.id).loc)))
    }
    list.item(
      strong(node.tag.name)
        + if items.len() > 0 {
          list(..items)
        } else {
          []
        },
    )
  }

  list(render-node(tree))
}

// Wishful-Thinking's note layout with tag names and the new global index.
#let template(body) = {
  set page(
    paper: "a4",
    margin: (
      x: 2em,
      top: 4em,
      bottom: 3em,
    ),
    header: context {
      let doc = (current.get)()
      if "id" in doc {
        let entries = indexers()
        let ids = (entities.final)()
        let pos = ids.position(id => id == doc.id)

        let nav = ()
        let tocs = query(outline)
        if tocs.len() > 0 {
          nav.push(link(tocs.first().location(), "[toc]"))
        }
        if pos != none and pos > 0 {
          nav.push(link(entries.at(ids.at(pos - 1)).loc, "[prev]"))
        }
        if pos != none and pos + 1 < ids.len() {
          nav.push(link(entries.at(ids.at(pos + 1)).loc, "[next]"))
        }

        let parts = (doc.title, doc.date.display("[year]-[month]-[day]"))

        let breadcrumbs = ()
        let id = doc.id
        let docs = (documents.final)()
        while true {
          let node = docs.at(id)
          let title = _truncate-middle(node.title)
          let item = if id in entries {
            link(entries.at(id).loc, title)
          } else {
            title
          }
          breadcrumbs.insert(0, item)
          if node.parent_id == id {
            break
          }
          id = node.parent_id
        }

        grid(
          columns: (auto, 1fr),
          gutter: 1em,
          row-gutter: 4pt,
          text(size: 9pt, fill: _nav-color, align(left, nav.join(" "))),
          text(size: 9pt, fill: _meta-color, align(right, parts.join(" · "))),

          grid.cell(
            colspan: 2,
            text(size: 7pt, fill: _meta-color, breadcrumbs.join(" > ")),
          ),
        )
      }
    },
  )
  body
}
