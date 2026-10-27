// expect-error: missing argument
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let E = enumerator(x: int)
#let e = (E.x)()
