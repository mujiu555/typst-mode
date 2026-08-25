// Tests for lib/_lib.typ/uid.typ.
//
// `v3(namespace, name)` produces a deterministic 36-character UUID string by
// hashing `namespace + U+001F + name` with MD5 (the standard UUID v3
// namespace-name concatenation). Note: unlike a strict RFC-4122 UUID v3 the
// version/variant bits are not set, so the values here are the library's own
// canonical form — the test vector below was computed with the same MD5.

#import "/lib/_lib.typ/uid.typ": namespaces, v3

#set page(margin: 2cm)
#set text(size: 10pt)

#heading(level: 1)[uid — deterministic UUIDs]

// ---------------------------------------------------------------------
// 1. Known test vector
// ---------------------------------------------------------------------
#heading(level: 2)[1. Known vector]

// `md5("6ba7b810-9dad-11d1-80b4-00c04fd430c8" + U+001F + "www.example.org")`
// is `38e3c7baa7ce2ba32956d3486be564c0`; the first 32 hex digits are grouped
// as 8-4-4-4-12.
#assert.eq(
  v3(namespaces.dns, "www.example.org"),
  "38e3c7ba-a7ce-2ba3-2956-d3486be564c0",
  message: "known vector (DNS namespace)",
)

// ---------------------------------------------------------------------
// 2. Format
// ---------------------------------------------------------------------
#heading(level: 2)[2. Format]

#let u = v3(namespaces.oid, "doc-a")

// Exactly 36 characters, grouped 8-4-4-4-12.
#assert.eq(u.len(), 36, message: "uuid length")
#assert.eq(u.at(8), "-", message: "dash after group 1")
#assert.eq(u.at(13), "-", message: "dash after group 2")
#assert.eq(u.at(18), "-", message: "dash after group 3")
#assert.eq(u.at(23), "-", message: "dash after group 4")

// The 32 non-dash characters are all lowercase hex digits.
#let hex-chars = "0123456789abcdef"
#let no-dash = u.replace("-", "")
#let all-hex = no-dash.codepoints().all(c => hex-chars.codepoints().contains(c))
#assert(all-hex, message: "all characters are hex digits")

// ---------------------------------------------------------------------
// 3. Determinism
// ---------------------------------------------------------------------
#heading(level: 2)[3. Determinism]

// Same inputs always produce the same UUID.
#assert.eq(v3(namespaces.dns, "www.example.org"), v3(namespaces.dns, "www.example.org"))
#assert.eq(v3(namespaces.oid, "doc-a"), v3(namespaces.oid, "doc-a"))

// ---------------------------------------------------------------------
// 4. Uniqueness
// ---------------------------------------------------------------------
#heading(level: 2)[4. Uniqueness]

// Different names hash differently, even under the same namespace.
#assert.ne(v3(namespaces.dns, "www.example.org"), v3(namespaces.dns, "example.org"))
#assert.ne(v3(namespaces.dns, "a"), v3(namespaces.dns, "aa"))

// The same name under different namespaces hashes differently.
#assert.ne(v3(namespaces.dns, "www.example.org"), v3(namespaces.url, "www.example.org"))
#assert.ne(v3(namespaces.oid, "www.example.org"), v3(namespaces.x500, "www.example.org"))

// Every documented namespace has its own constant.
#assert.eq(namespaces.dns, "6ba7b810-9dad-11d1-80b4-00c04fd430c8")
#assert.eq(namespaces.url, "6ba7b811-9dad-11d1-80b4-00c04fd430c8")
#assert.eq(namespaces.oid, "6ba7b812-9dad-11d1-80b4-00c04fd430c8")
#assert.eq(namespaces.x500, "6ba7b814-9dad-11d1-80b4-00c04fd430c8")

// A short and a long name both produce the canonical form.
#assert.eq(v3(namespaces.oid, "a").len(), 36)
#assert.eq(v3(namespaces.oid, "x" * 100).len(), 36)

// ---------------------------------------------------------------------
// Rendered summary
// ---------------------------------------------------------------------
#heading(level: 2)[Results]
#let render(d) = [== #repr(d)]
#render(v3(namespaces.dns, "www.example.org"))
#render(v3(namespaces.oid, "doc-a"))
