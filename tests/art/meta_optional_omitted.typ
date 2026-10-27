// Manual: typst compile --root . tests/art/meta_optional_omitted.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "minimal", title: [], authors: ())
#context {
 let d = (current.get)()
 let expected = (id: "minimal", parent_id: "index", title: [], authors: (), date: datetime.today(), lang: "en_US", version: "0.0.1", doi: "(none)", abstract: "", keywords: (), license: "apache-v2", description: "", cover_image: img.null, category: category.null, tags: (), tlb: (:))
 for (key, value) in expected { assert.eq(d.at(key), value, message: "default " + key) }
}
