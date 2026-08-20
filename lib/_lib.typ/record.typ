// Structural type match: `t` is the expected type, `v` the actual value.
// Raw types (`int`, `str`, ...) match against `type(v)`; record types match
// against the type stored in a value's `_type`.
#let _match = (t, v) => {
  let tv = type(v)
  if type(t) == type {
    // a raw type such as `int` or `str`: compare directly
    t == tv
  } else if tv == dictionary and dictionary.keys(v).contains("_type") {
    let tv = v.at("_type", default: auto)
    (t.compare)(tv)
  } else {
    (t.compare)(tv)
  }
}

// Structural type comparison: every field of `self` must exist in `other`
// with a matching type. Extra fields on `other` are allowed (asymmetric /
// structural-subtype behaviour).
#let _compare(self, other) = {
  let same = true
  for (name, t) in self._fields {
    let ot = other._fields.at(name, default: auto)
    assert(ot != auto)
    same = (
      same
        and if type(t) == type {
          t == ot
        } else {
          (t.compare)(ot)
        }
    )
    if not same {
      break
    }
  }
  same
}

// NOTE: adopt form typsy
#let _fetch_method(self, fn, methods) = {
  let m = (:)
  for name in methods {
    m.insert(name, fn(name))
  }
  self + m
}

#let _new(self, ..rest) = {
  let instance = (_type: self)

  for (f, ty) in self._fields {
    let v = rest.at(f, default: none)
    assert(v != none)
    assert(_match(ty, v))
    instance.insert(f, v)
  }

  for (m, (name: name, type: ty, fn: fn)) in self._methods {
    assert(fn != none)
    instance.insert(m, fn)
  }

  let this_call(method) = {
    let fn = instance.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(instance, this_call, self._methods.keys()), ..rest)
  }
  instance + _fetch_method(instance, this_call, self._methods.keys())
}

// Copy-and-replace update: validate every field of `instance`, then construct
// a new instance overriding the given fields.
#let _update(self, instance, ..rest) = {
  let newobj = (:)

  for (k, expected-type) in self._fields {
    let value = instance.at(k, default: none)
    assert(value != none)
    assert(_match(expected-type, value))
    newobj.insert(k, value)
  }

  (self.new)(..(newobj + arguments.named(rest)))
}

#let _record_built-ins = (
  compare: _compare,
  new: _new,
  update: _update,
)

/// Defines a record
///
/// *Example*
///
/// ```typst
/// #let Adder = record(
///   fields: (x: Int),
/// )
/// ```
///
/// You can compare types by:
/// ```typst
/// #Adder.compare(Another-Type)
/// ```
///
/// *Returns:*
///
/// A record type.
///
/// *Arguments:*
///
/// - fields (dictionary): field-type pairs
#let record(..fields) = {
  let _description = arguments.pos(fields).join()
  let _fields = arguments.named(fields)

  let ty = (
    _fields: _fields,
    _methods: (:),
    description: _description,
  )
  let this_call(method) = {
    let fn = _record_built-ins.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(ty, this_call, _record_built-ins.keys()), ..rest)
  }

  ty + _fetch_method(ty, this_call, _record_built-ins.keys())
}

#let impl(ty, ..fns) = {
  let fns = arguments.named(fns)

  for (name, fn) in fns {
    ty._methods.insert(name, (name: name, type: ty, fn: fn))
    ty.insert(name, fn)
  }

  // Update type built-ins
  let this_call(method) = {
    let fn = _record_built-ins.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(ty, this_call, _record_built-ins.keys()), ..rest)
  }
  ty + _fetch_method(ty, this_call, _record_built-ins.keys())
}

#let enum = (variants: (:), description, new) => {
  // TODO:
}
