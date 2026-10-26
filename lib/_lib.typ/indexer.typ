// typst-mode: indexer.typ
// Index / lookup: `mkindex` records a label at the current location in the
// document; `lookup` turns that label back into a clickable link to the
// spot. This powers things like an index or cross-references.

#import "record.typ": impl_record, record
#import "state.typ": _mkstate

// Global store of labels: name -> index entry. A fresh `_state` slot is
// used so it does not collide with the other modules' slots.
#let _labels = _mkstate(
  "adf192e3-4b21-4d51-b218-93dbee5b0b15",
  (:),
)
#let _refrecs = _mkstate(
  "85de9db3-3669-4e67-99a3-4658abe657a9",
  (:),
)

#let _backlink = record(
  loc: location,
  content: content,
)

// An index entry: the label text, the location it points at, and the
// content to display for the link.
#let _indexer = record(
  label: str,
  loc: location,
  content: content,
)

#let _indexer = impl_record(
  _indexer,
  // Build a link to the recorded location, shown as `content`.
  lookup: (self, content) => context {
    link(self.loc, content)
  },
)

// Register a label at the current location. Duplicate labels are rejected —
// this fails compilation instead of silently shadowing.
#let mkindex(label, content) = {
  context {
    let loc = here()
    let index = (_indexer.new)(
      label: label,
      loc: loc,
      content: content,
    )

    (_labels.update)(cont => {
      cont + ((label): index)
    })
    [#metadata(label) <typst-mode-index-label>]
    content
  }
  // Keep validation separate from registration so a failed validation cannot
  // remove the state update and oscillate between layout passes.
  context {
    let matches = query(<typst-mode-index-label>).filter(m => m.value == label)
    assert(matches.len() <= 1, message: "ERROR: duplicate label: `" + label + "`")
  }
}

// Look up a previously registered label and render a link to it.
#let lookup(label, content) = context {
  let loc = here()
  let cont = (_labels.final)().at(label)

  (_refrecs.update)(
    recs => recs + ((label): recs.at(label, default: ()) + ((_backlink.new)(loc: loc, content: content),)),
  )

  (cont.lookup)(content)
}

#let backlinks(label) = {
  (_refrecs.final)().at(label, default: ())
}

#let indexers() = {
  (_labels.final)()
}
