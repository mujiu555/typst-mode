// typst-mode: util.typ
// Structural type-system helpers shared by record.typ and enum.typ:
//   _match        — does a value `v` match an expected type `t`?
//   _fetch_method — bind a batch of methods into a copy of `self`.

// Structural type match: `t` is the expected type, `v` the actual value.
// Raw types (`int`, `str`, ...) match against `type(v)`; record types match
// against the type stored in a value's `_type`.
#let _match(t, v) = {
  let tv = type(v)
  if t == none {
    // `none` means "unconstrained" — any value passes
    true
  } else if type(t) == type {
    // a raw type such as `int` or `str`: compare directly
    t == tv
  } else if tv == dictionary and dictionary.keys(v).contains("_type") {
    // `v` is a record instance: compare its `_type` against the expected one
    let tv = v.at("_type", default: auto)
    (t.compare)(tv)
  } else {
    // `t` is a record type but `v` is not a record → cannot match
    false
  }
}

// Bind a batch of methods into a copy of `self`.
// `fn(name)` must return a function of shape `(self, ..rest) => ...`; the
// result maps every method name to `fn(name)`. Callers pass `fn` as the
// `this_call` closure, which is what keeps `self` pointing at the current
// (possibly extended) type or instance.
#let _fetch_method(self, fn, methods) = {
  let m = (:)
  for name in methods {
    m.insert(name, fn(name))
  }
  self + m
}
