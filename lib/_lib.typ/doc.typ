// typst-mode: doc.typ
// Document metadata system.
//
// `meta(...)` in art.typ declares a document: it builds a `_core_doc` record from the
// given metadata, stamps it with a UUID-derived `did`, attaches it to any
// tags, registers it in the `documents` store, and makes it the `current`
// document. Documents are referenced by id elsewhere (e.g. by tag.typ and
// by a future bibliography/record layer).

#import "uid.typ": namespaces, v3
#import "types.typ": author, image
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

// The metadata schema: the core fields a `meta` document carries.
#let _core_doc = record(
  "Metadata: [Core]",
  id: str,
  parent_id: str,
  did: str,

  title: content,
  authors: array, // content/string names or author records; always an array

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

