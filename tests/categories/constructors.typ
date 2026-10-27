// Function test: categories/constructors
// Manual: typst compile --root . tests/categories/constructors.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let values = (
 (category.journal)(journal: "J", volume: 1, issue: 2, pages: "1-5"),
 (category.conference)(conference: "C", proceedings: "P"),
 (category.book)(publisher: "P", isbn: "I", edition: "1"),
 (category.bookChapter)(book: "B", pages: "1-2"),
 (category.thesis)(degree: "D", university: "U"),
 (category.report)(institution: "I", number: "N"),
 (category.preprint)(repository: "R", platform: "P"),
 (category.blogPost)(site: "S", series: "X"), category.null,
)
#assert.eq(values.map(v => v.variant), ("journal", "conference", "book", "bookChapter", "thesis", "report", "preprint", "blogPost", "null"))
#assert.eq((values.first().fields)(), (journal: (journal: "J", volume: 1, issue: 2, pages: "1-5")))
#assert.eq((category.null.fields)(), (null: (:)))
