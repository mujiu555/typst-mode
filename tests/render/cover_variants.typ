#import "/lib/_lib.typ/lib.typ": *
#let person = (author.new)(name: "Ada", affiliation: "Lab", email: "a@example.org", home: "https://example.org", orcid: "0000")
#meta(
  id: "path", title: [Path cover], authors: (person, "Bob"),
  file_path: "https://example.org/path", date: datetime(year: 2000, month: 1, day: 1),
  lang: "zh_CN", version: "2.0", doi: "10/example", abstract: "Summary",
  keywords: ("one", "two"), license: "MIT", description: "Description",
  cover_image: (img.path)(p: "/tests/fixtures/pixel.svg"),
  category: (category.journal)(journal: "J", volume: 1, issue: 2, pages: "3"),
  tlb: (custom: [Value]),
)
#mkcover()
#context {
  let d = (current.get)()
  assert.eq(d.file_path, "https://example.org/path")
  assert.eq(d.lang, "zh_CN")
  assert.eq(d.version, "2.0")
  assert.eq(d.doi, "10/example")
  assert.eq(d.abstract, "Summary")
  assert.eq(d.keywords, ("one", "two"))
  assert.eq(d.license, "MIT")
  assert.eq(d.description, "Description")
  assert.eq(d.tlb.custom, [Value])
}
#meta(id: "bytes", title: [Bytes cover], authors: (), cover_image: (img.data)(p: read("/tests/fixtures/pixel.svg", encoding: none)))
#mkcover()
#context { assert.eq(indexers(), (:)); assert.eq(query(image).len(), 2) }
