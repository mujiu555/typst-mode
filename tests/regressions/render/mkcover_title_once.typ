// Manual: typst compile --root . tests/regressions/render/mkcover_title_once.typ /tmp/typst-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
#meta(id: "cover", title: [COVERSENTINEL], authors: ())
#mkcover()
#context assert.eq(rendered-text().matches(regex("COVERSENTINEL")).len(), 1, message: "Cover title must appear exactly once")
