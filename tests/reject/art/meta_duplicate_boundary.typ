// expect-error: duplicate document id
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "a", title: [A], authors: ())
#meta(id: "a", title: [A], authors: ())

