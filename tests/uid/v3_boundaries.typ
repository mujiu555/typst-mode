// Manual: typst compile --root . tests/uid/v3_boundaries.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": v3
// Characterize the custom concatenation contract: variable-length namespaces
// are not framed, so these pairs intentionally hash the same byte sequence.
#assert.eq(v3("ab", "c"), v3("a", "bc"))
#assert(v3("fixed", "a") != v3("fixed", "b"))
#assert(v3("fixed", "") != v3("fixed", " "))
#assert(v3("fixed", "Name") != v3("fixed", "name"))
