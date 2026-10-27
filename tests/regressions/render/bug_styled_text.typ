// expect-failure: assertion failed
#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ": _content-to-text, _truncate-middle
#assert.eq(_content-to-text([*Bold*]), "Bold")
