// typst-mode: record.typ
// A small structural type-system built on top of plain Typst dictionaries.
//
// A *record type* is a dictionary carrying three private keys:
//   _type_id — a UUID unique to this type (derived from its field map)
//   _fields  — dictionary of field-name -> expected type
//   _methods — dictionary of method-name -> (name, type, fn)
// A *record instance* is a dictionary carrying `_type` (its type) plus one
// value per declared field, with every method pre-bound so that it receives
// the instance as `self`.
//
// Matching is *structural*: two record types are equal iff every field of
// the first also exists in the second with a matching type. Extra fields on
// the second are allowed (asymmetric / structural-subtype behaviour). Raw
// Typst types (`int`, `str`, ...) match against `type(value)`.

#import "uid.typ": namespaces, v3

#let _ns_record = v3(namespaces.oid, "e2487d38-8caa-481f-9a15-a7a3853e1d72")
#let _record_uuid(name) = v3(_ns_record, name)

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
#let _get_fields_record(self) = {
  let out = (:)
  for (n, t) in self._type._fields {
    out.insert(n, self.at(n))
  }
  out
}

// Constructor (`new`): build an instance of `self` from named arguments.
// 1. validate every declared field against its expected type,
// 2. copy the type's method definitions into the instance,
// 3. re-bind every method so `self` is this instance (with its own bound
//    methods), which lets methods call each other.
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

  for (m, fn) in self._methods {
    assert(fn != none, message: "must provide a method")
    instance.insert(m, fn)
  }

  // `this_call(method)` closes over the fresh instance: it returns a
  // function whose first argument is `_fetch_method(instance, ...)` —
  // i.e. `self` arrives already carrying its own bound methods.
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

// Partial application of the constructor: `(ty.with)(a: 1)` fixes `a` and
// returns a function that fills in the remaining fields when finally called.
#let _with_record(self, ..rest) = {
  (..args) => {
    (self.new)(..rest, ..args)
  }
}

// Built-in methods every record type gets.
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

  // The "type" is itself just a dictionary: a UUID identifying it, the
  // declared field map, and a method registry seeded with the `fields`
  // accessor. `_methods.fields` has `fn: _get_fields_record`, so every
  // instance automatically carries a `fields` method.
  let ty = (
    _type_id: _record_uuid(repr(fields)),
    _fields: _fields,
    _methods: (fields: _get_fields_record),
    description: _description,
  )
  // Re-bind the built-ins so `self` inside them is the type-with-methods.
  let this_call(method) = {
    let fn = _record_built-ins.at(method, default: auto)
    assert(fn != auto)
    (..rest) => fn(_fetch_method(ty, this_call, _record_built-ins.keys()), ..rest)
  }

  ty + _fetch_method(ty, this_call, _record_built-ins.keys())
}

// Attach extra methods to an existing record type. Each method is stored in
// `_methods` (so newly-created instances pick it up) and also exposed
// directly on the type. Built-ins are re-bound at the end so `self` still
// resolves to the extended type.
// This implementation makes rebind (decorate) method possible
#let impl(ty, ..fns) = {
  let fns = arguments.named(fns)

  for (name, fn) in fns {
    assert(type(fn) == function)
    ty._methods.insert(name, fn)
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

// Register one enum variant on the type `self`.
// - builds a sub-record type for the variant's fields, tagged with the
//   parent's `_type_id` as `_parent`,
// - stashes it in `self._payloads[name]`,
// - defines a constructor `(self, ..rest) => self.new(variant: name,
//   payload: <sub-record instance>)`,
// - re-exposes `register` on the extended type so further variants can be
//   added incrementally.
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

// `enum` builds a tagged union (sum type): a record with `variant: str`
// and `payload: dictionary`, plus one registered constructor per variant.
// Constructors are invoked as `(ty.<variant>)(..fields)` and produce an
// instance carrying `variant = "<name>"` and the variant-specific payload.
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
