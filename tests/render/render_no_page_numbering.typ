#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", title: [A], authors: ())
#mkdoc(new-page: false)[]
#render-children([Children])
#meta(id: "b", parent_id: "a", title: [B], authors: ())
#mkdoc()[]
