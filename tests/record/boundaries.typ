#import "/lib/_lib.typ/record.typ": *
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/util.typ": *

#let Empty = record()
#let Small = record("small", x: int)
#let Large = record("large", x: int, y: str)
#let Different = record(x: str)
#assert.eq(((Empty.new)().fields)(), (:))
#assert.eq(Small.description, "small")
#assert.eq(record("a", "b").description, "a\nb")
#assert.eq(record(x: int)._type_id, record(x: int)._type_id)
#assert((Small.compare)(Large))
#assert(not (Large.compare)(Small))
#assert(not (Small.compare)(Different))
#assert((Empty.compare)(Small))
#for bad in (none, int, 1, (:), (_type_id: "x",), (_type_id: "x", _fields: ())) {
  assert(not (Small.compare)(bad))
  if bad != int { assert(not _is_type(bad)) }
}
#for typ in (int, str, array, dictionary, content, Empty, Small, enumerator(a: int)) {
  assert(_is_type(typ))
}
#assert(_match(int, 0))
#assert(not _match(int, 0.0))
#assert(not _match(none, 1))
#assert(not _match(Small, (x: 1)))
#assert(not _match(Small, 1))
#assert(not _type_accepts((:), int))
#assert(not _type_accepts(none, int))
#assert(not _type_accepts(int, str))
#let a = (Large.new)(x: -1, y: "")
#assert(_match(Small, a))
#assert.eq((a.fields)(), (x: -1, y: ""))
#let b = (Large.update)(a, x: 0)
#assert.eq((b.fields)(), (x: 0, y: ""))
#assert.eq(a.x, -1)
#assert.eq(((Large.update)(a).fields)(), (a.fields)())
#assert.eq(((Large.with)(x: 2))(y: "λ").y, "λ")
#assert.eq(((Large.with)(x: 2))(x: 3, y: "λ").x, 3)
#let Nested = record(child: Small, raw: dictionary, seq: array, body: content, flag: bool)
#let n = (Nested.new)(child: a, raw: (k: 1), seq: (), body: [], flag: false)
#assert.eq((n.fields)(), (child: (x: -1, y: ""), raw: (k: 1), seq: (), body: [], flag: false))
#assert((record(child: Small).compare)(record(child: Large)))
#assert(not (record(child: Large).compare)(record(child: Small)))
#let Methods = impl_record(Small,
  add: (self, n: 1) => self.x + n,
  twice: self => (self.add)(n: self.x),
  update: self => self.x,
)
#let m = (Methods.new)(x: 3)
#assert.eq((m.twice)(), 6)
#assert.eq((m.update)(), 3)
#assert.eq((((Methods.update)(m, x: 4)).twice)(), 8)
#let Override = impl_record(Methods, add: (self, n: 1) => self.x * n)
#assert.eq((((Override.new)(x: 3)).twice)(), 9)
#assert.eq((m.twice)(), 6)
#assert.eq(((record(_parent: str).new)(_parent: ""))._parent, "")
#let bound = _fetch_method((x: 1), name => (v => name + v), ("f",))
#assert.eq((bound.f)("!"), "f!")
#assert.eq(bound.x, 1)
#_check_names(("ok", "_parent"), _type_reserved_names)
#for name in ("new", "compare", "with", "update") {
  let T = impl_record(Small, ..((name): (self => self.x)))
  assert.eq(((T.new)(x: 8).at(name))(), 8)
}
#let Native = record(f: float, n: int, d: datetime, l: length, r: ratio, fn: function, t: type)
#let native = (Native.new)(f: -0.5, n: 0, d: datetime(year: 2024, month: 2, day: 29), l: 0pt, r: 0%, fn: (x => x), t: int)
#assert.eq((native.fields)().r, 0%)
#assert.eq((native.fn)(9), 9)

