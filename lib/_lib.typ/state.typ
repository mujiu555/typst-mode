// typst-mode: state.typ
// Global state store.
//
// Typst's built-in `state` is location-aware and finicky to use directly,
// so this module wraps a single global `state` whose value is a list of
// `(key, value)` pairs. A `_state` record is a *handle* identifying one
// entry of that list:
//   sym     — the unique key (a function, compared with `==`)
//   default — value returned when no entry exists yet
//
// This lets unrelated modules (meta, tag, indexer) each own a named slot in
// the same global list, as if it were a small key-value store.

#import "record.typ": impl, record

// One global state holding a list of `(key, value)` pairs. The id string is
// an arbitrary UUID: it only has to be unique so no other global state
// collides with it.
#let _global = state("a1a3ae8c-ec33-4646-8643-afbc3c0a2f6b", ())

// Look up `self.sym` inside the pair-list `i`; return the matching value,
// or the handle's `default` when the key is not present.
#let _at(self, i) = {
  for (key, val) in i {
    if key == self.sym {
      return val
    }
  }
  self.default
}

// The handle type: `sym` is the unique key, `default` the fallback value.
#let _state = record(
  sym: function,
  default: none,
)

// Methods on a `_state` handle. `at` / `final` / `get` are the three
// flavours of Typst state reads; `update` replaces this handle's entry.
#let _state = impl(
  _state,
  // Value at the given location
  at: (self, loc) => {
    _at(self, _global.at(loc))
  },
  // Value at the end of the document (after the final layout pass)
  final: self => {
    _at(self, _global.final())
  },
  // Current value
  get: self => {
    _at(self, _global.get())
  },
  // Replace this handle's entry (appending if absent). A `context` block is
  // required because Typst state can only be read/written from a context.
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
