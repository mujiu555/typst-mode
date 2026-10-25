// Function test: render/mkheading
// Manual: typst compile --root . tests/render/mkheading.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "unit", title: [Title], authors: ())
#mkheading(new-page: false)
#context {
 assert.eq(query(heading).len(), 1)
 assert.eq(query(heading).first().level, 1)
 assert.eq(indexers().keys(), ("unit",))
}
