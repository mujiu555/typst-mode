#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ": _authors, _content-to-text, _details, _truncate-middle, entities
#show: template
#set page(numbering: "i")
#let tree = (tag.register)("render", (child: (:), unused: (:)))
#assert.eq(_content-to-text("abc"), "abc")
#assert.eq(_content-to-text([abc]), "abc")
#assert.eq(_content-to-text([a#text("b")c]), "abc")
#assert.eq(_truncate-middle("12345", max: 5), "12345")
#assert.eq(_truncate-middle("123456", max: 5), "12…56")
#assert.eq(_truncate-middle("123456", max: 4), "12…6")
#assert.eq(_truncate-middle("123", max: 1), "…")
#assert.eq(_truncate-middle("👩‍🔬abcdef", max: 3), "👩‍🔬…f")
#assert.eq(_truncate-middle([abc]), [abc])
#assert.eq(_authors((authors: ())), none)
#assert.eq(_authors((authors: ("A", "B"))), "A, B")
#outline()
#render-tags(tree)
#lookup("child", [Forward])
#meta(
  id: "parent",
  title: [Parent],
  authors: ("A",),
  date: datetime(year: 2024, month: 2, day: 29),
  tags: (tree.tag,),
  abstract: "Abstract",
)
#mkcover()
#mkdoc(new-page: false)[
  #render-children([Children])
  #embed[
    #meta(
      id: "child",
      parent_id: "parent",
      title: [Child],
      authors: ((author.new)(name: "B", affiliation: "", email: "", home: "https://example.org", orcid: ""),),
      tags: (tree.children.child.tag,),
    )
    #mkdoc()[
      #render-children([No children])
      #lookup("parent", [Back])

    ]
  ]
  #meta(id: "hidden", parent_id: "parent", title: [Hidden], authors: (), tags: (tree.tag,))
  #mkindex("", [])
  #lookup("", [Empty label])
  #lookup("child", [Second])
  #context {
    assert.eq((entities.final)(), ("parent", "child"))
    assert.eq(indexers().keys().sorted(), ("", "child", "parent"))
    assert.eq(backlinks("child").len(), 2)
    assert.eq(backlinks("parent").len(), 1)
    assert.eq(backlinks("missing"), ())
    assert.eq(backlinks("").first().content, [Empty label])
    assert.eq(type(backlinks("child").first().loc), location)
    let hs = query(heading).filter(h => h.outlined)
    assert.eq(hs.map(h => h.level), (1, 2))
    assert.eq(query(<typst-mode-index-label>).len(), 3)
    assert.eq(_details((documents.final)().at("parent")).len(), 3)
  }
]
