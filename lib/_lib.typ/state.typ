#import "record.typ": impl, record

#let _global = state("a1a3ae8c-ec33-4646-8643-afbc3c0a2f6b", ())

#let _at(self, i) = {
  for (key, val) in i {
    if key == self.sym {
      return val
    }
  }
  self.default
}

#let _state = record(
  sym: function,
  default: none,
)

#let _state = impl(
  _state,
  at: (self, loc) => {
    _at(self, _global.at(loc))
  },
  final: self => {
    _at(self, _global.final())
  },
  get: self => {
    _at(self, _global.get())
  },
  update: (self, value) => context {
    let new = ()
    let found = false
    for (key, val) in _global.at(here()) {
      if key == self.sym {
        new.push((key, value))
        found = true
      } else {
        new.push((key, val))
      }
    }
    if not found {
      new.push((self.sym, value))
    }
    _global.update(new)
  },
)
