#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Manual: typst compile --root . tests/art/meta_all_fields.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png
#let tree = (tag.register)("test", (topic: (:),))
#let (root, topic) = (tree.tag, tree.children.topic.tag)
#let expected = (id: "all-fields",
parent_id: "all-fields",
file_path: "https://example.org/all-fields",
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
 assert.eq((d.fields)().keys().len(), expected.len())
 assert.eq(((documents.final)().at(expected.id).fields)(), (d.fields)())
 assert.eq((topic.get-doc)().map(d => d.id), (expected.id,))
}

#mkcover()
#mkdoc(new-page: false)[]
#context {
 assert.eq(rendered-text().matches(regex("Complete metadata")).len(), 2, message: "One cover title and one heading")
 assert.eq(query(heading).len(), 1)
 assert.eq(indexers().keys(), (expected.id,))
 assert.eq(query(image).len(), 1)
}
