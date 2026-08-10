/// - documents (dict[str, dict]):
///   - key (str): document id-cat--title
///   - value (dict):
///     - parent (str): parent document id
///     - id (str): document id
///     - title (str): document title
///     - author (content | array[content]): authors
///     - date (datetime): creation date
///     - keywords (str | array[str]): keywords
///     - description (str | none): description
///     - category (str | none): category
///     - tags (array[str]): tags
///     - abstract (content): abstract
///     - ... additional keys from tbl
///
/// Manages per-source-document metadata. Since a project may consist
/// of multiple independent documents, this is NOT the compiled
/// output file's metadata.
#let documents = state("documents", (:))
