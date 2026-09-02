#import "record.typ": enum, impl, record
#import "meta.typ": _core_doc
#import "uid.typ": namespaces, v3
#import "state.typ": _mkstate

#let _ns_stlye = v3(namespaces.oid, "4cff74bd-1751-4de9-b29c-aa177649d4e9")
#let _style_uuid(name) = v3(_ns_stlye, name)

#let style = _mkstate(
  "123389fe-512d-499e-a357-a9bad0ca1926",
  (:),
)

#let page_info = record(
  width: length,
  height: length,
  margin_left: length,
  margin_right: length,
  margin_top: length,
  margin_bottom: length,
)

#let page_info = (
  page_info
    + {
      let a0 = (page_info.new)(
        width: 841mm,
        height: 1189mm,
        margin_left: 100.1mm,
        margin_right: 100.1mm,
        margin_top: 100.1mm,
        margin_bottom: 100.1mm,
      )
      let a1 = (page_info.new)(
        width: 594mm,
        height: 841mm,
        margin_left: 70.7mm,
        margin_right: 70.7mm,
        margin_top: 70.7mm,
        margin_bottom: 70.7mm,
      )
      let a2 = (page_info.new)(
        width: 420mm,
        height: 594mm,
        margin_left: 50mm,
        margin_right: 50mm,
        margin_top: 50mm,
        margin_bottom: 50mm,
      )
      let a3 = (page_info.new)(
        width: 297mm,
        height: 420mm,
        margin_left: 35.4mm,
        margin_right: 35.4mm,
        margin_top: 35.4mm,
        margin_bottom: 35.4mm,
      )
      let a4 = (page_info.new)(
        width: 210mm,
        height: 297mm,
        margin_left: 25mm,
        margin_right: 25mm,
        margin_top: 25mm,
        margin_bottom: 25mm,
      )
      let a5 = (page_info.new)(
        width: 148mm,
        height: 210mm,
        margin_left: 17.6mm,
        margin_right: 17.6mm,
        margin_top: 17.6mm,
        margin_bottom: 17.6mm,
      )
      let a6 = (page_info.new)(
        width: 105mm,
        height: 148mm,
        margin_left: 12.5mm,
        margin_right: 12.5mm,
        margin_top: 12.5mm,
        margin_bottom: 12.5mm,
      )
      let a7 = (page_info.new)(
        width: 74mm,
        height: 105mm,
        margin_left: 8.8mm,
        margin_right: 8.8mm,
        margin_top: 8.8mm,
        margin_bottom: 8.8mm,
      )
      let a8 = (page_info.new)(
        width: 52mm,
        height: 74mm,
        margin_left: 6.2mm,
        margin_right: 6.2mm,
        margin_top: 6.2mm,
        margin_bottom: 6.2mm,
      )
      let a9 = (page_info.new)(
        width: 37mm,
        height: 52mm,
        margin_left: 4.4mm,
        margin_right: 4.4mm,
        margin_top: 4.4mm,
        margin_bottom: 4.4mm,
      )
      let a10 = (page_info.new)(
        width: 26mm,
        height: 37mm,
        margin_left: 3.1mm,
        margin_right: 3.1mm,
        margin_top: 3.1mm,
        margin_bottom: 3.1mm,
      )

      let b0 = (page_info.new)(
        width: 1000mm,
        height: 1414mm,
        margin_left: 119.0mm,
        margin_right: 119.0mm,
        margin_top: 119.0mm,
        margin_bottom: 119.0mm,
      )
      let b1 = (page_info.new)(
        width: 707mm,
        height: 1000mm,
        margin_left: 84.2mm,
        margin_right: 84.2mm,
        margin_top: 84.2mm,
        margin_bottom: 84.2mm,
      )
      let b2 = (page_info.new)(
        width: 500mm,
        height: 707mm,
        margin_left: 59.5mm,
        margin_right: 59.5mm,
        margin_top: 59.5mm,
        margin_bottom: 59.5mm,
      )
      let b3 = (page_info.new)(
        width: 353mm,
        height: 500mm,
        margin_left: 42.0mm,
        margin_right: 42.0mm,
        margin_top: 42.0mm,
        margin_bottom: 42.0mm,
      )
      let b4 = (page_info.new)(
        width: 250mm,
        height: 353mm,
        margin_left: 29.8mm,
        margin_right: 29.8mm,
        margin_top: 29.8mm,
        margin_bottom: 29.8mm,
      )
      let b5 = (page_info.new)(
        width: 176mm,
        height: 250mm,
        margin_left: 21.0mm,
        margin_right: 21.0mm,
        margin_top: 21.0mm,
        margin_bottom: 21.0mm,
      )
      let b6 = (page_info.new)(
        width: 125mm,
        height: 176mm,
        margin_left: 14.9mm,
        margin_right: 14.9mm,
        margin_top: 14.9mm,
        margin_bottom: 14.9mm,
      )
      let b7 = (page_info.new)(
        width: 88mm,
        height: 125mm,
        margin_left: 10.5mm,
        margin_right: 10.5mm,
        margin_top: 10.5mm,
        margin_bottom: 10.5mm,
      )
      let b8 = (page_info.new)(
        width: 62mm,
        height: 88mm,
        margin_left: 7.4mm,
        margin_right: 7.4mm,
        margin_top: 7.4mm,
        margin_bottom: 7.4mm,
      )
      let b9 = (page_info.new)(
        width: 44mm,
        height: 62mm,
        margin_left: 5.2mm,
        margin_right: 5.2mm,
        margin_top: 5.2mm,
        margin_bottom: 5.2mm,
      )
      let b10 = (page_info.new)(
        width: 31mm,
        height: 44mm,
        margin_left: 3.7mm,
        margin_right: 3.7mm,
        margin_top: 3.7mm,
        margin_bottom: 3.7mm,
      )

      let c0 = (page_info.new)(
        width: 917mm,
        height: 1297mm,
        margin_left: 109.2mm,
        margin_right: 109.2mm,
        margin_top: 109.2mm,
        margin_bottom: 109.2mm,
      )
      let c1 = (page_info.new)(
        width: 648mm,
        height: 917mm,
        margin_left: 77.1mm,
        margin_right: 77.1mm,
        margin_top: 77.1mm,
        margin_bottom: 77.1mm,
      )
      let c2 = (page_info.new)(
        width: 458mm,
        height: 648mm,
        margin_left: 54.5mm,
        margin_right: 54.5mm,
        margin_top: 54.5mm,
        margin_bottom: 54.5mm,
      )
      let c3 = (page_info.new)(
        width: 324mm,
        height: 458mm,
        margin_left: 38.6mm,
        margin_right: 38.6mm,
        margin_top: 38.6mm,
        margin_bottom: 38.6mm,
      )
      let c4 = (page_info.new)(
        width: 229mm,
        height: 324mm,
        margin_left: 27.3mm,
        margin_right: 27.3mm,
        margin_top: 27.3mm,
        margin_bottom: 27.3mm,
      )
      let c5 = (page_info.new)(
        width: 162mm,
        height: 229mm,
        margin_left: 19.3mm,
        margin_right: 19.3mm,
        margin_top: 19.3mm,
        margin_bottom: 19.3mm,
      )
      let c6 = (page_info.new)(
        width: 114mm,
        height: 162mm,
        margin_left: 13.6mm,
        margin_right: 13.6mm,
        margin_top: 13.6mm,
        margin_bottom: 13.6mm,
      )
      let c7 = (page_info.new)(
        width: 81mm,
        height: 114mm,
        margin_left: 9.6mm,
        margin_right: 9.6mm,
        margin_top: 9.6mm,
        margin_bottom: 9.6mm,
      )
      let c8 = (page_info.new)(
        width: 57mm,
        height: 81mm,
        margin_left: 6.8mm,
        margin_right: 6.8mm,
        margin_top: 6.8mm,
        margin_bottom: 6.8mm,
      )
      let c9 = (page_info.new)(
        width: 40mm,
        height: 57mm,
        margin_left: 4.8mm,
        margin_right: 4.8mm,
        margin_top: 4.8mm,
        margin_bottom: 4.8mm,
      )
      let c10 = (page_info.new)(
        width: 28mm,
        height: 40mm,
        margin_left: 3.3mm,
        margin_right: 3.3mm,
        margin_top: 3.3mm,
        margin_bottom: 3.3mm,
      )

      let letter = (page_info.new)(
        width: 8.5in,
        height: 11in,
        margin_left: 1.01in,
        margin_right: 1.01in,
        margin_top: 1.01in,
        margin_bottom: 1.01in,
      )
      let legal = (page_info.new)(
        width: 8.5in,
        height: 14in,
        margin_left: 1.01in,
        margin_right: 1.01in,
        margin_top: 1.01in,
        margin_bottom: 1.01in,
      )
      let tabloid = (page_info.new)(
        width: 11in,
        height: 17in,
        margin_left: 1.31in,
        margin_right: 1.31in,
        margin_top: 1.31in,
        margin_bottom: 1.31in,
      )
      let ledger = (page_info.new)(
        width: 17in,
        height: 11in,
        margin_left: 1.31in,
        margin_right: 1.31in,
        margin_top: 1.31in,
        margin_bottom: 1.31in,
      ) // 注意与 tabloid 方向不同
      let executive = (page_info.new)(
        width: 7.25in,
        height: 10.5in,
        margin_left: 0.86in,
        margin_right: 0.86in,
        margin_top: 0.86in,
        margin_bottom: 0.86in,
      )
      let folio = (page_info.new)(
        width: 8.5in,
        height: 13in,
        margin_left: 1.01in,
        margin_right: 1.01in,
        margin_top: 1.01in,
        margin_bottom: 1.01in,
      )
      let statement = (page_info.new)(
        width: 5.5in,
        height: 8.5in,
        margin_left: 0.66in,
        margin_right: 0.66in,
        margin_top: 0.66in,
        margin_bottom: 0.66in,
      )
      let quarto = (page_info.new)(
        width: 8.5in,
        height: 10.83in,
        margin_left: 1.01in,
        margin_right: 1.01in,
        margin_top: 1.01in,
        margin_bottom: 1.01in,
      )

      (
        pages: (
          a1: a1,
          a2: a2,
          a3: a3,
          a4: a4,
          a5: a5,
          a6: a6,
          a7: a7,
          a8: a8,
          a9: a9,
          a10: a10,
          b1: b1,
          b2: b2,
          b3: b3,
          b4: b4,
          b5: b5,
          b6: b6,
          b7: b7,
          b8: b8,
          b9: b9,
          b10: b10,
          c1: c1,
          c2: c2,
          c3: c3,
          c4: c4,
          c5: c5,
          c6: c6,
          c7: c7,
          c8: c8,
          c9: c9,
          c10: c10,
          letter: letter,
          legal: legal,
          tabloid: tabloid,
          ledger: ledger,
          executive: executive,
          folio: folio,
          statement: statement,
          quarto: quarto,
        ),
      )
    }
)

text(
text: str,
alternates: bool,
baseline: length,
body: content,
bottom-edge: "baseline" | "bounds" | "descender" | length,
cjk-latin-spacing: auto | none,
costs: dictionary,
dir: dir,
discretionary-ligatures: bool,
fallback: bool,
features: array | dictionary,
fill: color,
font: array | text.font,
fractions: bool,
historical-ligatures: bool,
hyphenate: auto | bool,
kerning: bool,
lang: text.lang,
ligatures: bool,
number-type: "lining" | "old-style" | auto,
number-width: "proportional" | "tabular" | auto,
overhang: bool,
region: text.region,
script: auto | str,
size: text.size,
slashed-zero: bool,
spacing: relative,
stretch: ratio,
stroke: stroke,
style: "italic" | "normal" | "oblique",
stylistic-set: array | int | none,
top-edge: "ascender" | "baseline" | "bounds" | "cap-height" | "x-height" | length,
tracking: length,
weight: "black" | "bold" | "extrabold" | "extralight" | "light" | "medium" | "regular" | "semibold" | "thin" | int
) -> text


#let _text_style = impl(
  record(
    font: str,
    size: length,
    spacing: length,
    fill: color,
    style: str,
    weight: str,
    stretch: str,
    tracking: length,
    fallback: str,
  ),
  display: self => {
    it => {
      set text(font: self.font, size: self.size, spacing: self.spacing)
      it
    }
  },
)
#let _text_style = (
  _text_style
    + (
      default: (_text_style.new)(
        font: "Libertinus Serif",
        size: 11pt,
        fill: black,
        style: "normal",
        weight: "regular",
        stretch: "normal",
        tracking: 0pt,
        fallback: "Deja Vu Sans Mono",
      ),
    )
)
// TODO:
#let _text_style = impl(
  _text_style,
  render: self => {
    show text: set text(
      font: self.font,
      size: 11pt,
      fill: black,
      style: "normal",
      weight: "regular",
      stretch: "normal",
      tracking: 0pt,
      fallback: "",
    )
  },
)

#let _link_style = record(
  font: str,
  size: length,
  fill: color,
  style: str,
  weight: str,
  stretch: str,
  tracking: length,
  fallback: str,
  hyphenate: bool,
  underline: bool,
)
#let _link_style = (
  _link_style
    + (
      default: (_link_style.new)(
        font: "",
        size: 11pt,
        fill: blue,
        style: "normal",
        weight: "regular",
        stretch: "normal",
        tracking: 0pt,
        fallback: "",
        hyphenate: true,
        underline: true,
      ),
    )
)

// Heading style record
#let _heading_style = record(
  font: str,
  size: length,
  fill: color,
  style: str,
  weight: str,
  stretch: str,
  tracking: length,
  fallback: str,
  numbering: str,
  supplement: str,
  outlined: bool,
  render: function,
)
#let _heading_style = (
  _heading_style
    + (
      default: (
        "1": (_heading_style.new)(
          font: "",
          size: 24pt,
          fill: black,
          style: "normal",
          weight: "bold",
          stretch: "normal",
          tracking: 0pt,
          fallback: "",
          numbering: "1.",
          supplement: "Chapter",
          outlined: true,
          render: doc => [= #doc.title],
        ),
        "2": (_heading_style.new)(
          font: "",
          size: 18pt,
          fill: black,
          style: "normal",
          weight: "bold",
          stretch: "normal",
          tracking: 0pt,
          fallback: "",
          numbering: "1.1",
          supplement: "Section",
          outlined: true,
          render: doc => [== #doc.title],
        ),
        "3": (_heading_style.new)(
          font: "",
          size: 14pt,
          fill: black,
          style: "normal",
          weight: "bold",
          stretch: "normal",
          tracking: 0pt,
          fallback: "",
          numbering: "1.1.1",
          supplement: "Subsection",
          outlined: true,
          render: doc => [=== #doc.title],
        ),
      ),
    )
)

#let _footnote_numbering_style = enum(
  continuous: (),
  paged: (),
)
#let _footnote_style = record(
  numbering: _footnote_numbering_style,
  style: str,
)
#let _footnote_style = (
  _footnote_style
    + (
      default: (_footnote_style.new)(
        numbering: (_footnote_numbering_style.continuous)(),
        style: "",
      ),
    )
)

// Style global record - defines book-wide styles
#let _style_global = record(
  text: _text_style,
  heading: dictionary,
  title: _text_style,
  abstract: _text_style,
  keyword: _text_style,
  link: _link_style,
  header: content,
  footer: content,
  footnote: _footnote_style,
  page: page_info,
  flipped: bool,
  bleed: length,
  standalone_doc: bool,
  verso_blank: bool,
  the_book: _core_doc,
  flyleaf: content,
  half_title_page: content,
  dedication: content,
  rear_endpaper: content,
)

