// Manual: typst compile --root . tests/regressions/package/name.typ /tmp/typst-test.pdf
#let package = toml("/typst.toml").package
#assert(package.name.trim().len() > 0, message: "Package name must not be empty")
