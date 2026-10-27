#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/art.typ": _validate-parent
#_validate-parent((a: (parent_id: "a"), b: (parent_id: "a"), c: (parent_id: "b")), "c")
