// Tests for lib/_lib.typ/state.typ.
//
// `_state` is a handle onto one `(key, value)` slot of a single global Typst
// `state` list. All handles across all modules share that one list — two
// handles with the same `sym` see the same slot. Reads and writes are
// location-aware: an `update` only takes effect for reads at later positions
// in the document, so tests write at one top-level line and read in a
// `context` block further down.

#import "/lib/_lib.typ/state.typ": _global, _state

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[state — global key-value store]

// ---------------------------------------------------------------------
// 1. Defaults
// ---------------------------------------------------------------------
#heading(level: 2)[1. Defaults]

// A fresh handle returns its `default` until something is written.
#let a = (_state.new)(sym: () => {}, default: 0)
#let b = (_state.new)(sym: () => {}, default: "none")
#context {
  assert.eq((a.get)(), 0, message: "default before any update")
  assert.eq((b.get)(), "none", message: "each handle has its own default")
}

// ---------------------------------------------------------------------
// 2. update / get
// ---------------------------------------------------------------------
#heading(level: 2)[2. update & get]

// Write at this position...
#(a.update)(42)

// ...and read at a later position (state is location-aware, so the read
// must come after the write in document order).
#context {
  assert.eq((a.get)(), 42, message: "get sees the updated value")
  assert.eq((a.at)(here()), 42, message: "at the current location")
}

// ---------------------------------------------------------------------
// 3. Same `sym` shares a slot
// ---------------------------------------------------------------------
#heading(level: 2)[3. Same sym, same slot]

// Two handles created with the same key function read the same slot.
#context {
  let c = (_state.new)(sym: a.sym, default: 0)
  assert.eq((c.get)(), 42, message: "same sym sees the same value")
}

// ---------------------------------------------------------------------
// 4. Independent slots
// ---------------------------------------------------------------------
#heading(level: 2)[4. Independent slots]

// Distinct `sym` functions are distinct keys, so `b` is unaffected by `a`.
#(a.update)(7)
#context {
  assert.eq((a.get)(), 7, message: "a updated")
  assert.eq((b.get)(), "none", message: "b untouched")
}

// ---------------------------------------------------------------------
// 5. Replace, not append
// ---------------------------------------------------------------------
#heading(level: 2)[5. Replace, not append]

// Updating an existing slot replaces its entry — the global list never grows.
#(a.update)(8)
#context {
  let raw = _global.get()
  assert.eq(raw.len(), 1, message: "exactly one entry in the global list")
  assert.eq(raw.at(0).at(1), 8, message: "and it is the latest value")
}

// ---------------------------------------------------------------------
// 6. final
// ---------------------------------------------------------------------
#heading(level: 2)[6. final]

// `final` reads the value at the end of the document — the last value written.
#context {
  assert.eq((a.final)(), 8, message: "final reflects the last write")
  assert.eq((b.final)(), "none", message: "final default for unwritten slot")
}

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]
#context {
  render((a.get)())
  render((b.get)())
  render(_global.get())
}
