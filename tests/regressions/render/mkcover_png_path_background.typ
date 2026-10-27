#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Manual: typst compile --root . tests/regressions/render/mkcover_png_path_background.typ /tmp/typst-expanded-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let source = "/tests/fixtures/background.png"
#assert.eq(read(source, encoding: none).slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
#set page(background: image(source, width: 100%, height: 100%, fit: "cover"))
#meta(id: "path-cover", title: [Path PNG], authors: (), cover_image: (img.path)(p: source))
#mkcover()
#context { assert(query(image).len() >= 1); assert.eq(rendered-text().matches(regex("Path PNG")).len(), 1) }
