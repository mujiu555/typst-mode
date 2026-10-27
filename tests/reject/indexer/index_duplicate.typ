// expect-error: duplicate label
#import "/lib/_lib.typ/lib.typ": *
#mkindex("a", [One])
#mkindex("a", [Two])
