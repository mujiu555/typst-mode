// Tests for lib/_lib.typ/record.typ.
//
// A *record type* is a dictionary carrying `_type_id` (a UUID derived from
// its field map), `_fields` (name -> expected type) and `_methods`. An
// *instance* is a dictionary with a `_type` back-reference plus one value per
// field and every method bound with itself as `self`. Comparison is
// structural: every field of the left type must exist on the right with a
// matching type (extra right-side fields are allowed).
//
// The whole file is a test: `typst compile --root . tests/record/test.typ`
// only succeeds if every `#assert` passes. Negative cases that would abort
// compilation are kept as comments.

#import "/lib/_lib.typ/record.typ": enum, impl, record

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[record — structural data types]

// ---------------------------------------------------------------------
// 1. Full `new` type definition
// ---------------------------------------------------------------------
#heading(level: 2)[1. New type definition]

// `record` takes a positional *description* and named *field: type* pairs.
#let Point = record("A point in 2D space", x: int, y: int)

// The record type is a dictionary holding the field map, a description and
// the `new` / `compare` / `update` constructors.
#assert.eq(type(Point), dictionary, message: "type is a dictionary")
#assert.eq(Point.description, "A point in 2D space", message: "description stored")
#assert.eq(Point._fields.keys(), ("x", "y"), message: "field names")
#assert.eq(Point._fields.at("x"), int, message: "field type `int` is stored as-is")
#assert.eq(type(Point._methods), dictionary, message: "_methods exists")
#assert.eq(type(Point.new), function, message: "`new` is a function")
#assert.eq(type(Point.compare), function, message: "`compare` is a function")
#assert.eq(type(Point.update), function, message: "`update` is a function")

// The type's id is a deterministic UUID derived from its declaration.
#assert.eq(Point._type_id.len(), 36, message: "type id is a uuid")
#assert.eq(Point._type_id, record("A point in 2D space", x: int, y: int)._type_id,
  message: "same declaration yields the same type id")

// Construct instances with `(Type.new)(field: value, ...)`.
#let p0 = (Point.new)(x: 1, y: 2)
#assert.eq(p0.x, 1, message: "field x")
#assert.eq(p0.y, 2, message: "field y")

// Every instance carries a back-reference to its type via `_type`.
#assert.eq(p0._type.description, "A point in 2D space", message: "instance back-references _type")

// Extra named args to `new` are silently dropped.
#let p0e = (Point.new)(x: 1, y: 2, z: 99)
#assert.eq(p0e.x, 1)
#assert.eq(p0e.at("z", default: none), none, message: "extra `z` dropped")

// Positional args to `new` are ignored (pattern used by the project tests).
#let p0p = (Point.new)(Point, x: 5, y: 6)
#assert.eq(p0p.x, 5)
#assert.eq(p0p.y, 6)

// A record with no fields still works.
#let Empty = record("empty")
#let e0 = (Empty.new)()
#assert.eq(e0._type.description, "empty")

// Raw Typst types (`int`, `str`, ...) can be used directly as field types.
#let Named = record("named", name: str, count: int)
#let n1 = (Named.new)(name: "alice", count: 3)
#assert.eq(n1.name, "alice")
#assert.eq(n1.count, 3)

// --- negative cases (would abort compilation, kept for documentation) ---
// #let bad = (Point.new)(x: 1)          // missing field `y`
// #let bad = (Point.new)(x: "a", y: 2)  // wrong field type

// ---------------------------------------------------------------------
// 2. Type comparison
// ---------------------------------------------------------------------
#heading(level: 2)[2. Type comparison]

// Structurally equal shapes compare equal, and symmetrically.
#let Point2 = record("A point (same shape)", x: int, y: int)
#assert((Point.compare)(Point2), message: "Point.compare(Point2)")
#assert((Point2.compare)(Point), message: "Point2.compare(Point)")

// `compare` only checks the fields of the *left* type: extra fields on the
// right are ignored (asymmetric / structural-subtype behaviour).
#let Point3D = record("A point in 3D", x: int, y: int, z: int)
#assert((Point.compare)(Point3D), message: "Point.compare(Point3D) ignores z")

// The reverse requires `z`, which Point lacks -> `assert` failure (comment):
// #(Point3D.compare)(Point)

// A field-type mismatch makes `compare` return `false`.
#let PointNested = record("x: int, y: Point", x: int, y: Point)
#assert.eq((Point.compare)(PointNested), false, message: "int vs Point mismatch -> false")

// Records nested as field types compare recursively.
#let Seg = record("segment", from: Point, to: Point)
#let Seg2 = record("segment2", from: Point2, to: Point2)
#assert((Seg.compare)(Seg2), message: "nested compare")

// A missing field on the *right* type trips the internal `assert` (comment):
// #let NoY = record("no-y", x: int)
// #(Point.compare)(NoY)

// ---------------------------------------------------------------------
// 3. Method call
// ---------------------------------------------------------------------
#heading(level: 2)[3. Method call]

#let Vec = record("A vector", x: int, y: int)
#let Vec = impl(
  Vec,
  manhattan: self => self.x + self.y,
  scaled: (self, k: int) => (x: self.x * k, y: self.y * k),
  plus: self => (self.scaled)(k: 2), // chain: call another bound method
  dup: self => (self._type.new)(x: self.x, y: self.y),
)

#let v1 = (Vec.new)(x: 3, y: 4)
// Bound instance method.
#assert.eq((v1.manhattan)(), 7, message: "bound instance method")

// The same method is also reachable at the *type* level as a raw function
// that expects `self` passed explicitly.
#assert.eq((Vec.manhattan)((x: 1, y: 2)), 3, message: "type-level method")

// Methods can take extra parameters.
#let v1s = (v1.scaled)(k: 3)
#assert.eq(repr(v1s), "(x: 9, y: 12)", message: "method with arguments")

// A method that calls another bound method on `self`.
#let v1p = (v1.plus)()
#assert.eq(repr(v1p), "(x: 6, y: 8)", message: "chained method call")

// A method returning a plain dictionary produces a bare record (no methods,
// no `_type`) — the "return a fresh record" idiom.
#assert.eq(v1s.at("manhattan", default: none), none, message: "plain record has no methods")

// Multiple `impl` passes accumulate methods on the same type.
#let Acc = record("acc", n: int)
#let Acc = impl(Acc, inc: self => self.n + 1)
#let Acc = impl(Acc, dec: self => self.n - 1)
#let a1 = (Acc.new)(n: 5)
#assert.eq((a1.inc)(), 6, message: "method from first impl")
#assert.eq((a1.dec)(), 4, message: "method from second impl")

// ---------------------------------------------------------------------
// 4. Initialize an instance within a method
// ---------------------------------------------------------------------
#heading(level: 2)[4. Initialize instance within a method]

// Pattern A — a method initializes a fresh record by calling another method
// that returns one (see `plus` / `scaled` above).
#let v2 = (v1.plus)()
#assert.eq(v2.x, 6)
#assert.eq(v2.y, 8)

// Pattern B — a method initializes a full instance through the type back-ref
// `self._type.new`. The fresh instance carries its fields and the wired
// `_type`, so it has methods too:
#let v1d = (v1.dup)()
#assert.eq(v1d.x, 3, message: "dup fields")
#assert.eq(v1d.y, 4)
#assert.eq((v1d.manhattan)(), 7, message: "self._type.new result keeps methods")
#let v1e = (v1d._type.new)(x: 9, y: 1)
#assert.eq((v1e.manhattan)(), 10, message: "chained _type.new works")

// ---------------------------------------------------------------------
// 5. `update` and shadowing the built-in `update`
// ---------------------------------------------------------------------
#heading(level: 2)[5. update & shadowing]

// `update` copies an instance and replaces the given fields, keeping the
// bound methods.
#let v3 = (Vec.update)(v1, x: 100)
#assert.eq(v3.x, 100)
#assert.eq(v3.y, 4)
#assert.eq((v3.manhattan)(), 104, message: "updated instance keeps methods")

// `update` with no changed fields is a pure copy.
#let v3c = (Vec.update)(v1)
#assert.eq(v3c.x, 3)

// Extra named args to `update` are dropped too.
#let v3e = (Vec.update)(v1, x: 50, extra: 1)
#assert.eq(v3e.x, 50)
#assert.eq(v3e.at("extra", default: none), none)

// `update` also works on records that were never `impl`'d: `record` binds it
// only after `.new` exists on the type, so the bound `update` can always call
// back into `new`.
#let Raw = record("raw", value: int)
#let r1 = (Raw.new)(value: 1)
#let r2 = (Raw.update)(r1, value: 2)
#assert.eq(r2.value, 2, message: "pre-impl update works")

// --- defining an `update` method shadows the built-in on instances ---
#let Counter = record("counter", value: int)
#let Counter = impl(
  Counter,
  update: self => self.value + 1, // shadows the built-in `update`
)

#let c1 = (Counter.new)(value: 5)

// On instances, `update` is now the custom method.
#assert.eq((c1.update)(), 6, message: "instance `update` is the custom one")

// On the *type*, `update` stays the built-in copy-and-replace (impl re-inserts
// the built-in `_update` after wiring the custom method).
#let c2 = (Counter.update)(c1, value: 100)
#assert.eq(c2.value, 100, message: "type-level `update` is still the built-in")

// Instances created through the built-in `update` still carry the custom
// (shadowing) method.
#assert.eq((c2.update)(), 101, message: "built-in-created instance keeps custom update")

// ---------------------------------------------------------------------
// 6. `fields` accessor
// ---------------------------------------------------------------------
#heading(level: 2)[6. fields]

// Every instance carries a `fields` method returning name -> value.
#let p1 = (Point.new)(x: 1, y: 2)
#assert.eq((p1.fields)(), (x: 1, y: 2), message: "fields returns the field map")

// ---------------------------------------------------------------------
// 7. `with` partial application
// ---------------------------------------------------------------------
#heading(level: 2)[7. with]

// `(Type.with)(a: 1)` fixes `a` and returns a function that fills the rest.
#let with-x = (Point.with)(x: 10)
#let p2 = (with-x)(y: 2)
#assert.eq(p2.x, 10, message: "fixed field applied")
#assert.eq(p2.y, 2, message: "remaining field applied")

// ---------------------------------------------------------------------
// 8. `enum` — tagged unions
// ---------------------------------------------------------------------
#heading(level: 2)[8. enum]

#let Color = enum(
  "a color",
  rgb: (r: int, g: int, b: int),
  hsl: (h: float, s: float, l: float),
)

// Each variant is a constructor producing an instance tagged with its name.
#let red = (Color.rgb)(r: 255, g: 0, b: 0)
#assert.eq(red.variant, "rgb", message: "variant name")
#assert.eq(red.payload.r, 255, message: "variant payload field")
#assert.eq(type(red.payload), dictionary, message: "payload is a record instance")

// The other variant carries its own payload shape.
#let teal = (Color.hsl)(h: 0.5, s: 1.0, l: 0.5)
#assert.eq(teal.variant, "hsl", message: "second variant name")
#assert.eq(teal.payload.h, 0.5, message: "second variant payload")

// Enum instances are records: they carry the enum type's methods too.
#assert.eq((red.fields)().at("variant"), "rgb", message: "fields works on enum instances")

// --- a variant constructor with wrong field types aborts compilation ---
// #let bad = (Color.rgb)(r: "red", g: 0, b: 0)

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]

#heading(level: 3)[record type]
#render(Point)
#render(Point._fields)
#render(Point.description)

#heading(level: 3)[instances]
#render(p0)
#render(v1)
#render(v2)

#heading(level: 3)[compare]
#render((Point.compare)(Point2))
#render((Point.compare)(Point3D))
#render((Point.compare)(PointNested))

#heading(level: 3)[update & shadowing]
#render(v3)
#render(c1)
#render(c2)

#heading(level: 3)[with, fields, enum]
#render(p2)
#render((p1.fields)())
#render(red)
#render(teal)
