// Function tests: _authors, _details, _destination.
// Manual: typst compile --root . tests/render/helpers.typ /tmp/render-helpers.pdf
#import "/lib/_lib.typ/render.typ": _authors, _details, _destination
#let doc = (id: "a", loc: "fallback", authors: ("Alice", (name: "Bob")), date: datetime(year: 2025, month: 1, day: 2), tags: ())
#assert.eq(_authors(doc), "Alice, Bob")
#assert.eq(_details(doc), ("Alice, Bob", "2025-01-02"))
#assert.eq(_destination(doc, (:)), "fallback")
#assert.eq(_destination(doc, (a: (loc: "heading"))), "heading")
