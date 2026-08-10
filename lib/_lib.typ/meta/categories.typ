/// - categories (dict[str, dict]):
///   - key (str): category name
///   - value (dict):
///     - id (str): category identifier
///     - parent (str): parent category identifier (same as id if root)
///     - documents (set[str]): set of document id
///
/// Categories form a hierarchy. Each category must be registered
/// before use via register-category().
#let categories = state("categories", (:))

/// Register a category with hierarchical organization.
/// - name (str): category identifier
/// - parent (str | none): parent category (none = root category)
/// -> none
#let register-category(name, parent: none) = {
  let p = if parent == none { name } else { parent }
  categories.update(prev => {
    (..prev, (name): (id: name, parent: p, documents: ()))
  })
}

/// Add a document idx to a category's document set.
/// Asserts that the category has been registered.
/// - cat (str): category name
/// - idx (str): document id
/// -> none
#let update-category(cat, idx) = {
  context {
    assert(
      categories.get().keys().contains(cat),
      message: "Category \"" + cat + "\" is not registered. " + "Call register-category(\"" + cat + "\") first.",
    )
    categories.update(prev => {
      let entry = prev.at(cat)
      entry.documents.push(idx)
      (..prev, (cat): entry)
    })
  }
}
