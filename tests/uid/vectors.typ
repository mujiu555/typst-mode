// Manual: typst compile --root . tests/uid/vectors.typ /tmp/uid-vectors.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Additional regression vectors, generated independently with Python:
// str(uuid.uuid5(namespace, name)). These are not official RFC vectors.
#assert.eq(uid(namespaces.dns, ""), "4ebd0208-8328-5d69-8c44-ec50939c0967")
#assert.eq(uid(namespaces.dns, "name"), "9b8edca0-90f2-5031-8e5d-3f708834696c")
#assert.eq(uid(namespaces.url, "https://example.com/"), "dd2c1780-811a-5296-81c5-178a0ef488bc")
#assert.eq(uid(namespaces.oid, "1.3.6.1"), "1447fa61-5277-5fef-a9b3-fbc6e44f4af3")
#assert.eq(uid(namespaces.x500, "CN=example"), "d31873d3-1002-5cb9-98ae-dae7a10a748d")
#assert.eq(uid(namespaces.dns, "笔记🚀"), "7ba64e00-3ddf-5833-8af3-95f724ce9701")
#assert.eq(uid(namespaces.dns, "é"), "ebfe0af8-3997-5ade-b634-ba92cf69f557")
#assert.eq(uid(namespaces.dns, "é"), "39004b7f-2a0b-588c-88f7-aa24552a7636")
// Raw binary name, including NUL and bytes that are not valid UTF-8.
#assert.eq(uid(namespaces.dns, bytes((0, 255, 128, 1))), "4724ab16-45ab-5b1f-98e9-d7066465a6a3")
