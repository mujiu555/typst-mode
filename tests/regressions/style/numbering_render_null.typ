// HISTORICAL API CHECK: display/render methods were removed from style.typ.
// Missing-method failures mean the feature is unavailable, not that the old implementation still runs.
// Function test: _numbering_style.render for null.
// Regression: no numbering should produce no content, not an undefined-variable error.
// Manual: typst compile --root . tests/regressions/style/numbering_render_null.typ /tmp/numbering-null.pdf
#import "/lib/_lib.typ/style.typ": _numbering_style
#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
#let n = (_numbering_style.null)()
#(n.render)()
#context assert.eq(query(<test-rendered-text>).len(), 0)
