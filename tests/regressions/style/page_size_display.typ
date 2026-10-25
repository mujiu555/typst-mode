// HISTORICAL API CHECK: display/render methods were removed from style.typ.
// Missing-method failures mean the feature is unavailable, not that the old implementation still runs.
// Function test: regressions/style/page_size_display
// Manual: typst compile --root . tests/regressions/style/page_size_display.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _page_size
#let f = (_page_size.a4.display)()
#f([#metadata("kept") <kept>])
#context assert.eq(query(<kept>).len(), 1)

