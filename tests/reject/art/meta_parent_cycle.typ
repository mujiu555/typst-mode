// expect-error: Cyclic parent relationship
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", parent_id: "b", title: [A], authors: ())
#meta(id: "b", parent_id: "a", title: [B], authors: ())
