// Function test: regressions/enum/register_compare
// Manual: typst compile --root . tests/regressions/enum/register_compare.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/enum.typ": enumerator
#let E = enumerator(a: int)
#let F = (E._register)("b", str)
#assert(not (E.compare)(F))
