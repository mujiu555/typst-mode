// INTERNAL DIAGNOSTIC: _register is now explicitly private, not a supported extension API.
// Function test: regressions/enum/register
// Manual: typst compile --root . tests/regressions/enum/register.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(a: int)
#let E = (E._register)("b", str)
#let b = (E.b)("ok")
#assert.eq(b.payload, "ok")

