// Function test: enum/with
// Manual: typst compile --root . tests/enum/with.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(point: record(x: int, y: int))
#let make = (E.with)("point", x: 2)
#assert.eq((make(y: 5).fields)(), (point: (x: 2, y: 5)))
