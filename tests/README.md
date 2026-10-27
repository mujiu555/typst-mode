# Tests

Run from the repository root with Node.js and Typst on PATH:

```sh
node tests/run.mjs
node tests/run.mjs --strict
node tests/run.mjs --filter=record
node tests/run.mjs --filter=bug
```

`TYPST` can select another Typst executable. The library requires
`@preview/digestify:0.2.0`; Typst must have it cached or be able to download it.
The suite was developed against Typst 0.14.2 and Node.js 24.

Each case compiles independently, preventing state from leaking between cases.
Temporary PDFs live in a unique `.run-*` directory here and are
removed in `finally`. Every compilation has a 30-second timeout. Expected
rejections must contain the designated diagnostic; subprocess errors, timeouts,
missing dependencies, and layout-convergence warnings cannot count as passes.

`XFAIL` identifies a reproduced library defect. The default command succeeds
when all other tests pass; `--strict` fails if any known defect remains. A fixed
defect produces `XPASS` and fails either mode so its expectation can be updated.
These are assertions of intended behavior, not assertions that buggy output is
correct. The runner prints totals and exits nonzero for unexpected results.

The runner discovers every `.typ` file recursively under `tests/`, including
fixture self-checks. Rejection tests declare
their required diagnostic with `// expect-error: ...`. Known-defect tests in
`regressions/` use `// expect-failure: ...`; all other files must compile
successfully. Files compile at their original paths, so relative imports and
file reads work without an external staging copy.

The PNG and SVG files are shared test data. Obsolete API tests have been removed
or migrated to current APIs, including `mkdoc(...)[body]`. A filter that matches
no cases exits nonzero. Test cases live beside other tests for the same module;
rejection cases are in `reject/<module>/` and known defects in
`regressions/<module>/`. Shared assets live in `fixtures/`.

| Library module | Checks |
| --- | --- |
| `record.typ` | Empty records, descriptions and IDs, native and nested fields, asymmetric comparison, construction, updates and immutability, partial application and overrides, methods calling methods, method rebinding, built-in names as instance methods/data, invalid schemas/fields/methods and reserved names |
| `enum.typ` | Empty enums, all constructor routes, raw/record/enum payloads, `none`/`auto` payload types, narrowing/widening, nested variance, field extraction, partial application, method dispatch and overrides, rejected variants/payloads/names |
| `util.typ` | Schema recognition, native/custom matching, malformed schema rejection, type acceptance, reserved-name checks and method binding |
| `types.typ` | Author schema, every publication category, image path/data/null variants, recursive field extraction and invalid metadata values |
| `uid.typ` | Determinism, namespaces, Unicode and empty input, UUID shape/version/variant, RFC v3 vectors calculated independently with Node's MD5 and namespace-byte decoding |
| `decorate.typ` | Identity, positional/named forwarding, before/after/prev/fwd hooks, `_b`/`_a`/`_f`, `none` results, CPS defaults and custom hooks |
| `state.typ` | Namespacing, aliases, isolated states, initial/current/final/location reads and value/function updates |
| `doc.typ` | Initial state, current stack, enter/leave, nested restoration, location/final reads, functional updates, root underflow, defaults and every metadata field |
| `art.typ` | Registration, required fields, every field's type rejection, array element validation, duplicates, implicit roots, forward parents, unresolved parents, cycles and parent chains |
| `tag.typ` | Empty/deep trees, parent IDs, deterministic namespaces, distinct paths, sub-tags, malformed trees, exact-tag retrieval, deduplication and document-state consistency |
| `embed.typ` | Inherited current document, nested restoration, twelve sibling scopes, heading offsets |
| `indexer.typ` | Forward/backward and repeated links, empty labels/content, duplicates, missing targets, stored destinations and backlink content/counts |
| `render.typ` | All public renderers, missing metadata, cover path/bytes/null, authors and details, outlines, heading levels, body emission and registration order, embedded scope restoration, page breaks, abstract, children/no children, exact tag tree and metadata-only documents, numbered/default pages, navigation, grapheme-aware truncation, empty/styled content |
| `typstmode.typ`, `lib.typ` | Public facade imports exercised by the integration fixtures |

The tests use value assertions and document queries, not PDF pixel comparisons.
They cover the branches and boundary cases listed here; they do not claim an
exhaustive proof for every possible Typst value or visual layout.

See [BUGS.md](BUGS.md) for the reproduced defects. Library files are unchanged.
