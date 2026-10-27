#import "/lib/_lib.typ/types.typ": *
#import "/lib/_lib.typ/util.typ": _match
#let person = (author.new)(name: "Ada", affiliation: "", email: "", home: "https://example.org", orcid: "")
#assert.eq((person.fields)().name, "Ada")
#assert(_match(img, img.null))
#assert.eq(((img.path)(p: "").fields)(), (path: (p: "")))
#assert.eq(((img.data)(p: bytes(())).fields)(), (data: (p: bytes(()))))
#assert(_match(category, category.null))
#for (name, values) in (
  journal: (journal: "J", volume: 0, issue: -1, pages: ""),
  conference: (conference: "C", proceedings: ""),
  book: (publisher: "P", isbn: "", edition: ""),
  bookChapter: (book: "B", pages: "1–2"),
  thesis: (degree: "D", university: "U"),
  report: (institution: "I", number: ""),
  preprint: (repository: "R", platform: ""),
  blogPost: (site: "S", series: ""),
) {
  let value = (category.at(name))(..values)
  assert(_match(category, value))
  assert.eq((value.fields)(), ((name): values))
}
#assert.eq((category.null.fields)(), (null: (:)))
