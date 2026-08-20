#import "format.typ": fmt
#import "decorate.typ": decorate

#let trait = (methods: (:), description) => (
  _methods: methods,
  impled: (:),
)

#let _method = (self, fn) => (..rest) => fn(self, ..rest)

#let _match = (t, v) => {
  let tv = type(v)
  if tv == dictionary {
    let tv = v.at("_type", default: auto)
    assert(tv != auto)
    (t.compare)(tv)
  } else {
    (t.compare)(tv)
  }
}

#let _update = (self, instance, ..rest) => {
  let newobj = (:)

  for (k, expected-type) in self._fields {
    let value = instance.at(k, default: none)
    assert(value != none)
    assert(_match(expected-type, value))
    newobj.insert(k, value)
  }

  (self.new)(..(newobj + arguments.named(rest)))
}

// structural data type
#let _compare = (self, other) => {
  let same = true
  for (name, type) in self._fields {
    let ot = other._fields.at(name, default: auto)
    assert(ot != auto)
    same = same and (type.compare)(ot)
    if not same {
      break
    }
  }
  same
}


#let record = (..fields) => {
  let _description = arguments.pos(fields).join()
  let _fields = arguments.named(fields)

  let ty = (:)
  ty._fields = _fields
  ty._methods = (:)
  ty.description = _description

  let _new = (..rest) => {
    let instance = (:)

    for (key, expected-type) in dictionary.pairs(_fields) {
      let value = rest.at(key, default: none)
      assert(value != none)
      assert(_match(expected-type, value))
      instance.insert(key, value)
    }

    instance._type = ty

    instance
  }

  ty.new = _new
  ty.update = _method(ty, _update)
  ty.compare = _method(ty, _compare)

  ty
}

// NOTE: adopt form typsy
#let _fetch_method(self, fn, methods) = {
  let m = (:)
  for name in methods {
    m.insert(name, fn(name))
  }
  self + m
}

#let impl = (ty, trait: none, ..fns) => {
  let fns = arguments.named(fns)
  ty.new = decorate(ty.new, after: (instance, ..) => {
    for (name, fn) in fns {
      instance.insert(name, fn)
    }
    let this_call(method) = {
      let fn = instance.at(method, default: auto)
      assert(fn != auto)
      (..rest) => fn(_fetch_method(instance, this_call, fns.keys()), ..rest)
    }
    instance + _fetch_method(instance, this_call, fns.keys())
  })

  for (name, fn) in fns {
    ty._methods.insert(name, (name: name, type: ty, trait: trait, fn: fn))
    ty.insert(name, fn)
  }
  ty.insert("update", _method(ty, _update))

  ty
}

#let enum = (variants: (:), description, new) => {
  let description = arguments.pos(fields).join()
  let variants = arguments.named(variants)
  // TODO:
}

#let Int = (:)
#(Int._fields = int)
#(Int._methods = (:))
#(Int.description = "")
#(Int.compare = _method(Int, (self, other) => int == other or other._fields == int))
