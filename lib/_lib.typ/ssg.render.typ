#import "html.render.typ" as _html
#import "doc.typ": current, documents
#import "state.typ": _mkstate
#import "embed.typ": _embed

#let embed(offset: false, body) = _embed(body, offset: offset)

// `document()` switches nested page content to the HTML target, so retain the
// outer bundle target for automatic render helpers called inside a page.
#let _bundle-output = _mkstate("5d162f87-0e2c-4264-87b7-78b8383ee73c", false)
#let is-bundle-output = () => (_bundle-output.get)()
#let entities = _mkstate("0a4d3ddb-f9f7-4343-bb68-b9cd28429263", ())
#let _page-bodies = _mkstate("tysty-ssg-page-bodies", (:))

// Create a stable route from explicit semantic ancestry. This is pure so the
// caller can calculate routes before emitting any bundle documents.
#let _slug(value) = {
  // Keep Unicode letters and digits. Slashes remain route separators so
  // identifiers such as `guides/setup` can describe a multi-file route.
  let slug = lower(value)
    .split("/")
    .map(part => part.replace(regex("[^\\p{L}\\p{N}]+"), "-").trim("-"))
    .filter(part => part != "")
    .join("/")
  if slug == "" { "untitled" } else { slug }
}

// `ancestors` are root-to-parent IDs. The root page is index.html.
#let route(id, ancestors: (), root: false) = {
  if root {
    "index.html"
  } else {
    (ancestors.map(_slug) + (_slug(id),)).join("/") + "/index.html"
  }
}

#let _document-route(doc) = {
  let docs = (documents.final)()
  let visited = ()
  let parts = ()
  let node = doc
  while true {
    assert(node.id not in visited, message: "Cyclic parent while computing SSG route")
    visited.push(node.id)
    if node.parent_id == node.id { break }
    parts.insert(0, _slug(node.id))
    node = docs.at(node.parent_id)
  }
  if parts.len() == 0 { "index.html" } else { parts.join("/") + "/index.html" }
}

#let _relative-route(destination, source) = {
  let from = source.split("/").slice(0, -1)
  let to = destination.split("/")
  let common = 0
  while common < from.len() and common < to.len() and from.at(common) == to.at(common) {
    common += 1
  }
  ("../" * (from.len() - common)) + to.slice(common).join("/")
}

// A route-aware outline of all registered documents, grouped by parent.
#let _outline-node(doc, docs, generated, source, active-id) = {
  let children = docs.values().filter(child => child.parent_id == doc.id and child.id != doc.id)
  let href = _relative-route(_document-route(doc), source)
  let attrs = (href: href) + if doc.id == active-id { (aria-current: "page") } else { (:) }
  let label = if doc.id in generated {
    html.elem("a", attrs: attrs, doc.title)
  } else {
    html.elem("span", attrs: (class: "tysty-unrendered"), doc.title)
  }
  html.elem("li", [
    #label
    #if children.len() > 0 {
      html.elem("ul", children.map(child => _outline-node(child, docs, generated, source, active-id)).join())
    }
  ])
}

#let mkoutline(depth: none, title: [Documents]) = context {
  let docs = (documents.final)()
  let generated = (entities.final)()
  let active = (current.get)()
  let source = _document-route(active)
  let roots = docs.values().filter(doc => doc.parent_id == doc.id)
  html.elem("nav", attrs: (class: "tysty-site-outline", aria-label: "Site outline"), [
    #html.elem("h2", title)
    #html.elem("ul", roots.map(doc => _outline-node(doc, docs, generated, source, active.id)).join())
  ])
}

// Embed a generated page's Typst body by its document label.
#let ref(label) = context {
  let docs = (documents.final)()
  let doc = docs.at(label)
  let generated = (entities.final)()
  assert(label in generated, message: "SSG page is registered but has not been generated: `" + label + "`")
  let body = (_page-bodies.final)().at(label)
  (current.enter)()
  (current.update)(doc)
  body
  (current.leave)()
}

// Bundle mkdoc uses the route derived from current metadata. Other targets
// keep their ordinary HTML/PDF rendering behavior.
#let mkdoc(body) = context {
  if target() == "bundle" {
    (_bundle-output.update)(_ => true)
    let doc = (current.get)()
    (entities.update)(ids => if doc.id in ids { ids } else { ids + (doc.id,) })
    (_page-bodies.update)(pages => pages + ((doc.id): body))
    let path = _document-route(doc)
    let depth = path.split("/").len() - 1
    let css-href = "../" * depth + "tysty.css"
    document(path, title: doc.title)[
      #_html.template(
        _html.mkdoc(
          ssg: true,
          outline: _html.section-outline(doc),
          body,
        ),
        title: doc.title,
        css-href: css-href,
      )
    ]
  } else {
    _html.mkdoc(body)
  }
}

