// expect-error: do not match
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.new)(x: "1")
