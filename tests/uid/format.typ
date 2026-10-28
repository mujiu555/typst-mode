// Manual: typst compile --root . tests/uid/format.typ /tmp/uid-format.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Independent regression vectors generated with Python's uuid.uuid5.
// Exercise all four variant nibbles, preserving the digest's low two bits.
#let cases = (
  ("variant-0", "7d79d3d3-5901-58f6-b631-390b5150eae8"),
  ("variant-1", "ab901086-5e54-5353-8ce9-bbced2c5bbc9"),
  ("variant-3", "19e93f46-4b93-5999-aa8c-8c9a5a843e38"),
  ("variant-6", "17deab02-92d9-5a13-9c1b-1b5cfac7ebda"),
)
#for (name, expected) in cases {
  let value = uid(namespaces.dns, name)
  assert.eq(value, expected)
  assert.eq(value.split("-").map(part => part.len()), (8, 4, 4, 4, 12))
  assert.eq(value.len(), 36)
  assert.eq(value.at(14), "5")
  assert(("8", "9", "a", "b").contains(value.at(19)))
  assert.eq(value, lower(value))
}
