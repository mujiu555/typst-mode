// HISTORICAL API CHECK: display/render methods were removed from style.typ.
// Missing-method failures mean the feature is unavailable, not that the old implementation still runs.
// Function test: regressions/style/page_info_display
// Manual: typst compile --root . tests/regressions/style/page_info_display.typ /tmp/typst-unit-test.pdf
// Regression: asserts intended behavior; currently fails in the library.
#import "/lib/_lib.typ/style.typ": _page_info, _page_size, _margin_info, _numbering_style
#import "/lib/_lib.typ/types.typ": img
#let p = (_page_info.new)(size: _page_size.a4, flipped: false, margin: (_margin_info.margin)(1cm), footer-descent: 0% + 0pt, header-ascent: 0% + 0pt, fill: white, background: img.null, foreground: img.null, footer: () => [], header: () => [], numbering: (_numbering_style.null)(), supplement: "Page")
#show: (p.display)()
BODY

#metadata("body") <page-info-body>
#context assert.eq(query(<page-info-body>).len(), 1)
