#import "record.typ": _fetch_method, impl, record
#import "state.typ": _state

#import "@preview/uuidkit:0.1.0": namespaces, v3

#let _ns_tag = v3(namespaces.oid, "ac562613-54f4-4584-8ea4-1401df8d1ed2")
#let _tag_uuid(name) = v3(_ns_tag, name)

#let tag = record(
  _parent: str,
  id: str,
  name: str,
  documents: _state,
)

#let tag = impl(
  tag,
  sub: (self, name) => {
    (tag.new)(
      _parent: self.id,
      id: _tag_uuid(name),
      name: name,
      documents: (_state.new)(sym: () => {}, default: ()),
    )
  },
  add-doc: (self, id) => context {
    (self.documents.update)(
      (self.documents.get)() + (id,),
    )
  },
)

// super wired usage:
// ```txt
// #let (
//   root,
//   taga,
//   tagb
// ) = (tag.register)(
//   "taga",
//   "tagb"
// )
// ```
#let tag = (
  tag
    + (
      register: (..tags) => {
        let tags = arguments.pos(tags)
        let root = (tag.new)(
          _parent: "",
          id: "root",
          name: "root",
          documents: (_state.new)(sym: () => {}, default: ()),
        )
        let out = (root,)
        for t in tags {
          let n = (root.sub)(t)
          out.push(n)
        }
        out
      },
    )
)
