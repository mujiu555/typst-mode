#import "doc.typ": current
#import "indexer.typ": _lookup

// Both renderers attach the caller's document when one has been declared.
// The underlying indexer remains usable without document metadata.
#let lookup(label, content) = context {
  let doc = (current.get)()
  _lookup(label, content, doc_id: doc.at("id", default: auto))
}
