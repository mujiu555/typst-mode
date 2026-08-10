#let repri(r) = if type(r) == str {
  r
} else {
  repr(r)
}

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    repri(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}
