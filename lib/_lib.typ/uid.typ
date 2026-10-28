// Deterministic hash-based identifiers. A namespace is an identifier in
// 8-4-4-4-12 hexadecimal form (case-insensitive), or its 16 raw bytes.
// Names are UTF-8 strings or bytes; their spelling is preserved exactly.
#let uid(namespace, name) = {
  let hex-digits = "0123456789abcdef"
  let namespace-bytes = if type(namespace) == bytes {
    assert(namespace.len() == 16, message: "uid namespace must contain 16 bytes")
    namespace
  } else {
    assert(type(namespace) == str, message: "uid namespace must be an identifier string or bytes")
    assert(
      namespace.match(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")) != none,
      message: "uid namespace must have 8-4-4-4-12 hexadecimal form",
    )
    let digits = lower(namespace).replace("-", "")
    bytes(range(0, 32, step: 2).map(i => {
      hex-digits.position(digits.at(i)) * 16 + hex-digits.position(digits.at(i + 1))
    }))
  }
  assert(type(name) == str or type(name) == bytes, message: "uid name must be a string or bytes")

  // SHA-1 words stay unsigned modulo 2^32. Division and remainder extract
  // bits; reducing before multiplication keeps rotations within 32 bits.
  let modulus = 4294967296
  let rotate(x, n) = {
    let split = calc.pow(2, 32 - n)
    calc.rem(x, split) * calc.pow(2, n) + calc.quo(x, split)
  }
  // SHA-1's choice, parity, and majority functions, one bit at a time.
  let combine(x, y, z, mode) = {
    let result = 0
    let place = 1
    for _ in range(32) {
      let a = calc.rem(x, 2)
      let b = calc.rem(y, 2)
      let c = calc.rem(z, 2)
      let bit = if mode == 0 {
        a * b + (1 - a) * c
      } else if mode == 2 {
        calc.quo(a + b + c, 2)
      } else {
        calc.rem(a + b + c, 2)
      }
      result += bit * place
      x = calc.quo(x, 2)
      y = calc.quo(y, 2)
      z = calc.quo(z, 2)
      place *= 2
    }
    result
  }

  let data = array(namespace-bytes + bytes(name))
  let bit-length = data.len() * 8
  data.push(128)
  while calc.rem(data.len(), 64) != 56 { data.push(0) }
  // Append the original length as eight bytes in network byte order.
  for shift in range(7, -1, step: -1) {
    data.push(calc.rem(calc.quo(bit-length, calc.pow(256, shift)), 256))
  }

  let hash = (1732584193, 4023233417, 2562383102, 271733878, 3285377520)
  for offset in range(0, data.len(), step: 64) {
    let words = range(16).map(i => {
      let start = offset + i * 4
      data.at(start) * 16777216 + data.at(start + 1) * 65536 + data.at(start + 2) * 256 + data.at(start + 3)
    })
    for i in range(16, 80) {
      let parity = combine(words.at(i - 3), words.at(i - 8), words.at(i - 14), 1)
      words.push(rotate(combine(parity, words.at(i - 16), 0, 1), 1))
    }
    let (a, b, c, d, e) = hash
    for i in range(80) {
      let stage = calc.quo(i, 20)
      let k = (1518500249, 1859775393, 2400959708, 3395469782).at(stage)
      let next = calc.rem(rotate(a, 5) + combine(b, c, d, stage) + e + k + words.at(i), modulus)
      e = d
      d = c
      c = rotate(b, 30)
      b = a
      a = next
    }
    hash = hash.zip((a, b, c, d, e)).map(((old, new)) => calc.rem(old + new, modulus))
  }

  // Keep the first 128 digest bits, replacing only the reserved bits.
  let result = ()
  for word in hash.slice(0, 4) {
    for shift in range(3, -1, step: -1) {
      result.push(calc.rem(calc.quo(word, calc.pow(256, shift)), 256))
    }
  }
  result.at(6) = calc.rem(result.at(6), 16) + 80
  result.at(8) = calc.rem(result.at(8), 64) + 128
  let hex = result.map(b => hex-digits.at(calc.quo(b, 16)) + hex-digits.at(calc.rem(b, 16))).join("")
  (hex.slice(0, 8) + "-" + hex.slice(8, 12) + "-" + hex.slice(12, 16)
    + "-" + hex.slice(16, 20) + "-" + hex.slice(20))
}

#let namespaces = (
  dns: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
  url: "6ba7b811-9dad-11d1-80b4-00c04fd430c8",
  oid: "6ba7b812-9dad-11d1-80b4-00c04fd430c8",
  x500: "6ba7b814-9dad-11d1-80b4-00c04fd430c8",
)
