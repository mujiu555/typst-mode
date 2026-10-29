#import "html.render.typ" as _html
#import "art.typ": meta
#import "doc.typ": current, documents

// Create a stable route from explicit semantic ancestry. This is pure so the
// caller can calculate routes before emitting any bundle documents.
#let _slug(value) = {
  let slug = lower(value).replace(regex("[^a-z0-9]+"), "-").trim("-")
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

// Bundle mkdoc uses the route derived from current metadata. Other targets
// keep their ordinary HTML/PDF rendering behavior.
#let mkdoc(body) = context {
  if target() == "bundle" {
    let doc = (current.get)()
    let path = _document-route(doc)
    let depth = path.split("/").len() - 1
    let css-href = "../" * depth + "tysty.css"
    document(path, title: doc.title)[
      #_html.template(_html.mkdoc(body), title: doc.title, css-href: css-href)
    ]
  } else {
    _html.mkdoc(body)
  }
}

// Root entry declares metadata and emits its empty/root page. Child pages can
// then be declared with ordinary meta + mkdoc inside sibling embed blocks.
#let entry(..args, content) = {
  let fields = arguments.named(args)
  meta(..fields) + mkdoc(content)
}

#let site(body, css: _html.stylesheet) = _html.bundle(body, css: css)
