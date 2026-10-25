// Manual: typst compile --root . tests/regressions/render/mkcover_png_path_background.typ /tmp/typst-expanded-test.pdf
// Requires a compiler/helper with file-path values. Typst 0.14.2 path is a
// drawing function and rejects the string before this test reaches img.path.
#import "/lib/_lib.typ/lib.typ": *
// Fixture: existing tmp/_uidcheck.png, resolved in this caller's directory.
#let source = path("../../../tmp/_uidcheck.png")
#assert.eq(read(source, encoding: none).slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#set page(background: image(source, width: 100%, height: 100%, fit: "cover"))
#meta(id: "path-cover", title: [Path PNG], authors: (), cover_image: (img.path)(p: source))
#mkcover()
#context { assert(query(image).len() >= 1); assert.eq(query(title).len(), 1) }
