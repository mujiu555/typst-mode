// kodama-style template for Wishful-Thinking.
// Styling is applied through set/show rules on native Typst elements,
// so users write plain Typst markup — no need for CSS-class-style calls.

#import "style/theme.typ": *
#import "style/components.typ": bracketed-slug, mkheader, slug, taxon, taxon-upper
#import "meta.typ": fetch-meta, fetch-meta-final

/// Apply the kodama-inspired page style via `#show: template`
#let template(doc) = {
  set page(
    paper: "a4",
    margin: 2em,
    header: context {
      let doc = fetch-meta()
      let docs = fetch-meta-final(n: "documents")
      let indexers = fetch-meta-final(n: "indexers")

      // fetch the previous and next documents for navigation links
      let prev = none
      let next = none
      let found = false
      for (id, d) in docs {
        if id == doc.at("id", default: none) {
          found = true
        } else if found and next == none {
          next = d
          break
        } else if not found {
          prev = d
        }
      }
      if not found {
        prev = none
      }
      let up = docs.at(doc.at("parent_id", default: ""), default: none)

      let navs = ()
      if prev != none {
        let prev = indexers.at(prev.id + ":" + prev.id)
        navs.push(link(prev.position, "[prev]"))
      }
      if up != none {
        let up = indexers.at(up.id + ":" + up.id)
        navs.push(link(up.position, "[up]"))
      }
      if next != none {
        let next = indexers.at(next.id + ":" + next.id)
        navs.push(link(next.position, "[next]"))
      }

      navs = text(size: 0.75em, fill: meta-color, navs.join(" "))

      // right: title · category · date
      let parts = ()
      let t = doc.at("title", default: "")
      if t != "" { parts.push(t) }
      if doc.at("category", default: none) != none {
        parts.push(text(fill: taxon-color, doc.category))
      }
      if doc.at("date", default: none) != none {
        parts.push(doc.date.display("[year]-[month]-[day]"))
      }
      let meta-content = if parts.len() > 0 {
        text(size: 0.75em, fill: meta-color, parts.join(text("  ·  ")))
      }

      if navs != none and meta-content != none {
        grid(
          columns: (1fr, 6fr),
          align(left, navs), align(right, meta-content),
        )
      } else if navs != none {
        align(left, navs)
      } else if meta-content != none {
        align(right, meta-content)
      }
    },
  )
  doc
}
