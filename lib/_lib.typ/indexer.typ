#import "@preview/uuidkit:0.1.0": namespaces, v3

#import "record.typ": impl, record
#import "state.typ": _state

#let _global = (_state.new)(sym: () => {}, default: (:))

#let _ns_index = v3(namespaces.oid, "5eb885ab-9e08-43ba-bb95-8e6178761d88")
#let _index_uuid(name) = v3(_ns_index, name)

#let _indexer = record(
  label: str,
  loc: location,
  content: content,
)

#let _indexer = impl(
  _indexer,
  lookup: (self, content) => context link(self.loc, content),
)

#let mkindex(label, content) = context {
  let loc = here()
  let index = (_indexer.new)(
    label: label,
    loc: loc,
    content: content,
  )
  let cont = (_global.get)()
  assert(not label in cont, message: "EROOR: duplicate label: `" + label + "`")

  (_global.update)(
    cont + ((label): index),
  )
}

#let lookup(label, content) = context {
  let cont = (_global.get)()
  (cont.at(label).lookup)(content)
}

