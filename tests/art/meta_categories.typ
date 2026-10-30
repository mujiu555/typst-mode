// Manual: typst compile --root . tests/art/meta_categories.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "@local/tysty:0.1.0": *
#let variants = (
 (category.journal)(journal: "J", volume: 0, issue: 0, pages: ""),
 (category.conference)(conference: "C", proceedings: "P"),
 (category.book)(publisher: "P", isbn: "I", edition: "E"),
 (category.bookChapter)(book: "B", pages: "P"),
 (category.thesis)(degree: "D", university: "U"),
 (category.report)(institution: "I", number: "N"),
 (category.preprint)(repository: "R", platform: "P"),
 (category.blogPost)(site: "S", series: "X"), category.null,
)
#for value in variants { meta(id: value.variant, title: [Category], authors: (), category: value) }
#context {
 let docs = (documents.final)()
 assert.eq(docs.len(), variants.len())
 for value in variants { assert.eq((docs.at(value.variant).category.fields)(), (value.fields)()) }
}
