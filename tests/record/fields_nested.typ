// Manual: typst compile --root . tests/record/fields_nested.typ /tmp/typst-test.pdf
#import "/lib/_lib.typ/record.typ": record
#import "/lib/_lib.typ/enum.typ": enumerator
#let Point = record(x: int)
#let Choice = enumerator(point: Point, number: int)
#let Container = record(child: Point, choice: Choice)
#let value = (Container.new)(child: (Point.new)(x: 2), choice: (Choice.point)(x: 3))
#assert.eq((value.fields)(), (child: (x: 2), choice: (x: 3)))
#assert.eq((((Container.new)(child: (Point.new)(x: 4), choice: (Choice.number)(7))).fields)(), (child: (x: 4), choice: 7))
