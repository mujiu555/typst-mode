#import "/lib/_lib.typ/render.typ": _authors, _details
#let doc = (authors: ("Alice", "Bob"), date: datetime(year: 2025, month: 1, day: 2), tags: ())
#assert.eq(_authors(doc), "Alice, Bob")
#assert.eq(_details(doc), ("Alice, Bob", "2025-01-02"))
