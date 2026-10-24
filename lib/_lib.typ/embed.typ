#import "doc.typ": current

// #embed(include "child.typ") resolves relative paths at the call site.
#let embed(body) = {
  (current.enter)()
  context {
    set heading(offset: heading.offset + 1)
    body
  }
  (current.leave)()
}
