/// - tags (dict[str, set[str]]):
///   - key (str): tag name
///   - value (set[str]): set of document id-cat--title
///
/// Tags are flat annotations, combined freely across documents.
#let tags = state("tags", (:))

/// Register a document under a tag.
/// - t (str): tag name
/// - idx (str): document id-cat--title
/// -> none
#let update-tags(t, idx) = {
  context if tags.get().keys().contains(t) {
    tags.update(a => {
      a.at(t).insert(idx)
      a
    })
  } else {
    tags.update(prev => (..prev, (t): (idx)))
  }
}
