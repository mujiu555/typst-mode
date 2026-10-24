#import "doc.typ": _core_doc
#import "types.typ": image
#import "categories.typ": category
#import "style.typ": _page_info

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
