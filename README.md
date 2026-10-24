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
+- .github/
|  +- workflows/                ; CI/CD configuration
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
#import "/lib/_lib.typ/lib.typ": *
#show: template

#let (root, science, mathematics) = (tag.register)(
  "computer-science", "mathematics",
)
#meta(
  id: "index",
  title: [My notes],
  authors: ([Author name],),
  tags: (science, mathematics),
)
#mkcover()
#mkheading()

#lookup("definition", [Jump to the definition])
#mkindex("definition", [A definition])
#embed(include "child.typ")
#render-index()
```

Each included note declares its own `meta(...)` and calls `mkheading()`.
`embed` increases heading levels and restores the enclosing document afterward.
Paths in `include` resolve relative to the calling file. Use
`mkheading(new-page: false)` to keep a note on the current page.

`mkheading` registers the document ID as a global label, shows the title and
slug, authors, date, tags, and parent link. `template` provides the A4 layout
and previous/up/next navigation. `mkcover` renders an optional cover image
and abstract. `render-index(show-backlinks: false)` hides backlink lists.
Navigation links do not count as backlinks; explicit `lookup` calls do.

When migrating from Wishful-Thinking:

- Put old category names into regular `tag` objects and pass them in `tags`.
  The publication `category` enum remains separate and optional.
- Use `authors: ([Author name],)` even for one author; a scalar is rejected.
- Replace `mkheader()` with `mkheading()`.
- Use `mkindex(label, content)` and `lookup(label, content)` with globally
  unique labels. There is no automatic document prefix or old `index` API.
- Use `embed(include "path.typ")` instead of passing a filename string.
- Read `(current.get)()`, `(documents.final)()`, and `indexers()` directly.
- Extra document data lives in `tlb`; `tlb: (taxon: "theorem")` adds a taxon
  prefix above the note heading. Abstract and description are strings.

Run the rendering integration checks with `node tests/render/check.mjs`.

## Plans

## Related Efforts

1. [Typsy](https://github.com/patrick-kidger/typsy)

## Maintainers

[github@mujiu555(暮玖)](https://github.com/mujiu555)

## Contributing

You may pull all repository and walk through any part you interested in.
Make Pr if you have found any problem or have method to improve those notes.

## License

Apache License ver. 2.
