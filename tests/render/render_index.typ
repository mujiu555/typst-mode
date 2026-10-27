// Function test: render/render_index
// Manual: typst compile --root . tests/render/render_index.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#mkindex("unit", [Target])
#lookup("unit", [Reference])
#render-index(title: [Custom Index])
#context {
 assert.eq(query(heading).first().body, [Custom Index])
 assert.eq(query(heading).first().outlined, false)
 assert.eq(backlinks("unit").len(), 1, message: "Rendering must not create backlinks")
 assert.eq(query(link).len(), 3)
}
