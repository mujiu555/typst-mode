// Tests for lib/_lib.typ/format.typ
// Run: typst compile examples/format-tests.typ
#import "../lib/_lib.typ/format.typ": parse, fmt

// --- fmt: literals and escapes ---
#assert(fmt("hello") == "hello")
#assert(fmt("") == "")
#assert(fmt("a b c") == "a b c")
#assert(fmt("{{") == "{")
#assert(fmt("}}") == "}")
#assert(fmt("{{}}") == "{}")
#assert(fmt("a {{b}} c") == "a {b} c")

// --- fmt: argument selection ---
#assert(fmt("{}", 42) == "42")
#assert(fmt("{} {}", 1, "a") == "1 a")
#assert(fmt("{0} {0} {1}", "x", "y") == "x x y")
#assert(fmt("{name}!", name: "world") == "world!")
#assert(fmt("{a}-{b}", b: 2, a: 1) == "1-2")

// --- fmt: debug ---
#assert(fmt("{:?}", "hi") == "\"hi\"")
#assert(fmt("{:?}", 42) == "42")

// --- fmt: width / alignment / fill ---
#assert(fmt("{:<5}|", "ab") == "ab   |")
#assert(fmt("{:>5}|", "ab") == "   ab|")
#assert(fmt("{:^5}|", "ab") == " ab  |")
#assert(fmt("{:*>5}", "ab") == "***ab")
#assert(fmt("{:5}", 42) == "   42")    // numeric default = right
#assert(fmt("{:5}", "ab") == "ab   ")  // string default = left

// --- parse: literal / placeholder tokens ---
#let p1 = parse("a{b}c")
#assert(p1.len() == 3)
#assert(p1.at(0) == "a")
#assert(type(p1.at(1)) == dictionary)
#assert(p1.at(2) == "c")

// --- parse: argument selector ---
#assert(parse("{}").at(0).arg == none)
#assert(parse("{0}").at(0).arg == 0)
#assert(parse("{42}").at(0).arg == 42)
#assert(parse("{name}").at(0).arg == "name")

// --- parse: format spec fields ---
#let f = parse("{0:>5}").at(0)
#assert(f.arg == 0 and f.align == ">" and f.width == 5)

#let f = parse("{name:.2}").at(0)
#assert(f.arg == "name" and f.precision == 2)

#let f = parse("{:+x}").at(0)
#assert(f.sign == "+" and f.kind == "x")

#let f = parse("{:#x}").at(0)
#assert(f.alternate == true and f.kind == "x")

#let f = parse("{:08}").at(0)
#assert(f.zero == true and f.width == 8)

#let f = parse("{:*<10}").at(0)
#assert(f.fill == "*" and f.align == "<" and f.width == 10)

// --- parse: adjacent and empty placeholders ---
#let p2 = parse("{}{}")
#assert(p2.len() == 2 and p2.at(0).arg == none and p2.at(1).arg == none)

// --- unicode passthrough (codepoint round-trip is lossless) ---
#assert(fmt("héllo {}, ünïcode", "世界") == "héllo 世界, ünïcode")
#assert(fmt("no placeholders here") == "no placeholders here")

// --- fill + alignment together ---
#let f = parse("{:*^10}").at(0)
#assert(f.fill == "*" and f.align == "^" and f.width == 10)
#assert(fmt("{:_<6}", "ab") == "ab____")
