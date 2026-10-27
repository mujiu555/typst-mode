// Function test: indexer/mkindex_indexers
// Manual: typst compile --root . tests/indexer/mkindex_indexers.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#mkindex("unit", [Target])
#context {
 let entries = indexers()
 assert.eq(entries.keys(), ("unit",))
 assert.eq(entries.unit.label, "unit")
 assert.eq(entries.unit.content, [Target])
 assert.eq(type(entries.unit.loc), location)
 assert.eq(query(<typst-mode-index-label>).len(), 1)
}
