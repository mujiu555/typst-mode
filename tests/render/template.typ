// Function test: render/template
// Manual: typst compile --root . tests/render/template.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#show: template
#meta(id: "unit", title: [Title], authors: ())
#metadata("body") <template-body>
#context {
 assert.eq(query(<template-body>).len(), 1)
 assert.eq(page.width, 210mm)
 assert.eq(page.height, 297mm)
 assert.eq(page.margin, 2em)
}
