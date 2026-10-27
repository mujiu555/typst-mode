// Function test: render/mkdoc
// Manual: typst compile --root . tests/render/mkdoc.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "unit", title: [Title], authors: ())
#mkdoc(new-page: false)[]
#context {
 assert.eq(query(heading).len(), 1)
 assert.eq(query(heading).first().level, 1)
 assert.eq(indexers().keys(), ("unit",))
}
