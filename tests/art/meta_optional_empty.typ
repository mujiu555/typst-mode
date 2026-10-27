// Manual: typst compile --root . tests/art/meta_optional_empty.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
// Empty values for each string/content/collection; date remains a valid datetime.
#meta(id: "", parent_id: "", title: [], authors: (), date: datetime(year: 2000, month: 1, day: 1), lang: "", version: "", doi: "", abstract: "", keywords: (), license: "", description: "", cover_image: img.null, category: category.null, tags: (), tlb: (:))
#context {
 let d = (current.get)()
 for key in ("id", "parent_id", "lang", "version", "doi", "abstract", "license", "description") { assert.eq(d.at(key), "") }
 for key in ("authors", "keywords", "tags") { assert.eq(d.at(key), ()) }
 assert.eq(d.title, [])
 assert.eq(d.tlb, (:))
 assert.eq(d.category.variant, "null")
 assert.eq(d.cover_image.variant, "null")
 assert.eq((documents.final)().keys(), ("",))
}
#mkdoc(new-page: false)[]
#mkcover()
#context assert.eq((current.get)().title, [])
