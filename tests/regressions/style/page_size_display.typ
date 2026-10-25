// Function test: regressions/style/page_size_display
// Manual: typst compile --root . tests/regressions/style/page_size_display.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _page_size
#let f = (_page_size.a4.display)()
#f([#metadata("kept") <kept>])
#context assert.eq(query(<kept>).len(), 1)

