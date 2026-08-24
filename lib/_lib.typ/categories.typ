
#import "record.typ": enum, impl, record

// Tagged union: `variant` selects the publication type, `content` carries
// the type-specific fields.
#let category = enum(
  "Publication category",
  journal: (
    journal: str,
    volume: int,
    issue: int,
    pages: str,
  ),
  conference: (
    conference: str,
    proceedings: str,
  ),
  book: (
    publisher: str,
    isbn: str,
    edition: str,
  ),
  bookChapter: (
    book: str,
    pages: str,
  ),
  thesis: (
    degree: str,
    university: str,
  ),
  report: (
    institution: str,
    number: str,
  ),
  preprint: (
    repository: str,
    platform: str,
  ),
  blogPost: (
    site: str,
    series: str,
  ),
  null: (),
)

#let category = category + (null: (category.null)())
