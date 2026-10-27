// expect-error: assertion failed
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.update)((:), x: 2)
