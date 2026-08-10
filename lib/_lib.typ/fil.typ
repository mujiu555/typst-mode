#import "./meta.typ": current, fetch-meta, header-depth

#let embed(file) = context {
  assert.eq(type(file), str)
  let p = current.get()
  header-depth.update(prev => prev + 1)
  set heading(depth: header-depth.get())
  include (file)
  header-depth.update(prev => prev - 1)
  set heading(depth: header-depth.get())
  current.update(prev => p)
}

