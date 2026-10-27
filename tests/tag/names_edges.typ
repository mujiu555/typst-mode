// Manual: typst compile --root . tests/tag/names_edges.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
// Names are exact strings: case, whitespace, Unicode and empty strings are preserved.
#let root = (tag.register)("names", (:)).tag
#let (empty, upper, lower, spaced, unicode, delimiter) = ("", "Tag", "tag", " tag ", "笔记/α", "a:b").map(name => (root.sub)(name))
#let all = (empty, upper, lower, spaced, unicode, delimiter)
#assert.eq(all.map(t => t.id).dedup().len(), all.len())
#assert.eq(all.map(t => t.name), ("", "Tag", "tag", " tag ", "笔记/α", "a:b"))
#meta(id: "names", title: [Names], authors: (), tags: all)
#context { for t in all { assert.eq((t.get-doc)().map(d => d.id), ("names",)) } }
