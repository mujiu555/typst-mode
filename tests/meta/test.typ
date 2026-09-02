// Tests for lib/_lib.typ/meta.typ.
//
// `meta(...)` declares a document: it builds a `_Core_doc` record, stamps it
// with a deterministic UUID-derived `did`, registers it in `documents`, makes
// it `current`, and attaches it to any tags.
//
// Reads are location-aware, so every assertion runs in a `context` block
// *after* the `meta` call it inspects.
//
// Two limitations of the current implementation, documented rather than
// exercised:
//   - The record constructor rejects `none` for typed fields, so the fields
//     whose default is `none` — `id`, `parent_id`, `title`, `authors` — are
//     effectively required.
//   - A `meta` call that passes `tags` cannot share a document with other
//     `meta` calls (the shared state does not converge during layout passes,
//     and the tag attachment is lost). Multi-document behaviour without tags
//     is covered in `tests/meta/multi.typ`.

#import "/lib/_lib.typ/meta.typ": _doc_uuid, article_meta, current, documents
#import "/lib/_lib.typ/tag.typ": tag

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[meta — document metadata]

// ---------------------------------------------------------------------
// 1. Declaring a document
// ---------------------------------------------------------------------
#heading(level: 2)[1. Declare a document]

#let (root, ta, tb) = (tag.register)("alpha", "beta")

#(article_meta)(
  id: "doc-a",
  parent_id: "root",
  title: [Doc A],
  authors: ("me",),
  keywords: ("k1", "k2"),
  tags: (ta, tb),
)

// The new document becomes `current`.
#context {
  let cur = (current.get)()
  assert.eq(cur.id, "doc-a", message: "current document id")
  assert.eq(cur.parent_id, "root", message: "parent id stored")
  assert.eq(cur.title, [Doc A], message: "title stored")
  assert.eq(cur.authors, ("me",), message: "authors stored")
  assert.eq(cur.keywords, ("k1", "k2"), message: "keywords stored")
}

// ---------------------------------------------------------------------
// 2. Deterministic id (`did`)
// ---------------------------------------------------------------------
#heading(level: 2)[2. Deterministic did]

#context {
  let cur = (current.get)()
  assert.eq(cur.did, _doc_uuid("doc-a"), message: "did is the deterministic uuid")
  assert.eq(cur.did.len(), 36, message: "did has uuid shape")
  assert.eq(type(cur.loc), location, message: "location recorded")
}

// ---------------------------------------------------------------------
// 3. Defaults
// ---------------------------------------------------------------------
#heading(level: 2)[3. Defaults]

#context {
  let cur = (current.get)()
  assert.eq(cur.lang, "en_US", message: "default lang")
  assert.eq(cur.version, "0.0.1", message: "default version")
  assert.eq(cur.doi, "(none)", message: "default doi")
  assert.eq(cur.abstract, "", message: "default abstract")
  assert.eq(cur.license, "apache-v2", message: "default license")
  assert.eq(cur.description, "", message: "default description")
  assert.eq(cur.category.variant, "null", message: "default category is the null variant")
  assert.eq(cur.tlb, (:), message: "default tlb")
  assert.eq(type(cur.date), datetime, message: "default date is today")
}

// ---------------------------------------------------------------------
// 4. Documents store
// ---------------------------------------------------------------------
#heading(level: 2)[4. Documents store]

// The declaration is registered under its id.
#context {
  let docs = (documents.get)()
  assert(docs.keys().contains("doc-a"), message: "doc-a registered")
  assert.eq(docs.at("doc-a").title, [Doc A], message: "store keeps the full record")
}

// ---------------------------------------------------------------------
// 5. Tags
// ---------------------------------------------------------------------
#heading(level: 2)[5. Tags]

// A document passed to `meta` with `tags` is attached to each tag.
#context {
  let ta-docs = (ta.documents.get)()
  assert.eq(ta-docs.keys().len(), 1, message: "tag alpha received exactly one doc")
  assert(ta-docs.keys().contains("doc-a"), message: "tag alpha received doc-a")
  assert.eq(ta-docs.at("doc-a").title, [Doc A], message: "tag alpha holds the full record")

  let tb-docs = (tb.documents.get)()
  assert(tb-docs.keys().contains("doc-a"), message: "tag beta received doc-a")
}

// A tag can also attach a document directly with `add-doc`.
#let (r2, tc) = (tag.register)("gamma")
#context {
  (tc.add-doc)((documents.get)().at("doc-a"))
}
#context {
  let tc-docs = (tc.documents.get)()
  assert(tc-docs.keys().contains("doc-a"), message: "direct add-doc attaches the doc")
}

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]
#context {
  render((current.get)().did)
  render((current.get)().category.variant)
  render((documents.get)().keys())
  render((ta.documents.get)().keys())
}
