#import "uid.typ": namespaces, v3

#let _ns_enum = v3(namespaces.oid, "e4f747b7-fc19-4082-9acf-cd0f1b188bba")
#let _enum_uuid(name) = v3(_ns_enum, name)

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

// Structural type comparison: every field of `self` must exist in `other`
// with a matching type. Extra fields on `other` are allowed (asymmetric /
// structural-subtype behaviour).
#let _compare(self, other) = {
  assert(
    type(other) != type,
    message: "value `" + repr(other) + "` is not a record, can only compare between records",
  )
  // Same `_type_id` → identical declaration, no need to compare fields
  if self._type_id == other._type_id {
    return true
  }
  let same = true
  for (name, t) in self._fields {
    let ot = other._fields.at(name, default: auto)
    if (ot == auto) {
      // `other` is missing this field → not a subtype
      same = false
      break
    }
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

// The `fields` method: return a dictionary of field-name -> value for a
// record instance.
#let _get_fields_enum(self) = {
  let out = (:)
  for (n, t) in self._type._variants.at(self.variant)._fields {
    out.insert(n, self.payload.at(n))
  }
  out
}

#let _new_enum(self, variant, ..rest) = {
  let instance = (_type: self, variant: variant)
  let new = if type == type(self._variants.at(variant)) {
    it => it
  } else {
    self._variants.at(variant).new
  }
  instance = instance + (payload: new(..rest))

  for (m, fn) in self._methods {
    assert(fn != none, message: "must provide a method")
    instance.insert(m, fn)
  }
  let this_call(method) = {
    let fn = instance.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(instance, this_call, self._methods.keys()), ..rest)
  }
  instance + _fetch_method(instance, this_call, self._methods.keys())
}

#let _register_enum(self, variant, ty) = {
  self = self + (_variants: self._variants + ((variant): ty))

  let this_call(variant) = {
    let fn = (self, ..rest) => { (self.new)(variant, ..rest) }
    assert(fn != auto)
    (..rest) => fn(_fetch_method(self, this_call, self._variants.keys()), ..rest)
  }
  self + _fetch_method(self, this_call, self._variants.keys())
}

#let _with_enum(self, variant, ..rest) = {
  (..args) => {
    (self.new)(..rest, variant, ..args)
  }
}

#let _enum_built-ins = (
  compare: _compare,
  new: _new_enum,
  with: _with_enum,
  _register: _register_enum,
)

#let enum(..variants) = {
  let _description = arguments.pos(variants).join("\n")
  let _variants = arguments.named(variants)

  // The "type" is itself just a dictionary: a UUID identifying it, the
  // declared field map, and a method registry seeded with the `fields`
  // accessor. `_methods.fields` has `fn: _get_fields_record`, so every
  // instance automatically carries a `fields` method.
  let ty = (
    _type_id: _enum_uuid(repr(variants)),
    _variants: _variants,
    _methods: (fields: _get_fields_enum),
    description: _description,
  )
  // Re-bind the built-ins so `self` inside them is the type-with-methods.
  let this_call(method) = {
    let fn = _enum_built-ins.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(ty, this_call, _enum_built-ins.keys()), ..rest)
  }

  for (name, typ) in _variants {
    let this_call(method) = {
      let fn = _enum_built-ins.at(method, default: auto)
      assert(fn != auto)
      (..rest) => fn(_fetch_method(ty, this_call, _enum_built-ins.keys()), ..rest)
    }
    ty = ty + _fetch_method(ty, this_call, _enum_built-ins.keys())
    ty = (ty._register)(name, typ)
  }

  ty + _fetch_method(ty, this_call, _enum_built-ins.keys())
}


#let impl_enum(ty, ..fns) = {
  let fns = arguments.named(fns)

  for (name, fn) in fns {
    assert(type(fn) == function)
    ty._methods.insert(name, fn)
    ty.insert(name, fn)
  }

  let this_call(method) = {
    let fn = _enum_built-ins.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(ty, this_call, _enum_built-ins.keys()), ..rest)
  }

  for (name, typ) in ty._variants {
    let this_call(method) = {
      let fn = _enum_built-ins.at(method, default: auto)
      assert(fn != auto)
      (..rest) => fn(_fetch_method(ty, this_call, _enum_built-ins.keys()), ..rest)
    }
    ty = ty + _fetch_method(ty, this_call, _enum_built-ins.keys())
    ty = (ty._register)(name, typ)
  }

  ty + _fetch_method(ty, this_call, _enum_built-ins.keys())
}
