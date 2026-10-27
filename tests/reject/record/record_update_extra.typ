// expect-error: unknown record field
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.update)((R.new)(x: 1), y: 2)
