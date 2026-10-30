// Bundle generation and ref embed the saved body, preserving document scope.
#import "@local/tysty:0.1.0": *
#show: template
#meta(id: "home", title: [Home], authors: ())
#ssg.render.mkdoc[
  Root body.
  #ssg.ref("snippet")
  #context assert.eq((current.get)().id, "home")
  #ssg.mkoutline()
]
#ssg.render.embed[
  #meta(id: "snippet", parent_id: "home", title: [Snippet], authors: ())
  #ssg.render.mkdoc[
    SHARED-SNIPPET-BODY
    #context {
      assert.eq((current.get)().id, "snippet")
      assert(ssg.render.is-bundle-output())
    }
  ]
]
#context assert.eq((current.get)().id, "home")
