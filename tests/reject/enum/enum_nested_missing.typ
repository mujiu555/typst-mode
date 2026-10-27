// expect-error: not exist
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let E = enumerator(r: record(x: int))
#let e = (E.r)()
