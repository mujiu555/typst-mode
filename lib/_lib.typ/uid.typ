#import "@preview/digestify:0.2.0": bytes-to-hex, md5

#let v3(namespace, name) = {
  let combined = namespace + "\u{001F}" + name
  let h = md5(bytes(combined))
  let hex = bytes-to-hex(h)
  while hex.len() < 32 { hex = "0" + hex }
  if hex.len() > 32 { hex = hex.slice(0, 32) }
  hex.slice(0, 8) + "-" + hex.slice(8, 12) + "-" + hex.slice(12, 16) + "-" + hex.slice(16, 20) + "-" + hex.slice(20, 32)
}

#let namespaces = (
  dns: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
  url: "6ba7b811-9dad-11d1-80b4-00c04fd430c8",
  oid: "6ba7b812-9dad-11d1-80b4-00c04fd430c8",
  x500: "6ba7b814-9dad-11d1-80b4-00c04fd430c8",
)
