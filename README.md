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

## UID identifiers

`uid(namespace, name)` uses pure Typst FNV-1a 32 with native integer bit
operations. These identifiers are **non-standard UUIDs that borrow the UUID
container**, not UUID v5. The input is the namespace's 16 bytes followed by the
name's UTF-8 bytes (or raw bytes). Names are preserved without normalization.
The initial hash is 2166136261; each byte is XORed into it, then multiplied by
16777619 modulo 2^32.

The result is `hhhhhhhh-0000-8000-8000-000000000000`, where `hhhhhhhh` is the
lowercase, zero-padded 32-bit hash. The remaining fields are fixed formatting;
they add no entropy. The effective hash space is only 32 bits, so collisions are
possible; this is not a cryptographic hash or a uniqueness guarantee. Namespace
strings remain case-insensitive, and 16-byte namespaces are also accepted.
Existing UUID v5 values and all derived IDs change with this algorithm.

Built-in identifiers use the precomputed FNV-1a 32 table in
`lib/_lib.typ/uid.builtin.json`. Cache keys include the complete namespace and
name; inputs absent from the table are computed with the same pure Typst
implementation. The cache is available during module initialization.

## Usage

```typst
// Save this example as notebook.typ in the project root.
// Compile with: typst compile --root . notebook.typ
// Use your installed package version, e.g. "@preview/tysty:0.1.0".
// For a local checkout, import "lib/_lib.typ/lib.typ" instead.
#import "lib/_lib.typ/lib.typ": *
// Top-level APIs automatically select PDF or HTML at the call site.
// The render module provides the same automatic APIs as render.mkdoc, etc.
// Explicit pdf.* and html.* APIs remain available.
// Export this source as HTML with: typst compile --features html notebook.typ notebook.html
#show: template

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

```typst
// HTML bundle example: save as website.typ in the project root.
// Requires Typst 0.15+.
// typst compile --root . --features html,bundle --format bundle website.typ site
// The output contains index.html, notes/motion.html, and tysty.css.
// Bundle background and typography can be customized with:
// #show: html.bundle.with(css: read("my-theme.css"))
#import "lib/_lib.typ/lib.typ": *
// At bundle scope, the automatic template emits the shared CSS asset.
#show: template

#html.page("index.html", title: "Notebook")[
  #meta(id: "home", title: [Notebook], authors: ("Alice",))
  #html.mkcover()
  #html.mkdoc[
    Read #html.lookup("motion", [the motion note]).
    #html.render-children([Notes])
  ]
]

#html.page("notes/motion.html", title: "Motion")[
  #meta(id: "motion", parent_id: "home", title: [Motion], authors: ("Alice",))
  #html.mkdoc[
    Velocity describes how position changes over time.
    Return to #html.lookup("home", [the notebook]).
  ]
]

// page creates an output file and restores the surrounding document context.
// mkdoc registers the note; mkcover does not register an index target.
// Links and backlinks resolve across all pages in the bundle.
// Each page links to the shared CSS using its relative output path.
//
// For single-file HTML, omit bundle and page, and use:
// #show: html.template.with(title: "Notebook")
// #meta(id: "home", title: [Notebook], authors: ())
// #html.mkdoc[Hello]
// Compile with: typst compile --features html website.typ website.html
// template embeds CSS by default; css: read("my-theme.css") overrides it.
```

## Static site generation

```typst
// Save as site.typ. Requires Typst 0.15+.
// Compile with: typst compile --root . --features html,bundle --format bundle site.typ output
#import "lib/_lib.typ/lib.typ": *
#show: template

// Declare and render the root page explicitly, just like the child pages below.
#meta(id: "home", title: [Notebook], authors: ())
#mkdoc[Entry page]

// An embed can declare and emit its own child page. The route is computed
// from the document ID; nested ancestors become route directories.
#embed[
  #meta(id: "research", parent_id: "home", title: [Research], authors: ())
  #mkdoc[
    = Research questions
    Research notes.
    == Open problems
    More to explore.
    // The automatic mkoutline selects the route-aware document tree in bundles.
    #mkoutline()
  ]

  #embed[
    #meta(id: "review", parent_id: "research", title: [Review], authors: ())
    #mkdoc[Literature review.]
  ]
]

// Outputs: index.html, research/index.html,
// research/review/index.html, and tysty.css.
// mkdoc uses each document's metadata and parent chain to determine its route.
// Navigation and breadcrumbs are in the top bar; section links appear in the right sidebar.
// mkoutline() uses Typst's outline for PDF/single HTML and SSG routes for bundles.
// Keep page-producing mkdoc calls outside another page's mkdoc body.
```

## Plans

## Related Efforts

## Maintainers

[github@mujiu555(暮玖)](https://github.com/mujiu555)

## Contributing

You may pull all repository and walk through any part you interested in.
Make Pr if you have found any problem or have method to improve those notes.

Run `node tests/run.mjs` to test this checkout as `@local/tysty:0.1.0`.
See [tests/README.md](tests/README.md) for API coverage and test targets.

## License

Apache License ver. 2.
