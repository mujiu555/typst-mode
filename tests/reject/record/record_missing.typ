// expect-error: not exist
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let r = (R.new)()
