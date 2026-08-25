// Tests for lib/_lib.typ/decorate.typ.
//
// The whole file is a test: `typst compile --root . tests/decorate/test.typ`
// only succeeds if every `#assert` passes. Negative cases that would abort
// compilation are kept as comments.
//
// A hook's parameters that are fed by the reserved wrapper arguments `_b`
// / `_a` arrive as *named* arguments, so they must be declared with a default
// in the hook (Typst cannot pass positional parameters by name):
//   before: (k: 0, a, b) => ...
//   after:  (a, n: 0) => ...

#import "/lib/_lib.typ/decorate.typ": decorate, decorate-cps

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[decorate — function decoration]

// ---------------------------------------------------------------------
// 1. Passthrough
// ---------------------------------------------------------------------
#heading(level: 2)[1. Passthrough]

// With every hook at its default, the wrapper behaves like the original.
#let add = (a, b) => a + b
#let plain = decorate(add)
#assert.eq((plain)(2, 3), 5, message: "default hooks: passthrough")

// ---------------------------------------------------------------------
// 2. `before` rewrites the arguments
// ---------------------------------------------------------------------
#heading(level: 2)[2. `before` rewrites arguments]

// `_b` carries named arguments into `before`; the positional args stay.
// `k` must be named (has a default) because `_b` feeds it by name.
#let scale = decorate(add, before: (k: 1, a, b) => (a * k, b * k))
#assert.eq((scale)(1, 2, _b: (k: 2)), 6, message: "before scales both args")
#assert.eq((scale)(1, 2), 3, message: "before falls back to its default")

// ---------------------------------------------------------------------
// 3. `after` post-processes the result
// ---------------------------------------------------------------------
#heading(level: 2)[3. `after` rewrites the result]

// `_a` feeds named arguments into `after`; the function result arrives as
// the first positional argument.
#let bump = decorate(add, after: (a, n: 0) => a + n)
#assert.eq((bump)(2, 3, _a: (n: 10)), 15, message: "after adds n")
#assert.eq((bump)(2, 3), 5, message: "after falls back to its default")

// ---------------------------------------------------------------------
// 4. `_f` feeds named arguments into the wrapped function
// ---------------------------------------------------------------------
#heading(level: 2)[4. `_f` feeds the wrapped function]

#let flag = (a, on: false) => if on { a * 100 } else { a }
#let flagged = decorate(flag)
#assert.eq((flagged)(3, _f: (on: true)), 300, message: "_f forwards named args to fn")

// ---------------------------------------------------------------------
// 5. `prev` observes the raw arguments
// ---------------------------------------------------------------------
#heading(level: 2)[5. `prev` sees raw arguments]

// `prev` runs first, before `before`, so it must see the unmodified args.
// Effects are checked with assertions inside the hook: if the wrapper ever
// reordered or skipped the hooks, these asserts would fail compilation.
#let spy = decorate(
  add,
  prev: (a, b) => {
    assert.eq(a, 2, message: "prev sees raw a")
    assert.eq(b, 3, message: "prev sees raw b")
  },
  before: (k: 0, a, b) => (a + k, b + k),
)
#assert.eq((spy)(2, 3, _b: (k: 10)), 25, message: "prev before before")

// ---------------------------------------------------------------------
// 6. `fwd` observes the final result
// ---------------------------------------------------------------------
#heading(level: 2)[6. `fwd` sees the final result]

// `fwd` runs last, after `after`, so it must see the fully-processed result.
#let watcher = decorate(
  add,
  after: (a, n: 0) => a + n,
  fwd: (r) => assert.eq(r, 24, message: "fwd sees post-after result"),
)
#assert.eq((watcher)(1, 2, _a: (n: 21)), 24, message: "fwd after after")

// ---------------------------------------------------------------------
// 7. Full chain
// ---------------------------------------------------------------------
#heading(level: 2)[7. Full chain]

// prev -> before -> fn -> after -> fwd. prev sees the raw args, fwd the final
// result, and `before`/`after` feed each other through the wrapper.
#let chain = decorate(
  add,
  prev: (a, b) => {
    assert.eq(a, 1, message: "chain prev sees raw a")
    assert.eq(b, 2, message: "chain prev sees raw b")
  },
  before: (k: 0, a, b) => (a + k, b + k),
  after: (a, n: 0) => a + n,
  fwd: (r) => assert.eq(r, 24, message: "chain fwd sees final result"),
)
#assert.eq(
  (chain)(1, 2, _b: (k: 10), _a: (n: 1)),
  24,
  message: "chain: (1,2) -> before +10 -> 23 -> after +1 -> 24",
)

// ---------------------------------------------------------------------
// 8. CPS variant
// ---------------------------------------------------------------------
#heading(level: 2)[8. decorate-cps]

// `(decorate-cps)(fn)` returns a configurator whose named parameters
// `mid` / `before` / `after` default to the identity composition.
#let cps = (decorate-cps)(add)
#assert.eq(((cps)())(1, 2), 3, message: "cps default identity")

// A custom `after` continues the computation with a modified value.
#let bump2 = ((decorate-cps)(add))(after: (next, a, ..rest) => next(a + 1))
#assert.eq((bump2)(1, 2), 4, message: "cps custom after")

// A custom `before` rewrites the arguments before `fn` runs.
#let double = ((decorate-cps)(add))(before: (next, after, a, b) => next(after, a * 2, b * 2))
#assert.eq((double)(1, 2), 6, message: "cps custom before")

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]
#render((plain)(2, 3))
#render((scale)(1, 2, _b: (k: 2)))
#render((bump)(2, 3, _a: (n: 10)))
#render((flagged)(3))
#render((chain)(1, 2, _b: (k: 10), _a: (n: 1)))
