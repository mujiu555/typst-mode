#import "doc.typ": _core_doc, current, documents
#import "types.typ": author, category, img
#import "util.typ": _match

#let _validate-parent(docs, id) = {
  let visited = ()
  let current = id

  while true {
    assert(
      current in docs,
      message: "Unresolved document: " + current,
    )
    assert(
      current not in visited,
      message: "Cyclic parent relationship: " + repr(visited + (current,)),
    )

    visited.push(current)
    let parent = docs.at(current).parent_id
    if parent == current {
      break
    }
    current = parent
  }
}

// Declare a document. Most arguments map 1:1 onto `_Core_doc` fields and
#let meta(
  id: none,
  parent_id: auto,
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
      parent_id: if parent_id == auto { id } else { parent_id },
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
  context {
    let docs = (documents.final)()
    _validate-parent(docs, id)
  }
}
