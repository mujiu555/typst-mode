// typst-mode: categories.typ
// Publication-category taxonomy, defined as an `enum` (tagged union, see
// record.typ). A `category` value has `variant` — which category it is —
// plus a `payload` holding that variant's fields. For example a journal
// article is `category.journal(journal: ..., volume: ..., ...)`.

#import "record.typ": impl_record, record
#import "enum.typ": enum

// Tagged union: `variant` selects the publication type, `content` carries
// the type-specific fields.
#let category = enum(
  "Publication category",
  journal: record(
    journal: str,
    volume: int,
    issue: int,
    pages: str,
  ),
  conference: record(
    conference: str,
    proceedings: str,
  ),
  book: record(
    publisher: str,
    isbn: str,
    edition: str,
  ),
  bookChapter: record(
    book: str,
    pages: str,
  ),
  thesis: record(
    degree: str,
    university: str,
  ),
  report: record(
    institution: str,
    number: str,
  ),
  preprint: record(
    repository: str,
    platform: str,
  ),
  blogPost: record(
    site: str,
    series: str,
  ),
  null: record(),
)

// Re-bind `category.null` from the null-variant *constructor* to a
// ready-made null *instance*, so `category.null` can be used directly as
// the default "no category" value (see `meta`'s default in meta.typ).
#let category = category + (null: (category.null)())
