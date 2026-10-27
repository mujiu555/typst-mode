// expect-error: conflicts with a reserved name
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let T = impl_enum(enumerator(x: int), ..(("_variants"): (self => 1)))
