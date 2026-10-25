// Function test: regressions/enum/new_variant_collision
// Manual: typst compile --root . tests/regressions/enum/new_variant_collision.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(new: int)
#let v = (E.new)(1)
#assert.eq(v.payload, 1)

