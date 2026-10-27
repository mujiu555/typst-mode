// Function test: enum/fields
// Manual: typst compile --root . tests/enum/fields.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(number: int, point: record(x: int))
#assert.eq((((E.number)(3)).fields)(), 3)
#assert.eq((((E.point)(x: 7)).fields)(), (x: 7))
