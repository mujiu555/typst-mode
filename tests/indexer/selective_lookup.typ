#import "@local/tysty:0.1.0": mkindex, indexers, lookup

// Ordinary labels and unrelated metadata must not enter the index or its lookup.
Ordinary target <unit>
#metadata("unrelated") <other-metadata>
#lookup("unit", [Forward])
#lookup("unit:child", [Other forward])
#pagebreak()
#mkindex("unit", [Target])
#mkindex("unit:child", [Child])

#context {
  let entries = indexers()
  assert.eq(entries.keys(), ("unit", "unit:child"))
  assert.eq(entries.unit.content, [Target])
  assert.eq(entries.at("unit:child").content, [Child])
  let links = query(link)
  assert.eq(links.len(), 2)
  assert.eq(links.at(0).dest, entries.unit.loc)
  assert.eq(links.at(1).dest, entries.at("unit:child").loc)
  assert.eq(entries.unit.loc.page(), 2)
}
