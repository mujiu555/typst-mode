
#import "record.typ": record
#import "enum.typ": enumerator, impl_enum

// Author schema (not yet validated/used by `meta`, kept for the record
// layer).
#let author = record(
  name: str,
  affiliation: str,
  email: str,
  orcid: str,
)

#let img = enumerator(
  path: record(p: str), // TODO: use path
  data: record(p: bytes), // user to read the file `(img.data)(p: read("file"))`
  null: record(),
)
#let img = img + (null: (img.null)())
