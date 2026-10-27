// expect-failure: assertion failed
#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ": _content-to-text, _truncate-middle
#assert.eq(_truncate-middle([*123456*], max: 3), "1…6")
