// expect-error: Cannot leave the root document scope
#import "/lib/_lib.typ/lib.typ": *
#(current.leave)()
#context { let value = (current.final)(); assert.eq(value, (:)) }
