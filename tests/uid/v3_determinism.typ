// Function test: uid/v3_determinism
// Manual: typst compile --root . tests/uid/v3_determinism.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/uid.typ": v3, namespaces
#let id = v3(namespaces.dns, "unit")
#assert.eq(id, v3(namespaces.dns, "unit"))
#assert(id != v3(namespaces.url, "unit"))
#assert(id != v3(namespaces.dns, "other"))
#assert.eq(id.len(), 36)
#assert.eq(id.at(14), "3")
#assert(("8", "9", "a", "b").contains(id.at(19)))
