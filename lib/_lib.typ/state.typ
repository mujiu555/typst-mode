#import "record.typ": impl, record
#import "uid.typ": namespaces, v3

// Just prevent user from using names used in this library is ok....

#let _ns_state = v3(namespaces.oid, "70c5f11c-7b79-4e76-b581-b78cb430c26c")
#let _state_uuid(name) = v3(_ns_state, name)

#let _state = record(
  sym: str,
)

#let _mkstate(sym, init) = {
  let sym = _state_uuid(sym)

  let _s = state(sym, init)

  let s_state = impl(
    _state,
    get: self => {
      _s.get()
    },
    at: (self, lab) => {
      _s.at(lab)
    },
    final: self => {
      _s.final()
    },
    update: (self, var) => context {
      _s.update(
        var,
      )
    },
  )

  (s_state.new)(sym: sym)
}
