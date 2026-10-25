// Manual: typst compile --root . tests/render/mkheading_png_background.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png
#set page(width: 160mm, height: 110mm, margin: 12mm, background: [
 #image(png, width: 100%, height: 100%, fit: "stretch")
 #metadata("PNG background") <png-background>
])
#meta(id: "png-heading", title: [PNG heading], authors: (), cover_image: (img.data)(p: png))
#mkheading(new-page: false)
#context {
 assert(query(<png-background>).len() >= 1, message: "Background must be laid out")
 assert(query(image).len() >= 1, message: "PNG image elements must be laid out")
 assert.eq(query(heading).len(), 1)
 assert.eq((current.get)().cover_image.payload.p, png)
}
// Manual visual check: pale-blue background behind readable title.
