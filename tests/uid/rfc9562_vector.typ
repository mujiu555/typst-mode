// Manual: typst compile --root . tests/uid/rfc9562_vector.typ /tmp/uid-rfc9562_vector.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Official RFC 9562 Appendix A.4, Figures 22–24:
// https://www.rfc-editor.org/rfc/rfc9562.html#appendix-A.4
// DNS namespace + UTF-8 "www.example.com".
// SHA-1: 2ed6657de927468b55e12665a8aea6a22dee3e35
// The expected value is copied from the RFC, not computed by this test.
#let expected = "2ed6657d-e927-568b-95e1-2665a8aea6a2"
#assert.eq(namespaces.dns, "6ba7b810-9dad-11d1-80b4-00c04fd430c8")
#assert.eq(uid(namespaces.dns, "www.example.com"), expected)
// The same official input in network byte order, including non-ASCII bytes.
#let dns-bytes = bytes((107, 167, 184, 16, 157, 173, 17, 209, 128, 180, 0, 192, 79, 212, 48, 200))
#assert.eq(uid(dns-bytes, bytes("www.example.com")), expected)
#assert.eq(uid(upper(namespaces.dns), "www.example.com"), expected)
