// Function test: regressions/style/numbering_null
// Manual: typst compile --root . tests/regressions/style/numbering_null.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _page_size, _margin_info, _numbering_style, _page_info
#let n = (_numbering_style.null)()
#show: (n.display)()
#context assert.eq(page.numbering, none)
