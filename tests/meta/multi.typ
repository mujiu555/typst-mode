// Multi-document behaviour of lib/_lib.typ/meta.typ (no tags).
//
// Two limitations of the current implementation, documented rather than
// exercised:
//   - A `meta` call that passes `tags` cannot share a document with other
//     `meta` calls (the shared state does not converge during layout passes,
//     and the tag attachment is lost). The tagged case lives on its own in
//     `tests/meta/test.typ`.
//   - Redeclaring an already-registered `id` also fails to converge, because
//     the stored document carries a `here()` location, which shifts between
//     layout passes once the state value changes. So this file only
//     registers each id once.

#import "/lib/_lib.typ/meta.typ": _doc_uuid, current, documents, meta

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[meta — multiple documents]

// ---------------------------------------------------------------------
// 1. Two documents
// ---------------------------------------------------------------------
#heading(level: 2)[1. Two documents]

#(meta)(id: "doc-a", parent_id: "root", title: [Doc A], authors: ("a",))
#(meta)(id: "doc-b", parent_id: "root", title: [Doc B], authors: ("b",))

// `current` is the most recently declared document.
#context {
  assert.eq((current.get)().id, "doc-b", message: "current is the last declaration")
  assert.eq((current.get)().title, [Doc B], message: "current carries the last title")
}

// `documents` accumulates every declaration, keyed by id.
#context {
  let docs = (documents.get)()
  assert.eq(docs.keys().len(), 2, message: "both documents registered")
  assert(docs.keys().contains("doc-a"), message: "doc-a registered")
  assert(docs.keys().contains("doc-b"), message: "doc-b registered")
  assert.eq(docs.at("doc-a").did, _doc_uuid("doc-a"), message: "each doc has its own did")
  assert.eq(docs.at("doc-b").did, _doc_uuid("doc-b"), message: "second did deterministic")
}

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]
#context {
  render((current.get)().id)
  render((documents.get)().keys())
}
