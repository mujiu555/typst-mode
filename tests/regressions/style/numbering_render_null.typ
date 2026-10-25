// Function test: _numbering_style.render for null.
// Regression: no numbering should produce no content, not an undefined-variable error.
// Manual: typst compile --root . tests/regressions/style/numbering_render_null.typ /tmp/numbering-null.pdf
#import "/lib/_lib.typ/style.typ": _numbering_style
#let n = (_numbering_style.null)()
#(n.render)()
#context assert.eq(query(text).len(), 0)
