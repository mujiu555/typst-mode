#import "@local/tysty:0.1.0": meta, documents
#meta(id: "child", parent_id: "missing", title: [Child], authors: ())

// Metadata preserves declared parents; rendering validates traversal.
#context {
  assert.eq(documents().map(doc => doc.id), ("child",))
  assert.eq(documents().first().parent_id, "missing")
}
