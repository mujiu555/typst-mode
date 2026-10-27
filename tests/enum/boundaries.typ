#import "/lib/_lib.typ/record.typ": *
#import "/lib/_lib.typ/enum.typ": *
#import "/lib/_lib.typ/util.typ": _match
#let Empty = record()
#let Small = record("small", x: int)
#let Large = record("large", x: int, y: str)
#let E = enumerator("choice", n: int, text: str, child: Small, nil: Empty)
#let Narrow = enumerator(n: int)
#assert.eq(E.description, "choice")
#assert((E.compare)(Narrow))
#assert(not (Narrow.compare)(E))
#assert((E.compare)(enumerator()))
#assert(not (E.compare)(enumerator(n: str)))
#assert(not (E.compare)(enumerator(other: int)))
#assert((enumerator(child: Small).compare)(enumerator(child: Large)))
#assert(not (enumerator(child: Large).compare)(enumerator(child: Small)))
#for bad in (none, int, (:), Small, (_type_id: "x", _variants: ())) {
  assert(not (E.compare)(bad))
}
#assert.eq(((E.n)(0).fields)(), (n: 0))
#assert.eq(((E.text)("").fields)(), (text: ""))
#assert.eq(((E.child)(x: 1).fields)(), (child: (x: 1)))
#assert.eq(((E.nil)().fields)(), (nil: (:)))
#assert.eq((E.new)("n", -5).payload, -5)
#assert.eq(((E.with)("child", x: 5))().payload.x, 5)
#assert(_match(E, (Narrow.n)(2)))
#assert(not _match(Narrow, (E.text)("x")))
#let EM = impl_enum(E,
  value: self => self.payload,
  again: self => (self.value)(),
)
#assert.eq(((EM.n)(7).again)(), 7)
#let EM2 = impl_enum(EM, value: self => self.payload + 1)
#assert.eq(((EM2.n)(7).again)(), 8)
#assert.eq(((EM.n)(7).again)(), 7)
#assert.eq(((record(e: E).new)(e: (E.n)(2)).fields)(), (e: (n: 2)))
#let Special = enumerator(nil: type(none), automatic: type(auto))
#assert.eq((Special.nil)(none).payload, none)
#assert.eq((Special.automatic)(auto).payload, auto)
#let Outer = enumerator(inner: Narrow)
#assert.eq(((Outer.inner)("n", 3).fields)(), (inner: (n: 3)))
#assert(not (Small.compare)(E))
#assert.eq(((record(new: int, update: str, description: str).new)(new: 1, update: "u", description: "d").fields)(), (new: 1, update: "u", description: "d"))
