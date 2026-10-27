// expect-error: does not contain key
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let E = enumerator(x: int)
#let e = (E.new)("missing", 1)
