// expect-error: accepts named fields only
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.update)((R.new)(x: 1), 2)
