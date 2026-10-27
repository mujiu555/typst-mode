// expect-error: accepts named fields only
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.new)(1)
