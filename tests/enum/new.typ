// Function test: enum/new
// Manual: typst compile --root . tests/enum/new.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(number: int, point: record(x: int), empty: record())
#let n = (E.new)("number", 5)
#assert.eq(n.variant, "number")
#assert.eq(n.payload, 5)
#assert.eq((E.point)(x: 9).payload.x, 9)
#assert.eq(((E.empty)().fields)(), (:))
