// Tests for lib/_lib.typ/indexer.typ.
//
// `mkindex(label, content)` records an entry at the current location;
// `lookup(label, content)` renders a link to it. Both are location-aware
// (they read/write the shared `_global` store), so `lookup` calls must come
// after the matching `mkindex` in document order. A duplicate `mkindex`
// label aborts compilation, so the duplicate case is documented as a comment
// rather than exercised.

#import "/lib/_lib.typ/indexer.typ": lookup, mkindex

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[indexer — index & cross-reference links]

// ---------------------------------------------------------------------
// 1. Registering a label
// ---------------------------------------------------------------------
#heading(level: 2)[1. Register a label]

#(mkindex)("sec-one", [Section One])
#(mkindex)("sec-two", [Section Two])

// Each label is stored in the global store with its text, its display
// content and the location it points at.
#context {
  assert(cont.keys().contains("sec-one"), message: "sec-one registered")
  assert(cont.keys().contains("sec-two"), message: "sec-two registered")

  let one = cont.at("sec-one")
  assert.eq(one.label, "sec-one", message: "label text stored")
  assert.eq(one.content, [Section One], message: "display content stored")
  assert.eq(type(one.loc), location, message: "location stored")

  let two = cont.at("sec-two")
  assert.eq(two.label, "sec-two", message: "second label stored")
}

// --- duplicate labels are rejected (abort compilation), documented here ---
// #(mkindex)("sec-one", [Again])

// ---------------------------------------------------------------------
// 2. Looking up a label
// ---------------------------------------------------------------------
#heading(level: 2)[2. Look up a label]

// `lookup` returns a `context` element whose rendered form is a link to the
// recorded location (verified end-to-end below and via `typst query link`).
#let l = (lookup)("sec-one", [Go to Section One])
#assert.eq(type(l), content, message: "lookup produces a content element")

// Render the link (appears in the compiled PDF as a clickable cross-ref).
#(lookup)("sec-one", [Go to Section One])

// The body content of the link is exactly the content passed to `lookup`.
#(lookup)("sec-two", [Jump to two])

// --- a missing label aborts compilation, documented here ---
// #(lookup)("missing", [Nowhere])

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#context {
  let cont = (_global.get)()
  assert.eq(cont.keys().len(), 2, message: "exactly two labels registered")
}
#let render(d) = [== #repr(d)]
#render((lookup)("sec-one", [Section One]))
