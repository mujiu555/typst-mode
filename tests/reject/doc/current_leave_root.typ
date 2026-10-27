// expect-error: Cannot leave the root document scope
// Function test: reject/doc/current_leave_root
// Manual: typst compile --root . tests/reject/doc/current_leave_root.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Unrelated errors are not a passing test.
#import "/lib/_lib.typ/doc.typ": current
#(current.leave)()
#context assert.eq(type((current.get)()), dictionary)
