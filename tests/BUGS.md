# Library defects

Reproduce with `node tests/run.mjs --strict --filter=bug`.
The `bug_*` cases assert the expected result and are reported as expected
failures until the implementation is fixed. No fixes are included.

## UUID v3 does not follow RFC 4122

In `lib/_lib.typ/uid.typ:5`, `bytes(namespace)` hashes the namespace's textual
UUID, including hyphens, instead of its 16 decoded bytes. At line 21, forcing the
variant nibble to `8` also discards two hash bits that should be preserved.

For the DNS namespace and `www.widgets.com`, the standard result is
`3d813cbb-47fb-32ba-91df-831e1593ac29`. The implementation disagrees. The ASCII,
empty-name, and Unicode cases use expected values calculated independently
with Node crypto (decoded namespace bytes, MD5, and RFC bit masks).
Library IDs are deterministic, but cannot interoperate with standard UUID v3
generators. Correcting this would change IDs generated throughout the library.

## Empty content breaks breadcrumb truncation

In `lib/_lib.typ/render.typ:34`, joining the empty children array returns `none`,
not a string. `_truncate-middle` at line 40 then calls `.clusters()` on `none`.
An empty content title is accepted by `meta` but cannot pass this helper used
by template breadcrumbs.

Reproductions: `bug_empty_text`, `bug_empty_truncation`, and
`bug_empty_title_template`.

## Styled text is omitted from text extraction

`_content-to-text` in `lib/_lib.typ/render.typ:26` handles `text` and `children`,
but does not traverse a wrapper's `body`. For example, `[*Bold*]` becomes an empty
string. Consequently, `_truncate-middle([*123456*], max: 3)` returns the original
six-character styled content instead of `1…6`. Styled breadcrumb titles can
therefore exceed the intended length limit.

Reproductions: `bug_styled_text` and `bug_styled_truncation`.

## Tag document state is never populated

`lib/_lib.typ/tag.typ` exposes a `documents` state described as accumulating
attached document IDs. Registration and `sub` initialize it to `()`, but
`meta` in `lib/_lib.typ/art.typ:85` only validates tags; it never updates their
document states. After registering a document with a tag, that tag's
`documents.final()` remains empty.

Reproduction: `bug_tag_document_state`. The separate `get-doc` method works
because it filters the global document registry; that behavior has passing
tests. This defect is a mismatch between the exposed state and its documented
purpose, rather than a failure of `get-doc` or `render-tags`.
