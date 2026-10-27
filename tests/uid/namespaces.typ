#import "/lib/_lib.typ/uid.typ": *
#assert.eq(v3(namespaces.dns, ""), v3(namespaces.dns, ""))
#assert.ne(v3(namespaces.dns, "a"), v3(namespaces.dns, "b"))
#assert.ne(v3(namespaces.dns, "a"), v3(namespaces.url, "a"))
#for ns in namespaces.values() {
  let id = v3(ns, "λ👩‍🔬")
  assert.eq(id.len(), 36)
  assert.eq(id.at(14), "3")
  assert(("8", "9", "a", "b").contains(id.at(19)))
}
