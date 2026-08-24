#import "@preview/uuidkit:0.1.0": namespaces, v3

#let _ns_record = v3(namespaces.oid, "e2487d38-8caa-481f-9a15-a7a3853e1d72")
#let _record_uuid(name) = v3(_ns_record, name)

// Structural type match: `t` is the expected type, `v` the actual value.
// Raw types (`int`, `str`, ...) match against `type(v)`; record types match
// against the type stored in a value's `_type`.
#let _match(t, v) = {
  let tv = type(v)
  if t == none {
    true
  } else if type(t) == type {
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
  assert(
    type(other) != type,
    message: "value `" + other + "` is not a record, can only compare between records",
  )
  if self._type_id == other._type_id {
    return true
  }
  let same = true
  for (name, t) in self._fields {
    let ot = other._fields.at(name, default: auto)
    if (ot == auto) {
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

#let _fetch_method(self, fn, methods) = {
  let m = (:)
  for name in methods {
    m.insert(name, fn(name))
  }
  self + m
}

#let _get_fields_record(self) = {
  let out = (:)
  for (n, t) in self._type._fields {
    out.insert(n, self.at(n))
  }
  out
}

#let _new_record(self, ..rest) = {
  let instance = (_type: self)

  for (f, ty) in self._fields {
    let v = rest.at(f, default: none)
    assert(v != none, message: "field `" + f + "`: not exist")
    assert(
      _match(ty, v),
      message: "field `" + f + "`:" + "`" + repr(ty) + "` do not match `" + repr(v) + "`",
    )
    instance.insert(f, v)
  }

  for (m, (name: name, type: ty, fn: fn)) in self._methods {
    assert(fn != none, "must provide a method")
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
#let _update_record(self, instance, ..rest) = {
  let newobj = (:)

  for (k, expected-type) in self._fields {
    let value = instance.at(k, default: auto)
    assert(value != auto)
    assert(_match(expected-type, value))
    newobj.insert(k, value)
  }

  (self.new)(..newobj, ..rest)
}

#let _with_record(self, ..rest) = {
  (..args) => {
    (self.new)(..rest, ..args)
  }
}

#let _record_built-ins = (
  compare: _compare,
  new: _new_record,
  update: _update_record,
  with: _with_record,
)

/// Defines a record
///
/// *Example*
///
/// ```typst
/// #let Adder = record(
///   x: Int,
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
  let _description = arguments.pos(fields).join("\n")
  let _fields = arguments.named(fields)

  let ty = (
    _type_id: _record_uuid(repr(fields)),
    _fields: _fields,
    _methods: (fields: (name: "fields", type: none, fn: _get_fields_record)),
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

#let _raw_register(self, name, ..rest) = {
  let var = (
    record(
      ..rest,
    )
      + (
        _parent: self._type_id,
      )
  )
  self._payloads.insert(name, var)

  let fn = (self, ..rest) => {
    (self.new)(variant: name, payload: (var.new)(..rest))
  }

  let this_call(method) = {
    assert(fn != auto)
    (..rest) => fn(_fetch_method(self, this_call, (name,)), ..rest)
  }
  let extended = self + _fetch_method(self, this_call, (name,))
  extended + (register: (..args) => _raw_register(extended, ..args))
}


#let _enum_built-ins = (
  _register: _raw_register,
)

#let enum(..rest) = {
  let description = arguments.pos(rest)
  let variants = arguments.named(rest)

  let ty = (
    record(
      ..description,
      variant: str,
      payload: dictionary,
    )
      + (
        _payloads: (:),
      )
  )

  for (name, fields) in variants {
    let this_call(method) = {
      let fn = _enum_built-ins.at(method, default: auto)
      assert(fn != auto)
      (..rest) => fn(_fetch_method(ty, this_call, _enum_built-ins.keys()), ..rest)
    }
    ty = ty + _fetch_method(ty, this_call, _enum_built-ins.keys())
    ty = (ty._register)(name, ..fields)
  }

  ty
}

