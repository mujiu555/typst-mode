// Manual: typst compile --root . tests/art/meta_all_fields.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png
#import "/lib/_lib.typ/doc.typ": _doc_uuid
#let (root, topic) = (tag.register)("topic")
#let expected = (id: "all-fields",
parent_id: "parent",
title: [Complete metadata],
authors: ("Alice", "Bob"),
date: datetime(year: 2024, month: 2, day: 29),
lang: "zh_CN",
version: "2.3.4",
doi: "10.1234/unit",
abstract: "Abstract text",
keywords: ("typst", "test"),
license: "MIT",
description: "Description text",
cover_image: (img.data)(p: png),
category: (category.journal)(journal: "Journal", volume: 2, issue: 3, pages: "4-8"),
tags: (topic,),
tlb: (taxon: "note", extra: "custom"))
#meta(..expected)
#context {
 let d = (current.get)()
 for (name, value) in expected { assert.eq(d.at(name), value, message: "meta must preserve " + name) }
 assert.eq(d.did, _doc_uuid(expected.id))
 assert.eq(type(d.loc), location)
 assert.eq((d.fields)().keys().len(), expected.len() + 2)
 assert.eq((documents.final)().at(expected.id).did, d.did)
 assert.eq((topic.get-doc)().keys(), (expected.id,))
}

#mkcover()
#mkheading(new-page: false)
#context {
 assert.eq(query(title).first().body, expected.title)
 assert.eq(query(heading).len(), 1)
 assert.eq(indexers().keys(), (expected.id,))
 assert.eq(query(image).len(), 1)
}
