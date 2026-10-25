// Manual: typst compile --root . tests/art/meta_unicode_long.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#let long = "x" * 2048
#meta(id: "笔记/α 🚀", title: [*Rich* title], authors: ([Alice], (name: "Bob")), abstract: long, description: long, keywords: ("重复", "重复", ""), tlb: (taxon: "", custom: (nested: true)))
#mkheading(new-page: false)
#context {
 let d = (current.get)()
 assert.eq(d.id, "笔记/α 🚀")
 assert.eq(d.abstract.len(), 2048)
 assert.eq(d.keywords, ("重复", "重复", ""))
 assert.eq(d.tlb.custom.nested, true)
 assert.eq(indexers().len(), 1)
}
