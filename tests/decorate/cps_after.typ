#import "/lib/_lib.typ/decorate.typ": *
#assert.eq(decorate-cps(x => x)(after: (next, x, ..rest) => next(x + 10))(2), 12)
