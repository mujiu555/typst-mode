// expect-error: tag children must be a dictionary: b
#import "/lib/_lib.typ/lib.typ": *
#let t = (tag.register)("n", (a: (b: ())))
