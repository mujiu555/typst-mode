// Manual: typst compile --root . tests/regressions/package/description.typ /tmp/typst-test.pdf
#let package = toml("/typst.toml").package
#assert(package.description.trim().len() > 0, message: "Package description must not be empty")
