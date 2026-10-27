// Manual: typst compile --root . tests/art/meta_category_null.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "explicit-null", title: [Null category], authors: (), category: category.null)
#mkdoc(new-page: false)[]
#context {
 let d = (current.get)()
 assert.eq(d.category.variant, "null")
 assert.eq((d.category.fields)(), (null: (:)))
 assert((category.compare)(d.category._type))
 assert.eq(indexers().keys(), ("explicit-null",))
}
