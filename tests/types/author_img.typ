// Function test: types/author_img
// Manual: typst compile --root . tests/types/author_img.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#let a = (author.new)(name: "A", affiliation: "Org", email: "a@b", orcid: "id")
#assert.eq((a.fields)(), (name: "A", affiliation: "Org", email: "a@b", orcid: "id"))
#assert.eq(img.null.variant, "null")
#assert.eq((img.path)(p: "cover.png").payload.p, "cover.png")
#assert.eq((img.data)(p: bytes((1, 2))).payload.p, bytes((1, 2)))
