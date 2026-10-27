// Manual: typst compile --root . tests/types/img_data_null.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png
#let data = (img.data)(p: png)
#assert.eq(data.variant, "data")
#assert.eq(data.payload.p, png)
#assert.eq((img.null.fields)(), (null: (:)))
#image(data.payload.p)
#meta(id: "no-image", title: [No image], authors: (), cover_image: img.null)
#mkcover()
#context assert.eq(query(image).len(), 1, message: "Null cover must add no image")
