// Manual: typst compile --root . tests/types/img_path_user_space.typ /tmp/typst-expanded-test.pdf
// Requires a compiler/helper with file-path values. Typst 0.14.2 path is a
// drawing function and rejects the string before this test reaches img.path.
#import "/lib/_lib.typ/lib.typ": *
// Fixture: existing tmp/_uidcheck.png; path is resolved here, in caller space.
#let source = path("../../tmp/_uidcheck.png")
#assert.eq(read(source, encoding: none).slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#image(source, width: 10mm)
#let value = (img.path)(p: source)
#assert.eq(value.payload.p, source)
#image(value.payload.p, width: 10mm)
#context assert.eq(query(image).len(), 2)
