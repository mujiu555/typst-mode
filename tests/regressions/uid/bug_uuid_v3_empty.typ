// expect-failure: assertion failed
// Expected UUID calculated independently with Node crypto (decoded namespace bytes, MD5, RFC bit masks).
#import "/lib/_lib.typ/uid.typ": *
#assert.eq(v3(namespaces.dns, ""), "c87ee674-4ddc-3efe-a74e-dfe25da5d7b3")
