// expect-failure: type none has no method `clusters`
#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ": _content-to-text, _truncate-middle
#assert.eq(_truncate-middle([]), [])
