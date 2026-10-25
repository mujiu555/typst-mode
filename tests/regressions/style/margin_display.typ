// Function test: regressions/style/margin_display
// Manual: typst compile --root . tests/regressions/style/margin_display.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _margin_info
#let m = (_margin_info.margin)(1cm)
#let f = (m.display)()
#f([#metadata("kept") <kept>])
#context assert.eq(query(<kept>).len(), 1)

