// typst-mode: tag.typ
// Hierarchical tag system. Tags form a tree: `register` creates a root tag
// plus one child per given name, and `sub` grows further children. Each tag
// tracks the documents attached to it via its own `_state` slot.

#import "record.typ": _fetch_method, impl_record, record
#import "state.typ": _mkstate, _state

#import "uid.typ": namespaces, v3

// UUID namespace for tags, mirroring the scheme used in meta.typ.
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
    (self._type.new)(
      _parent: self.id,
      id: _tag_uuid(name),
      name: name,
      documents: _mkstate("a61f608d-7f35-4ff9-a9a6-65ba40dffc2f", (:)),
    )
  },
  // Attach a document to this tag. `documents` is a dictionary keyed by
  // document id, so attaching the same document again is a no-op — necessary
  // because meta re-runs during layout passes, and re-reading the slot at the
  // same location can return a stale value.
  add-doc: (self, doc) => context {
    let cur = (self.documents.get)()
    cur.insert(doc.id, doc)
    (self.documents.update)(cur)
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
          documents: _mkstate(tags.join("-") + "f8480bdb-6c76-44b5-a0a3-211e55105521", (:)),
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
