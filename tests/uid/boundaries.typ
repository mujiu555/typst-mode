// Manual: typst compile --root . tests/uid/boundaries.typ /tmp/uid-boundaries.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#assert(uid(namespaces.dns, "a") != uid(namespaces.dns, "b"))
#assert(uid(namespaces.dns, "") != uid(namespaces.dns, " "))
#assert(uid(namespaces.dns, "Name") != uid(namespaces.dns, "name"))
// The 16-byte namespace counts toward SHA-1 padding and block boundaries.
// Reference values: str(uuid.uuid5(uuid.NAMESPACE_DNS, "x" * length)).
#let cases = (
  (38, "f3ddef67-6e5b-53ca-baa2-12b379ef6ced"),
  (39, "2f80c0d1-1c62-579f-8d68-e61ad5592c9b"),
  (40, "e56fd57a-7633-5e1d-8f80-70e05ac413e5"),
  (41, "ab3d3b41-220b-59ab-8b91-f83dcaeaa895"),
  (47, "a112377b-8258-5ef7-b5b0-d2540bc03abb"),
  (48, "83993b6c-dea9-55ca-be5b-9989c85943fc"),
  (49, "a0f0b33b-afbf-5cad-b334-d8140d5af575"),
  (103, "69b5a616-6ae8-5c37-8b46-37d527314c4d"),
  (104, "c917ca2c-8395-5e00-8f28-a898d41a4b8d"),
  (111, "1a48738a-dc98-5032-bf56-974c361d949d"),
  (112, "0243b19e-8bd4-5b57-95a2-1fcacc3142a0"),
  (4096, "f3c5033f-4688-5625-b594-e095cc6d03a9"),
)
#for (length, expected) in cases {
  assert.eq(uid(namespaces.dns, "x" * length), expected)
}
