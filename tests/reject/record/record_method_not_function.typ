// expect-error: assertion failed
#import "/lib/_lib.typ/record.typ": *
#let T = impl_record(record(x: int), method: 1)
