// Manual: typst compile --root . tests/types/img_path_user_space.typ /tmp/typst-expanded-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let source = "/tests/fixtures/background.png"
#assert.eq(read(source, encoding: none).slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#image(source, width: 10mm)
#let value = (img.path)(p: source)
#assert.eq(value.payload.p, source)
#image(value.payload.p, width: 10mm)
#context assert.eq(query(image).len(), 2)
