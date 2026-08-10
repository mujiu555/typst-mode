#import "./current.typ": current
/// - references (dict[str, dict]):
///   - key (str): reference name
///   - value (dict):
///     - label (label): the target label
///
/// Records user-declared label positions for index page generation.
/// Does NOT replace built-in citation — use Typst's citation for
/// bibliographic references.
#let indexers = state("indexers", (:))

/// Register a reference (label position) for index generation.
/// - name (str): reference identifier
/// -> none
#let register-indexer(name, pos, content, tbl: (:)) = {
  indexers.update(prev => (..prev, (name): (content: content, position: pos, ..tbl)))
}

/// Create a Typst built-in label and auto-register it in the metadata index.
/// - name (str): label identifier
/// - tbl (dict): any attributes to be stored in the metadata index for this label
/// -> label
#let index(name, content, tbl: (:)) = context {
  let loc = here()
  let prefix = current.get().id
  register-indexer(prefix + ":" + name, loc, content, tbl: tbl)
  [#metadata((
      name: name,
      loc: loc,
      ..tbl,
    )) <indexers>
    #content]
}

