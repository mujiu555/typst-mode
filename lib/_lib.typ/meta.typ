// typst-mode: meta.typ
// Document metadata system.
//
// `meta(...)` declares a document: it builds a `_Core_doc` record from the
// given metadata, stamps it with a UUID-derived `did`, attaches it to any
// tags, registers it in the `documents` store, and makes it the `current`
// document. Documents are referenced by id elsewhere (e.g. by tag.typ and
// by a future bibliography/record layer).

#import "uid.typ": namespaces, v3
#import "record.typ": record
#import "enum.typ": enum
#import "categories.typ": category
#import "tag.typ": tag
#import "state.typ": _mkstate, _state

// UUID namespace for documents: `_doc_uuid(name)` turns a document name
// into a deterministic v3 UUID, giving every document a stable, unique id.
#let _ns_doc = v3(namespaces.oid, "aa6f42d8-5c10-49a9-985f-cad16abd219b")
#let _doc_uuid(name) = v3(_ns_doc, name)

// Global stores (see state.typ):
//   documents — id -> `_Core_doc` map of every declared document
//   current   — the most recently declared document
#let documents = _mkstate(
  "f12cabee-4a71-4049-b99a-e91e4bb8ee32",
  (:),
)

#let current = _mkstate(
  "4425dff9-79cf-48e7-8868-1a99688d1635",
  (:),
)

// Author schema (not yet validated/used by `meta`, kept for the record
// layer).
#let author = record(
  name: str,
  affiliation: str,
  email: str,
  orcid: str,
)

#let image = enum(
  path: record(p: str),
  null: record(),
)
#let image = image + (null: (image.null)())

// The metadata schema: the core fields a `meta` document carries.
#let _core_doc = record(
  "Metadata: [Core]",
  id: str,
  parent_id: str,
  did: str,

  title: content,
  authors: array,

  date: datetime,
  lang: str,
  version: str,
  doi: str,
  abstract: str,
  keywords: array,
  license: str,

  description: str,
  cover_image: image,

  category: category,

  tags: array,

  tlb: none,

  loc: location,
)

// Declare a document. Most arguments map 1:1 onto `_Core_doc` fields and
#let meta(
  id: none,
  parent_id: "index",
  //
  title: none,
  authors: none,
  //
  date: datetime.today(),
  lang: "en_US",
  version: "0.0.1",
  doi: "(none)",
  abstract: "",
  keywords: (),
  license: "apache-v2",
  //
  description: "",
  cover_image: image.null,
  category: category.null,
  tags: (),
  tlb: (:),
) = context {
  let doc = (_core_doc.new)(
    id: id,
    parent_id: parent_id,
    did: _doc_uuid(id),

    title: title,
    authors: authors,

    date: date,
    lang: lang,
    version: version,
    doi: doi,
    abstract: abstract,
    keywords: keywords,
    license: license,

    description: description,
    cover_image: cover_image,

    category: category,

    tags: tags,

    tlb: tlb,

    loc: here(),
  )
  // Attach the document to every tag it lists
  for t in tags {
    (t.add-doc)(doc)
  }

  // Register under its id, and make it the current document
  let dc = (documents.get)()
  assert(not id in dc, message: "ERROR: duplicate document id: `" + id + "`")
  (documents.update)(
    dc + ((id): doc),
  )

  (current.update)(
    doc,
  )
}
