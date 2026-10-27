// expect-error: conflicts with a reserved name
#import "/lib/_lib.typ/record.typ": *
#let T = record(..(("_type_id"): int))
