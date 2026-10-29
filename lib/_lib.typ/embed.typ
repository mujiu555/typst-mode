#import "doc.typ": current
#import "ssg.render.typ": is-bundle-output

// #embed(include "child.typ") resolves relative paths at the call site.
#let embed(body) = {
  (current.enter)()
  context {
    if target() == "bundle" or is-bundle-output() {
      body
    } else {
      set heading(offset: heading.offset + 1)
      body
    }
  }
  (current.leave)()
}
