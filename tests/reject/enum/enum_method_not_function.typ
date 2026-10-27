// expect-error: assertion failed
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let T = impl_enum(enumerator(x: int), method: 1)
