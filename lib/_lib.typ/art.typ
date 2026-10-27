#import "doc.typ": _core_doc, current, documents
#import "types.typ": author, category, img
#import "util.typ": _match

// Declare a document. Most arguments map 1:1 onto `_Core_doc` fields and
#let meta(
  id: none,
  parent_id: "index",
  file_path: "(no link (uri))",
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
  cover_image: img.null,
  category: category.null,
  tags: (),
  tlb: (:),
) = {
  context {
    let doc = (_core_doc.new)(
      id: id,
      parent_id: parent_id,
      file_path: file_path,

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
    )

    for v in authors {
      assert(
        _match(str, v) or _match(author, v),
        message: "authors must contain strings or author records",
      )
    }

    // Register under its id, and make it the current document
    (documents.update)(dc => {
      dc + ((id): doc)
    })

    (current.update)(
      doc,
    )
    [#metadata(id) <typst-mode-document-id>]
  }
  context {
    let matches = query(<typst-mode-document-id>).filter(m => m.value == id)
    assert(matches.len() <= 1, message: "ERROR: duplicate document id: `" + id + "`")
  }
}
