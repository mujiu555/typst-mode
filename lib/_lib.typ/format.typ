// format.typ — Rust-style `format!` strings, in pure Typst.
//
//   #let parse(fmt) -> array
//     Tokenize a format string. Each token is either:
//       * a literal run of text (a `str`), or
//       * a placeholder (a `dictionary`) with the keys below.
//
//   #let fmt(format, ..args) -> str
//     Format values into a string, resolving `{}`, `{0}` and `{name}`.
//
// Placeholder field keys:
//   arg       none (auto) | int (positional) | str (named)
//   fill      fill character (default `" "`)
//   align     none | "<" | ">" | "^" | "="
//   sign      none | "+" | "-"            (parsed, not rendered yet)
//   alternate bool  ("#")                 (parsed, not rendered yet)
//   zero      bool  ("0")                 (parsed, not rendered yet)
//   width     none | int (or str for `*` / `name$` dynamic width)
//   precision none | int                  (parsed, not rendered yet)
//   kind      none | "?" | "x"|"X"|"o"|"b"|"e"|"E"|"p"
//                                           ("?" rendered; others parsed only)
//
// `fmt` currently renders argument selection, `{:?}` debug, width,
// alignment and fill. The remaining spec fields are parsed faithfully
// (so nothing mis-tokenizes) but left for a later pass.
//
// NOTE: `str.codepoints()` yields single-character *strings* (not ints), and
// `str.at`/`str.slice`/`str.len` index by *byte* — so we parse on the
// codepoint array and join with `""` to rebuild strings.

#let _join = cps => cps.join("")

#let _digits = "0123456789"
#let _lower = "abcdefghijklmnopqrstuvwxyz"
#let _upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#let _is-digit = c => _digits.contains(c)
#let _is-lower = c => _lower.contains(c)
#let _is-upper = c => _upper.contains(c)
#let _is-ident = c => _is-lower(c) or _is-upper(c) or c == "_" or _is-digit(c)

#let _is-align = c => c == "<" or c == ">" or c == "^" or c == "="

#let _is-type = c => (
  c == "?" or c == "x" or c == "X" or c == "o" or c == "b" or c == "e" or c == "E" or c == "p"
)

// Fold a run of ASCII digit characters into an integer.
#let _to-int = chars => chars.fold(0, (acc, c) => acc * 10 + _digits.position(c))

// Read a width/precision count. Returns `(value, next-index)` where value is
// an `int`, a `str` for dynamic forms (`*`, `0$`, `name$`), or `none`.
#let _read-count = (cps, i) => {
  let n = cps.len()
  if i >= n {
    return (none, i)
  }
  if cps.at(i) == "*" {
    return ("*", i + 1)
  }
  let start = i
  // parameter: [ident]+ '$'
  let j = i
  while j < n and _is-ident(cps.at(j)) {
    j += 1
  }
  if j > start and j < n and cps.at(j) == "$" {
    return (_join(cps.slice(start, j + 1)), j + 1)
  }
  // plain integer
  let k = start
  while k < n and _is-digit(cps.at(k)) {
    k += 1
  }
  if k > start {
    return (_to-int(cps.slice(start, k)), k)
  }
  (none, start)
}

// Read the argument selector (up to `:` or `}`).
#let _read-arg = (cps, i) => {
  let n = cps.len()
  let start = i
  while i < n and cps.at(i) != ":" and cps.at(i) != "}" {
    i += 1
  }
  let text = cps.slice(start, i)
  let arg = if text.len() == 0 {
    none
  } else if text.all(_is-digit) {
    _to-int(text)
  } else {
    _join(text)
  }
  (arg, i)
}

// A placeholder with no format spec.
#let _empty-field = arg => (
  arg: arg,
  fill: " ",
  align: none,
  sign: none,
  alternate: false,
  zero: false,
  width: none,
  precision: none,
  kind: none,
)

// Parse the part after `:`. Returns `(field, index-at-"}")`.
#let _parse-spec = (cps, i, arg) => {
  let n = cps.len()
  let fill = " "
  let align = none
  let sign = none
  let alternate = false
  let zero = false
  let width = none
  let precision = none
  let kind = none

  // [[fill]align]
  if i + 1 < n and _is-align(cps.at(i + 1)) {
    fill = cps.at(i)
    align = cps.at(i + 1)
    i += 2
  } else if i < n and _is-align(cps.at(i)) {
    align = cps.at(i)
    i += 1
  }

  // sign
  if i < n and (cps.at(i) == "+" or cps.at(i) == "-") {
    sign = cps.at(i)
    i += 1
  }

  // '#'
  if i < n and cps.at(i) == "#" {
    alternate = true
    i += 1
  }

  // '0'
  if i < n and cps.at(i) == "0" {
    zero = true
    i += 1
  }

  // width
  let (w, j) = _read-count(cps, i)
  if w != none {
    width = w
    i = j
  }

  // precision
  if i < n and cps.at(i) == "." {
    let (p, k) = _read-count(cps, i + 1)
    if p != none {
      precision = p
      i = k
    }
  }

  // type
  if i < n and _is-type(cps.at(i)) {
    kind = cps.at(i)
    i += 1
  }

  (
    (
      arg: arg,
      fill: fill,
      align: align,
      sign: sign,
      alternate: alternate,
      zero: zero,
      width: width,
      precision: precision,
      kind: kind,
    ),
    i,
  )
}

// Parse one `{...}` placeholder. `i` points just after `{`.
// Returns `(field, index-at-"}")`.
#let _parse-format = (cps, i) => {
  let (arg, j) = _read-arg(cps, i)
  if j < cps.len() and cps.at(j) == ":" {
    _parse-spec(cps, j + 1, arg)
  } else {
    (_empty-field(arg), j)
  }
}

// Parse a Rust-style format string into literal/field tokens.
#let parse = format => {
  assert.eq(type(format), str, message: "format: expected a string")
  let cps = format.codepoints()
  let n = cps.len()
  let out = ()
  let i = 0
  let lit = 0
  while i < n {
    let c = cps.at(i)
    if c == "{" {
      if i + 1 < n and cps.at(i + 1) == "{" {
        if lit < i {
          out.push(_join(cps.slice(lit, i)))
        }
        out.push("{")
        i += 2
        lit = i
      } else {
        if lit < i {
          out.push(_join(cps.slice(lit, i)))
        }
        let (field, j) = _parse-format(cps, i + 1)
        assert(
          j < n and cps.at(j) == "}",
          message: "format: unmatched '{' in \"" + format + "\"",
        )
        out.push(field)
        i = j + 1
        lit = i
      }
    } else if c == "}" {
      if i + 1 < n and cps.at(i + 1) == "}" {
        if lit < i {
          out.push(_join(cps.slice(lit, i)))
        }
        out.push("}")
        i += 2
        lit = i
      } else {
        assert(false, message: "format: unmatched '}' in \"" + format + "\"")
      }
    } else {
      i += 1
    }
  }
  if lit < n {
    out.push(_join(cps.slice(lit, n)))
  }
  out
}

// Display a value (Rust's `{}`). `str()` covers int/float/bool/str;
// everything else (content, arrays, dicts, ...) falls back to `repr()`.
#let _display = v => {
  let t = type(v)
  if t == str or t == int or t == float or t == bool {
    str(v)
  } else {
    repr(v)
  }
}

// Pad `s` to `width` codepoints with `fill`, honoring `align`
// ("<" left, ">" right, "^" centered). Never truncates (matches Rust).
#let _pad = (s, width, fill, align) => {
  if width == none or type(width) != int or width <= 0 {
    return s
  }
  let len = s.codepoints().len()
  if len >= width {
    return s
  }
  let n = width - len
  if align == "<" {
    s + range(n).map(_ => fill).join("")
  } else if align == "^" {
    let half = calc.floor(n / 2)
    range(half).map(_ => fill).join("") + s + range(n - half).map(_ => fill).join("")
  } else {
    // ">" (and "=") pad on the left
    range(n).map(_ => fill).join("") + s
  }
}

// Format values Rust-style.
#let fmt = (format, ..args) => {
  let pos = args.pos()
  let named = args.named()
  let implicit = 0
  let out = ()
  for token in parse(format) {
    if type(token) == str {
      out.push(token)
    } else {
      let value = if token.arg == none {
        let v = pos.at(implicit)
        implicit = implicit + 1
        v
      } else if type(token.arg) == int {
        pos.at(token.arg)
      } else {
        named.at(token.arg)
      }
      let text = if token.kind == "?" {
        repr(value)
      } else {
        _display(value)
      }
      // Rust's default alignment is right for numbers, left otherwise.
      let align = if token.align != none {
        token.align
      } else if type(value) == int or type(value) == float {
        ">"
      } else {
        "<"
      }
      out.push(_pad(text, token.width, token.fill, align))
    }
  }
  if out.len() == 0 {
    ""
  } else {
    out.join("")
  }
}
