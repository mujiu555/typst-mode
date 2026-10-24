
#import "record.typ": record
#import "enum.typ": enum

// Author schema (not yet validated/used by `meta`, kept for the record
// layer).
#let author = record(
  name: str,
  affiliation: str,
  email: str,
  orcid: str,
)

#let image = enum(
  path: record(p: str),
  null: record(),
)
#let image = image + (null: (image.null)())

