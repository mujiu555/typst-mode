// expect-error: do not match
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.update)((R.new)(x: 1), x: "2")
