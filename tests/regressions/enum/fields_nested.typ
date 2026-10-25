// Function test: regressions/enum/fields_nested
// Manual: typst compile --root . tests/regressions/enum/fields_nested.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let Inner = enumerator(a: int)
#let Outer = enumerator(inner: Inner)
#let value = (Outer.inner)("a", 2)
#assert.eq((value.fields)(), (value.payload.fields)())
