// typst-mode: indexer.typ
// Index / lookup: `mkindex` records a label at the current location in the
// document; `lookup` turns that label back into a clickable link to the
// spot. This powers things like an index or cross-references.

#import "uid.typ": namespaces, v3

#import "record.typ": impl, record
#import "state.typ": _state

// Global store of labels: name -> index entry. A fresh `_state` slot is
// used so it does not collide with the other modules' slots.
#let _global = (_state.new)(sym: () => {}, default: (:))

// UUID namespace for index labels, mirroring meta.typ / tag.typ.
#let _ns_index = v3(namespaces.oid, "5eb885ab-9e08-43ba-bb95-8e6178761d88")
#let _index_uuid(name) = v3(_ns_index, name)

// TODO:
#let _lookuper = record(
  label: str,
  loc: location,
  content: content,
)

// An index entry: the label text, the location it points at, and the
// content to display for the link.
#let _indexer = record(
  label: str,
  loc: location,
  content: content,
  backlinks: _state,
)

#let _indexer = impl(
  _indexer,
  // Build a link to the recorded location, shown as `content`.
  lookup: (self, loc, content) => context {
    let backref = (self.backlinks.get)()
    (self.backlinks.update)(
      backref + ((_lookuper.new)(label: self.label, loc: loc, content: content),),
    )
    link(self.loc, content)
  },
)

// Register a label at the current location. Duplicate labels are rejected —
// this fails compilation instead of silently shadowing.
#let mkindex(label, content) = context {
  let loc = here()
  let index = (_indexer.new)(
    label: label,
    loc: loc,
    content: content,
    backlinks: (_state.new)(sym: () => {}, default: ()),
  )

  let cont = (_global.get)()
  assert(not label in cont, message: "EROOR: duplicate label: `" + label + "`")
  (_global.update)(
    cont + ((label): index),
  )

  content
}

// Look up a previously registered label and render a link to it.
#let lookup(label, content) = context {
  let cont = (_global.final)()
  (cont.at(label).lookup)(here(), content)
}

#let backlinks(label) = {
  let cont = (_global.get)()
  ((cont.at(label).backlinks).final)()
}

#let indexers() = {
  (_global.final)()
}
