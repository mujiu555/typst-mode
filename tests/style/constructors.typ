// Function tests: page-size constructors, margin/xy, numbering constructors.
// Manual: typst compile --root . tests/style/constructors.typ /tmp/style-constructors.pdf
#import "/lib/_lib.typ/style.typ": _page_size, _margin_info, _numbering_style
#assert.eq(_page_size.a4.variant, "a4")
#let custom = (_page_size.custom)(width: 100mm, height: 200mm)
#assert.eq((custom.fields)(), (width: 100mm, height: 200mm))
#assert.eq((((_margin_info.margin)(1cm)).fields)(), (top: 1cm, bottom: 1cm, left: 1cm, right: 1cm))
#assert.eq((((_margin_info.xy)(1cm, 2cm)).fields)(), (top: 2cm, bottom: 2cm, left: 1cm, right: 1cm))
#assert.eq((_numbering_style.roman)(prefix: "(", suffix: ")").payload.fmt, "i")
#let both = (_numbering_style.num_over_num)(prefix: "", suffix: "")
#assert.eq((both.fields)(), (prefix: "", fmt: "1", suffix: "", mid: "/", final_fmt: "1"))
