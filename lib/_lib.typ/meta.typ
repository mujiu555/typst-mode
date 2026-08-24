#import "@preview/uuidkit:0.1.0": namespaces, v3

#import "record.typ": record
#import "categories.typ": category
#import "tag.typ": tag
#import "state.typ": _state

#let _ns_doc = v3(namespaces.oid, "aa6f42d8-5c10-49a9-985f-cad16abd219b")
#let _doc_uuid(name) = v3(_ns_doc, name)

#let documents = (_state.new)(
  sym: () => {},
  default: (:),
)

#let current = (_state.new)(
  sym: () => {},
  default: (),
)

#let Author = record(
  name: str,
  affiliation: str,
  email: str,
  orcid: str,
)

#let _Core_doc = record(
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

  category: category,

  tags: array,

  tlb: none,

  loc: location,
)

#let meta(
  id: none,
  parent_id: none,
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
  category: category.null,
  tags: (),
  tlb: (:),
) = context {
  let doc = (_Core_doc.new)(
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

    category: category,

    tags: tags,

    tlb: tlb,

    loc: here(),
  )
  for t in tags {
    (t.add-doc)(doc)
  }

  (documents.update)(
    (documents.get)() + ((id): doc),
  )

  (current.update)(
    doc,
  )
}
