#let decorate(
  fn,
  prev: (..rest) => none,
  before: (..rest) => rest,
  after: (a, ..rest) => a,
  fwd: (..rest) => none,
) = {
  (_b: (:), _a: (:), _f: (:), ..rest) => {
    prev(..rest)
    let result = after(fn(..before(.._b, ..rest), .._f), .._a)
    fwd(result)

    result
  }
}


#let decorate-cps = fn => {
  let _after = (next, a, ..rest) => next(a)
  let _before = (next, after, ..rest) => next(after, ..rest)
  let _mid = (next, ..rest) => next(v => v, fn(..rest), ..rest)
  (
    mid: _mid,
    before: _before,
    after: _after,
  ) => {
    (..rest) => {
      before(mid, after, ..rest)
    }
  }
}
