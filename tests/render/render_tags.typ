#import "../../lib/_lib.typ/lib.typ": *

#let tree = (tag.register)("render-check", (science: (physics: (:), empty: (:)), other: (:)))
#let science = tree.children.science.tag
#let physics = tree.children.science.children.physics.tag

// Preserve nested list structure and distinguish linked document titles.
#let describe(body) = {
  if type(body) == str { return body }
  if body.func() == list { return body.children.map(item => describe(item.body)) }
  if body.func() == link { return (title: describe(body.body.children.first()), linked: true) }
  if body.has("text") { return body.text }
  if body.has("body") { return describe(body.body) }
  if body.has("children") { return body.children.map(describe) }
  ()
}
#let entry(title) = (title: title, linked: true)
#let expected = (("root", (
  ("science", (
    ("physics", (entry("Child only"), entry("Both"))),
    ("empty",),
    entry("Parent only"),
    entry("Both"),
  )),
  ("other",),
)),)
#show list: it => {
  let actual = describe(it)
  if type(actual.first()) == array and actual.first().first() == "root" {
    assert.eq(actual, expected)
    [#metadata("checked") <test-tag-tree>]
  }
  it
}

// Forward references, exact membership, duplicate tags, and empty branches.
#render-tags(tree)
#meta(id: "parent", title: [Parent only], authors: (), tags: (science,))
#mkdoc(new-page: false)[]
#meta(id: "child", title: [Child only], authors: (), tags: (physics, physics))
#mkdoc(new-page: false)[]
#meta(id: "both", title: [Both], authors: (), tags: (science, physics))
#mkdoc(new-page: false)[]
// No heading: omit this document even when it has a manual index.
#meta(id: "root", title: [Root only], authors: (), tags: (tree.tag,))
#meta(id: "untagged", title: [Untagged], authors: ())
#mkindex("root", [Manual index without an entity])
#context assert.eq(query(<test-tag-tree>).len(), 1, message: "The tag tree must be rendered and checked exactly once")
