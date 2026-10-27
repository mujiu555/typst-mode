// expect-failure: assertion failed
#import "/lib/_lib.typ/lib.typ": *
#let t = (tag.register)("docs", (:)).tag
#meta(id: "a", title: [A], authors: (), tags: (t,))
#context { assert.eq((t.documents.final)(), ("a",)) }
