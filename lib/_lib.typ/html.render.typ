#import "doc.typ": current, documents
#import "indexer.typ": indexers, mkindex
#import "render.common.typ": entities, file_base, lookup
#import "state.typ": _mkstate
#import "embed.typ": _embed

#let embed(offset: false, body) = _embed(body, offset: offset)

// This module uses Typst's built-in html; the public html namespace wraps it.
#let stylesheet = read("html.render.css")
#let section-outlines = _mkstate("ef875bf6-8365-4649-8558-0d4beaf5422c", (:))

#let _element(tag, class, body) = html.elem(tag, attrs: (class: class), body)

#let _details(doc) = {
  let authors = doc.authors.map(a => {
    if type(a) == str { a } else if a.home == "" { a.name } else { link(a.home, a.name) }
  })
  let parts = ()
  if authors.len() > 0 { parts.push(authors.join(", ")) }
  parts.push(html.elem(
    "time",
    attrs: (datetime: doc.date.display("[year]-[month]-[day]")),
    doc.date.display("[year]-[month]-[day]"),
  ))
  if doc.tags.len() > 0 { parts.push(doc.tags.map(t => t.name).join(", ")) }
  _element("div", "tysty-details", parts.join(" · "))
}

// Navigation uses plain links: rendering a menu must not create backlinks.
#let _navigation(doc) = context {
  let entries = indexers()
  let ids = (entities.final)()
  let pos = ids.position(id => id == doc.id)
  let links = ()
  if pos != none and pos > 0 {
    links.push(link(entries.at(ids.at(pos - 1)).loc, [Previous]))
  }
  if doc.parent_id != doc.id and doc.parent_id in entries {
    links.push(link(entries.at(doc.parent_id).loc, [Parent]))
  }
  if pos != none and pos + 1 < ids.len() {
    links.push(link(entries.at(ids.at(pos + 1)).loc, [Next]))
  }
  if links.len() > 0 {
    html.elem("nav", attrs: (class: "tysty-navigation", aria-label: "Note navigation"), links.join(" · "))
  } else {
    []
  }
}

#let _breadcrumbs(doc) = context {
  let entries = indexers()
  let docs = (documents.final)()
  let crumbs = ()
  let id = doc.id
  while true {
    let node = docs.at(id)
    crumbs.insert(0, if id in entries { link(entries.at(id).loc, node.title) } else { node.title })
    if node.parent_id == id { break }
    id = node.parent_id
  }
  html.elem("nav", attrs: (class: "tysty-breadcrumbs", aria-label: "Breadcrumb"), crumbs.join(" / "))
}

// Section headings are collected only while rendering this note's body.
#let section-outline(doc) = context {
  let sections = (section-outlines.final)().at(doc.id, default: ())
  if sections.len() == 0 {
    []
  } else {
    html.elem(
      "nav",
      attrs: (class: "tysty-section-list", aria-label: "Sections"),
      sections
        .map(section => html.elem("div", attrs: (class: "tysty-section level-" + str(section.level)), link(
          "#" + section.anchor,
          section.title,
        )))
        .join(),
    )
  }
}

// new-page is accepted for shared PDF/HTML source; HTML flows continuously.
#let mkdoc(new-page: true, ssg: false, outline: none, content) = context {
  let doc = (current.get)()
  (entities.update)(ids => ids + (doc.id,))
  let article = _element("article", "tysty-note", [
    #mkindex(doc.id, heading(depth: 1, doc.title))
    #_details(doc)
    #if not ssg { _navigation(doc) }
    #if not ssg { _breadcrumbs(doc) }
    #if doc.file_path != "(no link (uri))" and doc.file_path != "" {
      _element("p", "tysty-source", link((file_base.get)() + doc.file_path, [Source]))
    }
    #if doc.abstract != "" { _element("p", "tysty-abstract", doc.abstract) }
    #show heading: it => {
      if ssg {
        let active-doc = (current.get)()
        let records = (section-outlines.get)().at(active-doc.id, default: ())
        let anchor = "tysty-section-" + active-doc.id + "-" + str(records.len())
        (section-outlines.update)(all => {
          let prior = all.at(active-doc.id, default: ())
          all + ((active-doc.id): prior + ((anchor: anchor, title: it.body, level: it.level),))
        })
        let numbering = if it.numbering == none {
          []
        } else {
          counter(heading).display(it.numbering) + h(0.5em)
        }
        html.elem("h" + str(calc.min(it.level + 1, 6)), attrs: (id: anchor), [#numbering #it.body])
      } else {
        it
      }
    }
    #content
  ])
  if ssg {
    _element("div", "tysty-site-page", [
      #_element("header", "tysty-topbar", [#_navigation(doc) #_breadcrumbs(doc)])
      #_element("div", "tysty-page-layout", [
        #article
        #if outline != none {
          _element("aside", "tysty-page-outline", [
            #html.elem("h2", "On this page")
            #outline
          ])
        }
      ])
    ])
  } else {
    article
  }
}

// Covers are presentation only, outside the primary-index reading sequence.
#let mkcover() = context {
  let doc = (current.get)()
  _element("header", "tysty-cover", [
    #if doc.cover_image.variant in ("path", "data") {
      image(doc.cover_image.payload, alt: "Cover image")
    }
    #html.elem("h1", doc.title)
    #_details(doc)
    #if doc.abstract != "" { _element("p", "tysty-abstract", doc.abstract) }
  ])
}

#let render-children(title) = context {
  let doc = (current.get)()
  let entries = indexers()
  let ids = (entities.final)()
  let children = (documents.final)()
    .values()
    .filter(d => d.parent_id == doc.id and d.id != doc.id and d.id in ids and d.id in entries)
  if children.len() > 0 {
    _element("section", "tysty-children", [
      #heading(level: 2, outlined: false, title)
      #list(..children.map(d => link(entries.at(d.id).loc, d.title)))
    ])
  }
}

#let render-tags(tree) = context {
  let entries = indexers()
  let ids = (entities.final)()
  let docs = (documents.final)().values().filter(d => d.id in ids and d.id in entries)
  let node(it) = {
    let items = it.children.values().map(node)
    for doc in docs.filter(d => d.tags.any(t => t.id == it.tag.id)) {
      items.push(list.item(link(entries.at(doc.id).loc, doc.title)))
    }
    list.item(strong(it.tag.name) + if items.len() > 0 { list(..items) } else { [] })
  }
  _element("section", "tysty-tags", list(node(tree)))
}

// Inline CSS makes single-file HTML portable. Bundle pages link the shared asset.
#let template(body, title: "Notebook", lang: "en", css: stylesheet, css-href: none) = {
  html.elem("html", attrs: (lang: lang), [
    #html.elem("head", [
      #html.elem("meta", attrs: (charset: "utf-8"))
      #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
      #html.elem("title", title)
      #if css-href == none {
        html.elem("style", css)
      } else {
        html.elem("link", attrs: (rel: "stylesheet", href: css-href))
      }
    ])
    #html.elem("body", _element("main", "tysty", body))
  ])
}

// Paths are relative to the output bundle, independent of document IDs.
// Each page restores the caller's current-document scope.
#let page(path, body, title: "Notebook", lang: "en") = {
  assert(
    path.ends-with(".html")
      and not path.starts-with("/")
      and path.split("/").all(p => p != ".." and p != "." and p != ""),
    message: "HTML page path must be a relative .html path without dot segments",
  )
  let css-href = "../" * (path.split("/").len() - 1) + "tysty.css"
  document(path, title: title)[
    #(current.enter)()
    #template(body, title: title, lang: lang, css-href: css-href)
    #(current.leave)()
  ]
}

// Use as #show: html.render.bundle with --features html,bundle --format bundle.
#let bundle(body, css: stylesheet) = {
  asset("tysty.css", bytes(css))
  body
}
