// expect-error: conflicts with a reserved name
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/record.typ": record
#let T = enumerator(..(("_variants"): int))
