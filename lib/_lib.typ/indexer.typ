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

#let indexer = impl(
  _indexer,
  lookup: (self, content) => context link(self.loc, content),
)

#let mkindex(label, content) = context {
  let index = (indexer.new)(
    label: label,
    loc: here(),
    content: content,
  )
  (_global.update)(
    (_global.get)() + ((label): index),
  )
  content
}

#let lookup(label, content) = context {
  let cont = (_global.get)()
  (cont.at(label).lookup)(content)
}
