// expect-error: do not match
#import "/lib/_lib.typ/record.typ": *
#let R = record(x: int)
#let T = record(r: R)
#let x = (T.new)(r: (x: 1))
