# Tests

Run the complete suite with Node.js and Typst 0.15.1 or later:

```sh
node tests/run.mjs
```

Pass path fragments to select tests, for example:

```sh
node tests/run.mjs api render
node tests/run.mjs uid
```

The runner creates an isolated package directory in `/tmp` and links this
checkout as `@local/tysty:0.1.0` with Typst's `--package-path`. It does not modify
installed packages or use an older installed copy. All public API tests import
that package name. Compile a test manually with your own local package
installation, or use the runner to ensure it tests this checkout.

PDF, HTML, and bundle cases use their appropriate output targets; `render/auto`
and `api/entry` run as both PDF and HTML. Generated files remain in the temporary
directory printed by the runner. SSG checks also inspect routes, CSS links,
section outlines, shared page bodies, and mixed HTML/PDF bundle outputs.

Rejection cases live under `reject/`. Each must fail with the diagnostic recorded
in `reject.json`; an unrelated compilation error does not count as a pass.
Fixtures are helpers, not standalone tests.

## Public API coverage

The supported entry point is `lib/_lib.typ/tysty.typ`, re-exported by the package.
`api/exports.typ` checks the full top-level import contract. Behavior is exercised
by the following cases:

| API | Behavior tests |
| --- | --- |
| `meta`, `documents` | `art/meta`, `art/meta_categories`, `api/types_tags`, `reject/art/*` |
| `current.get/at/final/update/enter/leave` | `doc/current`, `embed/embed`, `reject/doc/*` |
| `author`, `img`, `category` | `api/types_tags`, `art/meta_categories`, `render/mkcover_png_background`, `reject/types/*` |
| `tag.register/sub/get-doc` | `api/types_tags`, `render/auto`, `reject/tag/*` |
| `mkindex`, `indexers`, `lookup`, `backlinks` | `indexer/*`, `render/auto`, `reject/indexer/*` |
| `entry`, `render.entry`, `set-base`, `render-children` | `api/entry` (PDF and HTML) |
| `template`, `embed`, `mkcover`, `mkdoc`, `mkoutline`, `render-tags` | `render/auto` (PDF and HTML), `embed/embed`, `render/auto_bundle`, `render/ssg` |
| `render.*` | Same automatic functions as the top-level aliases; `api/exports` checks both export surfaces |
| `pdf.*` | `render/pdf_namespace`, `render/mkcover`, `render/mkcover_png_background`, `reject/render/mkcover_bad_png` |
| `html.template/mkcover/mkdoc/embed/lookup/render-children/render-tags/page/bundle` | `render/html_single`, `render/html_bundle`, `render/auto_bundle`, `reject/render/page_invalid_path` |
| `html.stylesheet` | `api/exports`, generated section outline checks in `render/ssg` |
| `ssg.mkoutline`, `ssg.ref`, `ssg.route/mkdoc/embed/is-bundle-output/entities` | `render/ssg`, `render/ssg_ref`, `render/ssg_html`, `reject/render/ssg_ref_unrendered` |
| Shared renderer `entities()` query, `file_base` state | `render/auto_bundle`, `api/entry` |

The renderer aliases are also checked for function identity in `api/exports`, so
behavior tests for a top-level alias cover the corresponding `render.*` alias.

## Internal tests

`uid`, `record`, `enum`, `state`, `util`, `decorate`, and
`regressions/record/update_auto.typ` test implementation modules that are not
exported by the package entry point. They intentionally import source files.
Their rejection cases follow the same rule. These are retained because they
still protect current behavior, including FNV-1a vectors and precomputed cache
consistency.

Obsolete UUID v5 vectors have been replaced by FNV-1a container vectors. The
old duplicate cover-title regression and documentation/package text-presence
checks have been removed. Unknown-field regressions now live under
`reject/record/`. SSG uses `template` as its document wrapper; `entry` requires
metadata arguments. PDF and HTML renderer `entities()` query the same metadata label,
which the mixed bundle test verifies.

## Performance profiling

Use the same isolated package and target selection as the correctness suite:

```sh
node tests/run.mjs --profile art api render
```

Each compilation prints elapsed wall time and writes a `*.trace.json` beside
its output in the reported temporary directory. These traces come from Typst's
standard `compile --timings <output.json>` option. Open a trace in
[Perfetto](https://ui.perfetto.dev) to inspect compilation phases and source
locations. Profiling also runs the usual correctness and output checks.

For before/after measurements, use the same Typst version, machine, fonts,
fixtures, output target, and job count. Run one warm-up, then at least five
independent runs of the same selected tests; compare medians and retain the
range. Do not run competing builds concurrently. These are fresh-process
compilations with potentially warm OS caches, not incremental editor timings.
Trace collection adds overhead: use normal compilations for headline latency
and traces to locate hotspots. Record `typst --version`, the revision, command,
and environment with results. For a single controlled compilation, reuse the
runner's printed package directory and pass `--jobs 1` and `--timings` directly
to `typst compile`; measure uninstrumented wall time with your shell's `time`.

Parent metadata fixtures under `art/parent_*` verify that declarations preserve
parent IDs, including unresolved and cyclic relationships. Traversal errors are
tested where rendering actually follows parents (for example,
`reject/render/breadcrumb_cycle.typ`).
