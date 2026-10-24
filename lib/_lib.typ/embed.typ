#import "doc.typ": current

// #embed(include "child.typ") resolves relative paths at the call site.
#let embed(body) = context {
  let parent = (current.get)()
  // Keep the context anchor before any leading metadata/page break in body.
  box(width: 0pt, height: 0pt)
  set heading(offset: heading.offset + 1)
  body
  (current.update)(parent)
}
