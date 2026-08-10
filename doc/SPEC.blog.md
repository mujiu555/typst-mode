# Blog file metadata specification

This document specifies an optional metadata header format used at the top of Typst blog files in `root/notes`.

## Overview

Files may start with zero or more metadata lines. Each metadata line is a single-line comment that begins with exactly three slashes (`///`) and encodes a key and a value using the form:

    /// <TYPE>: <info>

- `TYPE` is an uppercase identifier (currently only `TAG` is defined).
- `info` is a free-form string. Specific `TYPE`s may define structured semantics for their `info`.

Metadata lines MUST appear before the main document content and before other non-comment directives (for example, before a `#title[...]` or top-level content). Parsers should read contiguous `///` lines at the top of the file as metadata; once a non-`///` line is encountered, metadata parsing stops.

## Current TYPEs and semantics

1) TAG

- Purpose: assign zero or more tags to the document for categorization, index-building, or site generation.
- Syntax (recommended): a comma-separated list of tags. Example:

    /// TAG: assembly, cpu, radix

- Semantics:
  - Each tag is trimmed of leading and trailing whitespace.
  - Tags are case-sensitive by default (decide project-wide whether to normalize case; the implementation may lowercase tags automatically).
  - Duplicate tags in the same value should be collapsed.
  - Empty tag elements (e.g., `,,` or a trailing comma) should be ignored.

## Grammar (informal)

In simplified EBNF-ish form:

    metadata-line  := '///' ws TYPE ':' ws value '\n'
    TYPE           := [A-Z][A-Z0-9_]*
    value          := any characters except '\n'
    ws             := { ' ' | '\t' }

Files MAY contain zero or more `metadata-line` entries at the top of the file. Parsing stops at the first non-`///` line.

## Parsing recipe (recommended)

1. Read the file from the top.
2. While the current line matches the `metadata-line` pattern, parse and accumulate metadata entries.
3. Stop when encountering the first line that does not begin with `///`.
4. For `TAG` values: split the `value` on commas, trim each piece, ignore empty pieces, and deduplicate.
5. Provide the resulting metadata to site build tools (e.g., attach `tags: ["a", "b"]` to the document's metadata object).

Pseudo-code (high level):

```text
metadata = {}
for line in file.lines():
    if not line.startswith('///'):
        break
    // strip leading '///'
    rest = line[3:].lstrip()
    if ':' not in rest:
        continue // or warn: malformed metadata
    type, value = rest.split(':', 1)
    type = type.strip().upper()
    value = value.rstrip('\n')
    if type == 'TAG':
        raw_tags = [t.strip() for t in value.split(',') if t.strip()]
        metadata['tags'] = sorted(unique(raw_tags))
    else:
        // store unknown types verbatim for forward compatibility
        metadata.setdefault(type, []).append(value.strip())
```

## Validation rules

- The `///` prefix is mandatory for metadata lines.
- `TYPE` token must be non-empty and consist of letters, digits, and underscores. Parsers should uppercase the token to treat `Tag` and `TAG` uniformly.
- A colon (`:`) separates the type and its value. If a colon is missing, the metadata line is malformed — parsers may either ignore it or emit a warning depending on strictness.

## Examples

1) Single-line tags:

    /// TAG: assembly, cpu, radix
    #title[Assembly basics]

This yields tags ["assembly", "cpu", "radix"].

2) No metadata (valid):

    #title[Untitled]

3) Multiple metadata types (future-proofing):

    /// TAG: systems
    /// NOTE: Draft version
    #title[...]

Current tooling will parse `TAG` and store `NOTE` as an unknown-type value (kept for forward compatibility). Later the project can define `NOTE` semantics.

## Extensibility and recommendations

- Encourage using uppercase TYPE tokens. Parsers may accept lowercase but normalize to uppercase internally.
- When adding new TYPEs, add them to this spec with precise semantics and examples.
- Consider allowing multi-line metadata values in the future (for example, YAML-style front matter). If that change is made, update this spec and tooling simultaneously.

## Backwards compatibility

- Files without `///` metadata are treated as before (no change).
- Unknown `TYPE`s are preserved (parsed into a generic metadata map) to avoid breaking existing files and to support gradual extension.

## Implementation notes for site builders

- Prefer a tolerant parser: collect metadata conservatively and surface parse warnings rather than hard-failing the build on a single malformed metadata line.
- Normalize tags (e.g., trim whitespace, collapse duplicates). Decide whether to lowercase tags globally — document the choice in the site generator's config.

---

This spec documents the minimal metadata header format used for blog files under `root/notes`. If you'd like, I can also implement a small parser script (Python/Rust/Node) to extract these headers from all `root/notes` files and produce a tags index for the site generator.
