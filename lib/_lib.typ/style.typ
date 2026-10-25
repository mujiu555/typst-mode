#import "types.typ": img
#import "record.typ": record
#import "enum.typ": enumerator
#import "record.typ": impl_record, record
#import "enum.typ": enumerator, impl_enum
#import "uid.typ": namespaces, v3
#import "state.typ": _mkstate

#let _ns_stlye = v3(namespaces.oid, "4cff74bd-1751-4de9-b29c-aa177649d4e9")
#let _style_uuid(name) = v3(_ns_stlye, name)

#let style = _mkstate(
  "123389fe-512d-499e-a357-a9bad0ca1926",
  (:),
)

#let _page_size = {
  let _page_size = enumerator(
    a0: record(),
    a1: record(),
    a10: record(),
    a11: record(),
    a2: record(),
    a3: record(),
    a4: record(),
    a5: record(),
    a6: record(),
    a7: record(),
    a8: record(),
    a9: record(),
    ansi-a: record(),
    ansi-b: record(),
    ansi-c: record(),
    ansi-d: record(),
    ansi-e: record(),
    arch-a: record(),
    arch-b: record(),
    arch-c: record(),
    arch-d: record(),
    arch-e: record(),
    arch-e1: record(),
    asia-f4: record(),
    cn-business-card: record(),
    din-d3: record(),
    din-d4: record(),
    din-d5: record(),
    din-d6: record(),
    din-d7: record(),
    din-d8: record(),
    eu-business-card: record(),
    fr-carré: record(),
    fr-couronne-écriture: record(),
    fr-couronne-édition: record(),
    fr-jésus: record(),
    fr-raisin: record(),
    fr-tellière: record(),
    iso-b1: record(),
    iso-b2: record(),
    iso-b3: record(),
    iso-b4: record(),
    iso-b5: record(),
    iso-b6: record(),
    iso-b7: record(),
    iso-b8: record(),
    iso-c3: record(),
    iso-c4: record(),
    iso-c5: record(),
    iso-c6: record(),
    iso-c7: record(),
    iso-c8: record(),
    iso-id-1: record(),
    iso-id-2: record(),
    iso-id-3: record(),
    jis-b0: record(),
    jis-b1: record(),
    jis-b10: record(),
    jis-b11: record(),
    jis-b2: record(),
    jis-b3: record(),
    jis-b4: record(),
    jis-b5: record(),
    jis-b6: record(),
    jis-b7: record(),
    jis-b8: record(),
    jis-b9: record(),
    jp-business-card: record(),
    jp-kiku-4: record(),
    jp-kiku-5: record(),
    jp-shiroku-ban-4: record(),
    jp-shiroku-ban-5: record(),
    jp-shiroku-ban-6: record(),
    newspaper-berliner: record(),
    newspaper-broadsheet: record(),
    newspaper-compact: record(),
    presentation-16-9: record(),
    presentation-4-3: record(),
    sac-d0: record(),
    sac-d1: record(),
    sac-d2: record(),
    sac-d3: record(),
    sac-d4: record(),
    sac-d5: record(),
    sac-d6: record(),
    sis-e5: record(),
    sis-g5: record(),
    uk-book-a: record(),
    uk-book-b: record(),
    uk-brief: record(),
    uk-crown: record(),
    uk-draft: record(),
    uk-foolscap: record(),
    uk-quarto: record(),
    us-business-card: record(),
    us-digest: record(),
    us-executive: record(),
    us-foolscap-folio: record(),
    us-gov-legal: record(),
    us-gov-letter: record(),
    us-ledger: record(),
    us-legal: record(),
    us-letter: record(),
    us-oficio: record(),
    us-statement: record(),
    us-tabloid: record(),
    us-trade: record(),
    custom: record(
      width: length,
      height: length,
    ),
  )

  _page_size = impl_enum(
    _page_size,
    display: self => {
      it => {
        if "custom" == self.variant {
          set page(width: self.payload.width, height: self.payload.height)
        } else {
          set page(paper: self.variant)
        }
      }
    },
  )

  _page_size = (
    _page_size
      + (
        a0: (_page_size.a0)(),
        a1: (_page_size.a1)(),
        a10: (_page_size.a10)(),
        a11: (_page_size.a11)(),
        a2: (_page_size.a2)(),
        a3: (_page_size.a3)(),
        a4: (_page_size.a4)(),
        a5: (_page_size.a5)(),
        a6: (_page_size.a6)(),
        a7: (_page_size.a7)(),
        a8: (_page_size.a8)(),
        a9: (_page_size.a9)(),
        ansi-a: (_page_size.ansi-a)(),
        ansi-b: (_page_size.ansi-b)(),
        ansi-c: (_page_size.ansi-c)(),
        ansi-d: (_page_size.ansi-d)(),
        ansi-e: (_page_size.ansi-e)(),
        arch-a: (_page_size.arch-a)(),
        arch-b: (_page_size.arch-b)(),
        arch-c: (_page_size.arch-c)(),
        arch-d: (_page_size.arch-d)(),
        arch-e: (_page_size.arch-e)(),
        arch-e1: (_page_size.arch-e1)(),
        asia-f4: (_page_size.asia-f4)(),
        cn-business-card: (_page_size.cn-business-card)(),
        din-d3: (_page_size.din-d3)(),
        din-d4: (_page_size.din-d4)(),
        din-d5: (_page_size.din-d5)(),
        din-d6: (_page_size.din-d6)(),
        din-d7: (_page_size.din-d7)(),
        din-d8: (_page_size.din-d8)(),
        eu-business-card: (_page_size.eu-business-card)(),
        fr-carré: (_page_size.fr-carré)(),
        fr-couronne-écriture: (_page_size.fr-couronne-écriture)(),
        fr-couronne-édition: (_page_size.fr-couronne-édition)(),
        fr-jésus: (_page_size.fr-jésus)(),
        fr-raisin: (_page_size.fr-raisin)(),
        fr-tellière: (_page_size.fr-tellière)(),
        iso-b1: (_page_size.iso-b1)(),
        iso-b2: (_page_size.iso-b2)(),
        iso-b3: (_page_size.iso-b3)(),
        iso-b4: (_page_size.iso-b4)(),
        iso-b5: (_page_size.iso-b5)(),
        iso-b6: (_page_size.iso-b6)(),
        iso-b7: (_page_size.iso-b7)(),
        iso-b8: (_page_size.iso-b8)(),
        iso-c3: (_page_size.iso-c3)(),
        iso-c4: (_page_size.iso-c4)(),
        iso-c5: (_page_size.iso-c5)(),
        iso-c6: (_page_size.iso-c6)(),
        iso-c7: (_page_size.iso-c7)(),
        iso-c8: (_page_size.iso-c8)(),
        iso-id-1: (_page_size.iso-id-1)(),
        iso-id-2: (_page_size.iso-id-2)(),
        iso-id-3: (_page_size.iso-id-3)(),
        jis-b0: (_page_size.jis-b0)(),
        jis-b1: (_page_size.jis-b1)(),
        jis-b10: (_page_size.jis-b10)(),
        jis-b11: (_page_size.jis-b11)(),
        jis-b2: (_page_size.jis-b2)(),
        jis-b3: (_page_size.jis-b3)(),
        jis-b4: (_page_size.jis-b4)(),
        jis-b5: (_page_size.jis-b5)(),
        jis-b6: (_page_size.jis-b6)(),
        jis-b7: (_page_size.jis-b7)(),
        jis-b8: (_page_size.jis-b8)(),
        jis-b9: (_page_size.jis-b9)(),
        jp-business-card: (_page_size.jp-business-card)(),
        jp-kiku-4: (_page_size.jp-kiku-4)(),
        jp-kiku-5: (_page_size.jp-kiku-5)(),
        jp-shiroku-ban-4: (_page_size.jp-shiroku-ban-4)(),
        jp-shiroku-ban-5: (_page_size.jp-shiroku-ban-5)(),
        jp-shiroku-ban-6: (_page_size.jp-shiroku-ban-6)(),
        newspaper-berliner: (_page_size.newspaper-berliner)(),
        newspaper-broadsheet: (_page_size.newspaper-broadsheet)(),
        newspaper-compact: (_page_size.newspaper-compact)(),
        presentation-16-9: (_page_size.presentation-16-9)(),
        presentation-4-3: (_page_size.presentation-4-3)(),
        sac-d0: (_page_size.sac-d0)(),
        sac-d1: (_page_size.sac-d1)(),
        sac-d2: (_page_size.sac-d2)(),
        sac-d3: (_page_size.sac-d3)(),
        sac-d4: (_page_size.sac-d4)(),
        sac-d5: (_page_size.sac-d5)(),
        sac-d6: (_page_size.sac-d6)(),
        sis-e5: (_page_size.sis-e5)(),
        sis-g5: (_page_size.sis-g5)(),
        uk-book-a: (_page_size.uk-book-a)(),
        uk-book-b: (_page_size.uk-book-b)(),
        uk-brief: (_page_size.uk-brief)(),
        uk-crown: (_page_size.uk-crown)(),
        uk-draft: (_page_size.uk-draft)(),
        uk-foolscap: (_page_size.uk-foolscap)(),
        uk-quarto: (_page_size.uk-quarto)(),
        us-business-card: (_page_size.us-business-card)(),
        us-digest: (_page_size.us-digest)(),
        us-executive: (_page_size.us-executive)(),
        us-foolscap-folio: (_page_size.us-foolscap-folio)(),
        us-gov-legal: (_page_size.us-gov-legal)(),
        us-gov-letter: (_page_size.us-gov-letter)(),
        us-ledger: (_page_size.us-ledger)(),
        us-legal: (_page_size.us-legal)(),
        us-letter: (_page_size.us-letter)(),
        us-oficio: (_page_size.us-oficio)(),
        us-statement: (_page_size.us-statement)(),
        us-tabloid: (_page_size.us-tabloid)(),
        us-trade: (_page_size.us-trade)(),
        cn-is-degree-full: (_page_size.custom)(width: 787mm, height: 1092mm),
        cn-magnanimous-full: (_page_size.custom)(width: 889mm, height: 1194mm),
      )
  )

  _page_size
}

#let _margin_info = record(
  top: length,
  bottom: length,
  left: length,
  right: length,
)

#let _margin_info = impl_record(
  _margin_info,
  display: self => {
    it => {
      set page(margin: (
        top: self.top,
        bottom: self.bottom,
        left: self.left,
        right: self.right,
      ))
    }
  },
)

#let _margin_info = (
  _margin_info
    + (
      margin: len => (_margin_info.new)(top: len, bottom: len, left: len, right: len),
      xy: (x, y) => (_margin_info.new)(top: y, bottom: y, left: x, right: x),
    )
)

#let _numbering_style = enumerator(
  num: record(
    prefix: str,
    fmt: str,
    suffix: str,
  ),
  num_both: record(
    prefix: str,
    fmt: str,
    suffix: str,
    mid: str,
    final_fmt: str,
  ),
  fun: function,
  null: record(),
)

#let _numbering_style = impl_enum(
  _numbering_style,
  display: self => {
    it => {
      if (self.variant == "num") {
        set page(numbering: self.payload.prefix + self.payload.fmt + self.payload.suffix)
      } else if (self.variant == "num_both") {
        set page(
          numbering: self.payload.prefix
            + self.payload.fmt
            + self.payload.mid
            + self.payload.final_fmt
            + self.payload.suffix,
        )
      } else if (null == self.variant) {} else {
        set page(numbering: self.payload)
      }
      it
    }
  },
  render: self => context {
    if (self.variant == "num_both") {
      let p = self.payload
      counter(page).display(
        p.prefix + p.fmt + p.mid + p.final_fmt + p.suffix,
        both: true,
      )
    } else if (self.variant == "num") {
      counter(page).display()
    } else if (null == self.variant) {
      none
    } else {
      counter(page).display()
    }
  },
)

#let _numbering_style = (
  _numbering_style
    + (
      num: (_numbering_style.num).with(fmt: "1"),
      alpha: (_numbering_style.num).with(fmt: "a"),
      alpha_c: (_numbering_style.num).with(fmt: "A"),
      roman: (_numbering_style.num).with(fmt: "i"),
      roman_c: (_numbering_style.num).with(fmt: "I"),
      greek: (_numbering_style.num).with(fmt: "α"),
      greek_c: (_numbering_style.num).with(fmt: "Α"),
      cn: (_numbering_style.num).with(fmt: "一"),
      cn_c: (_numbering_style.num).with(fmt: "壹"),
      hiragana: (_numbering_style.num).with(fmt: "あ"),
      hiragana_ii: (_numbering_style.num).with(fmt: "い"),
      katakana: (_numbering_style.num).with(fmt: "ア"),
      katakana_ii: (_numbering_style.num).with(fmt: "イ"),
      hebrew: (_numbering_style.num).with(fmt: "א"),
      korean: (_numbering_style.num).with(fmt: "가"),
      korean_ii: (_numbering_style.num).with(fmt: "ㄱ"),
      symbol: (_numbering_style.num).with(fmt: "*"),
      arabic_indic: (_numbering_style.num).with(fmt: "١"),
      persian: (_numbering_style.num).with(fmt: "۱"),
      devanagari: (_numbering_style.num).with(fmt: "१"),
      bengali: (_numbering_style.num).with(fmt: "১"),
      bengali_alpha: (_numbering_style.num).with(fmt: "ক"),
      circled: (_numbering_style.num).with(fmt: "①"),
      circled_double: (_numbering_style.num).with(fmt: "⓵"),
      num_over_num: (_numbering_style.num_both).with(
        fmt: "1",
        mid: "/",
        final_fmt: "1",
      ),
    )
)

#let _page_info = record(
  size: _page_size,
  flipped: bool,
  margin: _margin_info,

  footer-descent: relative,
  header-ascent: relative,

  fill: color,
  background: img,
  foreground: img,

  footer: function,
  header: function,

  numbering: _numbering_style,

  supplement: str,
)

#let _page_info = impl_record(
  _page_info,
  display: self => {
    it => {
      let it = (self.margin.display)((self.size.display)(it))
      if self.background.variant == "path" {
        set page(background: self.background.payload)
      }
      if self.foreground.variant == "path" {
        set page(foreground: self.foreground.payload)
      }
      set page(flipped: self.flipped, header-ascent: self.header-ascent, footer-descent: self.footer-descent)
      it
    }
  },
)

text(
alternates: bool
baseline: length
bottom-edge: "baseline" | "bounds" | "descender" | length
cjk-latin-spacing: auto | none
costs: dictionary
dir: dir
discretionary-ligatures: bool
fallback: bool
features: array | dictionary
fill: color
font: array | text.font
fractions: bool
historical-ligatures: bool
hyphenate: auto | bool
kerning: bool
lang: text.lang
ligatures: bool
number-type: "lining" | "old-style" | auto
number-width: "proportional" | "tabular" | auto
overhang: bool
region: text.region
script: auto | str
size: text.size
slashed-zero: bool
spacing: relative
stretch: ratio
stroke: stroke
style: "italic" | "normal" | "oblique"
stylistic-set: array | int | none
top-edge: "ascender" | "baseline" | "bounds" | "cap-height" | "x-height" | length
tracking: length
weight: "black" | "bold" | "extrabold" | "extralight" | "light" | "medium" | "regular" | "semibold" | "thin" | int
) -> text
