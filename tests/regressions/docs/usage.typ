// Manual: typst compile --root . tests/regressions/docs/usage.typ /tmp/typst-test.pdf
#let readme = read("/README.md")
#assert(readme.contains("## Usage"), message: "README needs a Usage section")
#let usage = readme.split("## Usage").at(1).split("## ").first().trim()
#assert(usage.len() > 0, message: "README Usage section must contain instructions")
