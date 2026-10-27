// expect-error: expected int
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let E = enumerator(x: int)
#let e = (E.x)("1")
