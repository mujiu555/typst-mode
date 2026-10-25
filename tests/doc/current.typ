// Function test: doc/current
// Manual: typst compile --root . tests/doc/current.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/doc.typ": current
#(current.update)((id: "root"))
#(current.enter)()
#(current.update)(v => (id: v.id + "-child"))
#metadata("child") <child>
#context assert.eq((current.get)().id, "root-child")
#(current.leave)()
#context {
 assert.eq((current.get)().id, "root")
 assert.eq((current.at)(<child>).id, "root-child")
 assert.eq((current.final)().id, "root")
}
