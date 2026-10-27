// expect-error: conflicts with a reserved name
#import "/lib/_lib.typ/record.typ": *
#let T = impl_record(record(x: int), ..(("_methods"): (self => 1)))
