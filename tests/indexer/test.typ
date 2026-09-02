// Tests for lib/_lib.typ/indexer.typ.
//
// `mkindex(label, content)` records an entry at the current location;
// `lookup(label, content)` renders a link to it. Both are location-aware
// (they read/write the shared `_global` store), so `lookup` calls must come
// after the matching `mkindex` in document order. A duplicate `mkindex`
// label aborts compilation, so the duplicate case is documented as a comment
// rather than exercised.

#import "/lib/_lib.typ/indexer.typ": _labels, _refrecs, backlinks, indexers, lookup, mkindex

#(mkindex)("sec-one", [Section One])

#(lookup)("sec-one", [Go to Section One])

#(lookup)("sec-one", [Go to Section One])

#(lookup)("sec-two", [Jump to two])

#(lookup)("sec-one", [goto Section One])

#(mkindex)("sec-two", [Section Two])

#context indexers()
#context backlinks("sec-one")
