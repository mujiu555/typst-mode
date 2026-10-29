# typst-mode

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![conventional commit compliant](https://img.shields.io/badge/git%20commit-conventional%20commit-brightgreen.svg?style=flat-square)](https://www.conventionalcommits.org/en/v1.0.0/#specification)
[![git flow compliant](https://img.shields.io/badge/branch-git%20flow-brightgreen.svg?style=flat-square)](./doc/README.gitflow.md)

## Background

### Referencing

### Credit: Code/Library

1. [digestify](https://github.com/ParaN3xus/digestify.git):
  License: MIT, no NOTICE provided

## Structure

The whole project is organized in following structure:

```txt
Root: /                         ; Project root
+- .git/                        ; git repository
+- doc/                         ; documentation & copyright information
|  +- licenses/                 ; licenses and notice form other libraries
|  +- LICENSE                   ; copy of the LICENSE
|  +- LICENSE.apache            ; copy of the original LICENSE
|  +- README                    ; README for directory `doc`
|  +- README.commit.md          ; git commit convention
|  +- README.gitflow.md         ; git flow convention
|  +- README.release.md         ; semantic versioning 
+- lib/                         ; libraries
|  +- _lib.typ/                 ; source code
+- .gitignore
+- .gitmodules
+- LICENSE
+- README.md
+- typst.toml                   ; library spec
```

## Usage

```typst
// Save this example as notebook.typ in the project root.
// Compile with: typst compile --root . notebook.typ
// Use your installed package version, e.g. "@preview/tysty:0.1.0".
// For a local checkout, import "lib/_lib.typ/lib.typ" instead.
#import "@preview/tysty": *

// Register a namespace and its nested tags.
#let topics = (tag.register)("notebook", (
  science: (physics: (:),),
))
#let physics = topics.children.science.children.physics.tag
// Attach a tag to a document by adding tags: (physics,) to its meta call.

// Declare a document with metadata.
// Call meta before any mk* rendering function for that document.
// id, title, and authors are required; authors is an array of names or author records.
// Each document id must be unique within one compilation.
// Omitting parent_id makes the document its own semantic root.
#meta(
  id: "notebook",
  title: [Book],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30),
)
// Render the current document's cover without registering a reference target.
#mkcover()

// meta selects the current document; Typst's built-in metadata is a different API.
#meta(
  id: "note 1",
  title: [Note 1],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30),
)

// mkdoc renders the current document's heading and body, registers its id as
// a reference target, and adds it to the prev/next reading sequence.
// Use mkdoc(new-page: false)[...] to omit its initial page break.
#mkdoc[
  // embed increases the heading offset and restores the outer document context.
  // For a separate source file, use #embed(include "child.typ").
  // Semantic parent relationships are declared explicitly with parent_id.
  #embed[
    #meta(
      id: "sub note 1",
      parent_id: "note 1",
      title: [Sub Note 1],
      authors: ("Alice",),
      date: datetime(year: 2026, month: 10, day: 30),
    )
    #mkdoc[
      sub note 1 content
    ]
  ]
  // Without embed, a subsequent meta call replaces the current document
  // for the remainder of this scope; mkdoc itself does not restore it.
  #meta(
    id: "sub note 2",
      parent_id: "note 1",
    title: [Sub Note 2],
    authors: ("Alice",),
    date: datetime(year: 2026, month: 10, day: 30),
  )
  #mkdoc[
    sub note 2 content
  ]
]

// A semantic child can also appear outside an embedded body.
#meta(
  id: "sub note 3",
  parent_id: "note 1",
  title: [Sub Note 3],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30),
)
// A child document may have both a cover and a registered document heading.
#mkcover()
#mkdoc[
  sub note 3 content
]

// Reference a registered target with #lookup("sub note 1", [Sub Note 1]).
// In a context block, backlinks("sub note 1") returns its recorded references.
// render-children([Child notes]) lists children of the current document.
// render-tags(topics) renders the registered tag tree and its rendered notes.
// These views resolve registered targets even when they appear later in the source.
```

## Plans

## Related Efforts

## Maintainers

[github@mujiu555(暮玖)](https://github.com/mujiu555)

## Contributing

You may pull all repository and walk through any part you interested in.
Make Pr if you have found any problem or have method to improve those notes.

## License

Apache License ver. 2.
