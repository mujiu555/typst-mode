// typst-mode: categories.typ
// Publication-category taxonomy, defined as an `enum` (tagged union, see
// record.typ). A `category` value has `variant` — which category it is —
// plus a `payload` holding that variant's fields. For example a journal
// article is `category.journal(journal: ..., volume: ..., ...)`.

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

// Re-bind `category.null` from the null-variant *constructor* to a
// ready-made null *instance*, so `category.null` can be used directly as
// the default "no category" value (see `meta`'s default in meta.typ).
#let category = category + (null: (category.null)())
