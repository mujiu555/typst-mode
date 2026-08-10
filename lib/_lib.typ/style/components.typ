// Semantic helpers specific to kodama's Zettelkasten system.
// Native Typst elements (headings, raw, blockquote, link, etc.)
// are styled globally via set/show rules in style.typ.

#import "theme.typ": *
#import "../meta.typ": fetch-meta, index

// - slug: gray label with dotted underline
#let slug(body) = {
  text(size: 0.9em, fill: slug-color, underline(stroke: dotted-stroke, body))
}

// - bracketed slug: "[slug]"
#let bracketed-slug(body) = slug(text("[") + body + text("]"))

// - taxon prefix, e.g. "Theorem."
#let taxon(label) = {
  text(weight: heading-font-weight, fill: taxon-color, label)
}

// - taxon with capitalized first letter + period
#let taxon-upper(label) = taxon(upper(label.at(0)) + label.slice(1) + ".")

/// Generate header block: taxon + title(with slug) + metadata line
#let mkheader() = context {
  pagebreak()

  let doc = fetch-meta()

  // taxon
  let tx = doc.at("taxon", default: none)
  if tx != none { block(above: 0.8em, taxon-upper(tx)) }

  // title + slug
  let t = doc.at("title", default: "")
  let slug = doc.at("id", default: "")
  index(slug)[
    = #if slug != "" {
      block(
        below: 0.3em,
        text(weight: heading-font-weight, t) + h(0.5em) + bracketed-slug(slug),
      )
    } else {
      block(below: 0.3em, text(weight: heading-font-weight, t))
    }]

  // metadata line
  let parts = ()
  if doc.at("author", default: none) != none {
    let a = doc.author
    if type(a) == array { a = a.join(", ") }
    parts.push(a)
  }
  if doc.at("date", default: none) != none {
    parts.push(doc.date.display())
  }
  if doc.at("category", default: none) != none {
    parts.push(text(fill: taxon-color, doc.category))
  }
  if doc.at("tag", default: none) != none and doc.tag.len() > 0 {
    parts.push(doc.tag.join(", "))
  }
  if doc.at("parent_id", default: none) != none {
    let pos = fetch-meta(n: "indexers").at(doc.parent_id + ":" + doc.parent_id, default: none)
    if pos != none {
      parts.push(link(pos.position, "[back]"))
    }
  }
  if parts.len() > 0 {
    block(above: 0.3em, below: 0.6em, text(size: 0.9em, fill: meta-color, parts.join(text(" · "))))
  }
}
