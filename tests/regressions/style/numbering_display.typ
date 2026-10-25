// Function test: regressions/style/numbering_display
// Manual: typst compile --root . tests/regressions/style/numbering_display.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _numbering_style
#let n = (_numbering_style.num)(prefix: "", suffix: "")
#show: (n.display)()
#context assert.eq(page.numbering, "1")
BODY
