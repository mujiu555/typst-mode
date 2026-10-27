// FILE FIXTURE: run in an external staging copy with tests/fixtures/background.png
// decoded from tests/fixtures/png.typ. The manual batch under /tmp prepares this;
// no PNG or script is written inside the project.
// Manual: typst compile --root . tests/regressions/render/mkheading_png_path_background.typ /tmp/typst-expanded-test.pdf
// Requires a compiler/helper with file-path values. Typst 0.14.2 path is a
// drawing function and rejects the string before this test reaches img.path.
#import "/lib/_lib.typ/lib.typ": *
#let source = path("../../fixtures/background.png")
#assert.eq(read(source, encoding: none).slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#set page(background: image(source, width: 100%, height: 100%, fit: "cover"))
#meta(id: "path-heading", title: [Path PNG], authors: (), cover_image: (img.path)(p: source))
#mkheading(new-page: false)
#context { assert(query(image).len() >= 1); assert.eq(query(heading).len(), 1) }
