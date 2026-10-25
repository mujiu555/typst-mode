// Manual: typst compile --root . tests/indexer/mkindex_nested.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/lib.typ": *
#lookup("inner", [Forward inner])
#mkindex("outer", [Outer #mkindex("middle", [Middle #mkindex("inner", [Inner])])])
#lookup("outer", [Outer link])
#render-index()
#context {
 let entries = indexers()
 assert.eq(entries.keys(), ("outer", "middle", "inner"))
 for name in entries.keys() { assert.eq(query(<typst-mode-index-label>).filter(m => m.value == name).len(), 1) }
 assert.eq(backlinks("inner").len(), 1)
 assert.eq(backlinks("outer").len(), 1)
 assert.eq(backlinks("middle"), ())
 assert.eq(query(link).filter(l => l.dest == entries.inner.loc).len(), 2)
}
