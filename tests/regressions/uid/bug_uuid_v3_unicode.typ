// expect-failure: assertion failed
// Expected UUID calculated independently with Node crypto (decoded namespace bytes, MD5, RFC bit masks).
#import "/lib/_lib.typ/uid.typ": *
#assert.eq(v3(namespaces.dns, "λ👩‍🔬"), "f7fabcd5-a4da-3956-8825-8d865de0e9bd")
