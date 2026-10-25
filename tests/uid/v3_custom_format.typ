// Manual: typst compile --root . tests/uid/v3_custom_format.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": v3, namespaces
#let value = v3(namespaces.dns, "www.widgets.com")
#assert.eq(value, "fe5a52d1-703f-3326-8919-2d96003288f3")
#assert.eq(value.split("-").map(part => part.len()), (8, 4, 4, 4, 12))
#assert.eq(value.at(14), "3")
#assert.eq(value.at(19), "8")
#assert.eq(v3(bytes("ns"), bytes("name")), v3("ns", "name"))
