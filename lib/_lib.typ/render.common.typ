#import "doc.typ": current
#import "indexer.typ": _lookup

#import "state.typ": _mkstate
#let file_base = _mkstate(
  "c88ae13e-b0cd-4f84-b3e8-759903558a3d",
  "",
)

#let set-base(p) = context {
  (file_base.update)(
    _ => p,
  )
}

#let entities = _mkstate(
  "ac70da6c-0504-423b-b152-b40b80ffc95f",
  (),
)

// Both renderers attach the caller's document when one has been declared.
// The underlying indexer remains usable without document metadata.
#let lookup(label, content) = context {
  let doc = (current.get)()
  _lookup(label, content, doc_id: doc.at("id", default: auto))
}
