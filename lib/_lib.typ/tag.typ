// typst-mode: tag.typ
// Hierarchical tag system. Tags form a tree: `register` creates a root tag
// plus one child per given name, and `sub` grows further children. Each tag
// tracks the documents attached to it via its own `_state` slot.

#import "record.typ": impl_record, record
#import "state.typ": _mkstate, _state

#import "uid.typ": namespaces, v3

// UUID namespace for tags, mirroring the scheme used in doc.typ.
#let _ns_tag = v3(namespaces.oid, "ac562613-54f4-4584-8ea4-1401df8d1ed2")
#let _tag_uuid(name) = v3(_ns_tag, name)

// A tag: `_parent` is the id of its parent ("" for the root), `id`/`name`
// identify it, `documents` is a `_state` slot accumulating attached
// document ids.
#let tag = record(
  _parent: str,
  id: str,
  name: str,
  documents: _state,
)

#let tag = impl_record(
  tag,
  // Create a child tag under this one. The child gets a fresh, empty
  // `documents` slot so it tracks its own documents. `self._type.new` (rather
  // than a captured `tag.new`) keeps the child wired to the *full* tag type —
  // a closure defined before `impl` finishes would otherwise capture the
  // bare, method-less type.
  sub: (self, name) => {
    let id = _tag_uuid(self.id + ":" + name)
    (self._type.new)(
      _parent: self.id,
      id: id,
      name: name,
      documents: _mkstate(id, ()),
    )
  },
  // Attach a document by id. Functional updates accumulate documents without
  // depending on a contextual read from a previous layout pass.
  add-doc: (self, doc) => {
    (self.documents.update)(cur => {
      cur + (doc.id,)
    })
  },
  get-doc: self => {
    (self.documents.get)()
  },
)

// "super wired" usage: `register` creates a root tag and one child per
// given name, and returns them as a positional list.
// ```txt
// #let (
//   root,
//   taga,
//   tagb
// ) = (tag.register)(
//   "namespaces",
//   "taga",
//   "tagb"
// )
// ```
#let tag = (
  tag
    + (
      register: (namespace, ..tags) => {
        let root_id = _tag_uuid(repr(("registration", namespace)))
        let root = (tag.new)(
          _parent: "",
          id: root_id,
          name: "root",
          documents: _mkstate(root_id + ":" + "f8480bdb-6c76-44b5-a0a3-211e55105521", ()),
        )
        (root,) + arguments.pos(tags).map(name => (root.sub)(name))
      },
    )
)
