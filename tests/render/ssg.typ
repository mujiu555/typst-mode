// typst compile --root . --features html,bundle --format bundle tests/render/ssg.typ /tmp/tysty-ssg
#import "/lib/_lib.typ/lib.typ": *
#show: ssg.render.site

// Calculate routes before emitting bundle documents. Bundle pages are
// top-level outputs; Typst does not allow a bundle document inside embed.
#assert.eq(ssg.render.route("home", root: true), "index.html")
#assert.eq(ssg.render.route("Research"), "research/index.html")
#assert.eq(ssg.render.route("Lit Review", ancestors: ("Research",)), "research/lit-review/index.html")

#entry(id: "home", title: [Home], authors: ())
#embed[
  #meta(id: "research", parent_id: "home", title: [Research], authors: ())
  #mkdoc[Research notes.]
  #embed[
    #meta(id: "review", parent_id: "research", title: [Literature review], authors: ())
    #mkdoc[Review content.]
  ]
]
