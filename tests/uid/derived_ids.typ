// Manual: typst compile --root . tests/uid/derived_ids.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/doc.typ": _doc_uuid
#import "/lib/_lib.typ/tag.typ": _tag_uuid
#import "/lib/_lib.typ/indexer.typ": _index_uuid
#import "/lib/_lib.typ/state.typ": _state_uuid
#let identifiers = (_doc_uuid("same"), _tag_uuid("same"), _index_uuid("same"), _state_uuid("same"))
#assert.eq(identifiers.dedup().len(), 4)
#assert.eq(_doc_uuid("same"), _doc_uuid("same"))
#assert(_doc_uuid("same") != _doc_uuid("other"))
