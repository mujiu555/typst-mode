// expect-failure: assertion failed
// Expected UUID calculated independently with Node crypto (decoded namespace bytes, MD5, RFC bit masks).
#import "/lib/_lib.typ/uid.typ": *
#assert.eq(v3(namespaces.dns, "www.widgets.com"), "3d813cbb-47fb-32ba-91df-831e1593ac29")
