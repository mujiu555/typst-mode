// Function test: regressions/record/new_field_collision
// Manual: typst compile --root . tests/regressions/record/new_field_collision.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(fields: str)
#let r = (R.new)(fields: "value")
#assert.eq(r.fields, "value")

