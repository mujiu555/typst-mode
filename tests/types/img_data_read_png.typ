// Manual: typst compile --root . tests/types/img_data_read_png.typ /tmp/img-data-read.pdf
// Uses the existing local PNG; creates no binary fixture in the project.
#import "/lib/_lib.typ/lib.typ": *
#let data = read("../../tmp/_uidcheck.png", encoding: none)
#assert.eq(data.slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#let value = (img.data)(p: data)
#assert.eq(value.payload.p, data)
#meta(id: "read-png", title: [PNG read in caller space], authors: (), cover_image: value)
#mkcover()
#context { assert.eq(query(image).len(), 1); assert.eq(query(title).len(), 1) }
