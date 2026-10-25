// Function test: regressions/record/new_none
// Manual: typst compile --root . tests/regressions/record/new_none.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: type(none))
#let r = (R.new)(x: none)
#assert.eq(r.x, none)

