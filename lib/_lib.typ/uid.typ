#import "@preview/digestify:0.2.0": bytes-to-hex, md5

#let v3(namespace, name) = {
  // 1. 将命名空间和名称转换为字节并拼接
  let namespace_bytes = bytes(namespace)
  let name_bytes = bytes(name)
  let data = namespace_bytes + name_bytes

  // 2. 计算 MD5 哈希
  let hash = md5(data)

  // 3. 将哈希字节转换为十六进制字符串
  let hex = bytes-to-hex(hash)

  // 4. 按 RFC 4122 规范设置版本号 (v3) 和变体 (variant)
  // 版本号: 将第13个十六进制字符设置为 '3'
  let hex_with_version = hex.slice(0, 12) + "3" + hex.slice(13)

  // 变体: 将第17个十六进制字符设置为 '8', '9', 'a', 或 'b' 中的一个
  // 这里简单设置为 '8'
  let hex_with_variant = hex_with_version.slice(0, 16) + "8" + hex_with_version.slice(17)

  // 5. 按 8-4-4-4-12 的格式插入连字符
  let uuid = (
    hex_with_variant.slice(0, 8)
      + "-"
      + hex_with_variant.slice(8, 12)
      + "-"
      + hex_with_variant.slice(12, 16)
      + "-"
      + hex_with_variant.slice(16, 20)
      + "-"
      + hex_with_variant.slice(20)
  )

  uuid
}

#let namespaces = (
  dns: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
  url: "6ba7b811-9dad-11d1-80b4-00c04fd430c8",
  oid: "6ba7b812-9dad-11d1-80b4-00c04fd430c8",
  x500: "6ba7b814-9dad-11d1-80b4-00c04fd430c8",
)
