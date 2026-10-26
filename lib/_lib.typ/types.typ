
#import "record.typ": record
#import "enum.typ": enumerator, impl_enum

#let author = record(
  name: str,
  affiliation: str,
  email: str,
  home: str,
  orcid: str,
)

#let img = enumerator(
  path: record(p: str), // TODO: use path
  data: record(p: bytes), // user to read the file `(img.data)(p: read("file", encoding: none))`
  null: record(),
)
#let img = img + (null: (img.null)())
