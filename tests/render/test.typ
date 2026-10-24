#import "/lib/_lib.typ/lib.typ": *
#show: template
#let (root, science, mathematics) = (tag.register)("computer-science", "mathematics")
#let sa = (science.sub)("shared")
#let ma = (mathematics.sub)("shared")
#assert.ne(sa.id, ma.id)
#meta(id: "index", title: [Notes], authors: ([Alice],), tags: (science,), abstract: "A collection of notes.")
#mkcover()
#mkheading()
#lookup("child", [Forward reference])
#embed[
  #meta(id: "child", parent_id: "index", title: [Child], authors: ([Bob],), tags: (mathematics, science), tlb: (
    taxon: "theorem",
  ))
  #mkheading()
  == Detail
  #mkindex("term", [A term])
  #lookup("index", [Parent])
  #embed(include "grandchild.typ")
  #context assert.eq((current.get)().id, "child")
]
#context {
  assert.eq((current.get)().id, "index")
  assert.eq((documents.final)().len(), 3)
  assert.eq((science.documents.final)().keys(), ("index", "child"))
  assert.eq((mathematics.documents.final)().keys(), ("child",))
  assert.eq(indexers().keys(), ("index", "child", "term", "grandchild"))
  assert.eq(backlinks("child").len(), 1)
  assert.eq(backlinks("term"), ())
}
#pagebreak()
#render-index()
