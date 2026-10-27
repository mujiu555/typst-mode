#import "/lib/_lib.typ/decorate.typ": *
#let identity = decorate((..args) => args)
#assert.eq(identity(1, x: "").pos(), (1,))
#assert.eq(identity(1, x: "").named(), (x: ""))
#let wrapped = decorate(
  (x, scale: 1) => x * scale,
  prev: (x) => { assert.eq(x, 3) },
  before: (x, add: 0) => arguments(x + add),
  after: (x, subtract: 0) => x - subtract,
  fwd: x => { assert.eq(x, 9) },
)
#assert.eq(wrapped(3, _b: (add: 2), _f: (scale: 2), _a: (subtract: 1)), 9)
#assert.eq(decorate(() => none)(), none)
#assert.eq(decorate-cps((x, y: 1) => x + y)()(2, y: 3), 5)
#assert.eq(decorate-cps(x => x)(before: (next, after, x) => next(after, x + 1))(2), 3)
#assert.eq(decorate-cps(x => x)(mid: (next, x) => next(v => v, x * 2))(3), 6)
