// Design tokens inspired by kodama's CSS variables

// - fonts
#let text-font = "Liberation Sans"
#let base-font-size = 11pt
#let heading-font-weight = 600
#let code-font = "Liberation Mono"

// - colors (warm, readable palette for note-taking)
#let text-color = rgb("#2d2d2d")
#let heading-color = rgb("#1a1a1a")
#let code-bg = luma(243)
#let slug-color = rgb("#888")
#let taxon-color = rgb("#555")
#let meta-color = rgb("#999")

// - blockquote
#let quote-bar-color = rgb("#c8c8c8")
#let quote-text-color = rgb("#666")

// - table
#let table-border-color = rgb("#ddd")
#let table-header-bg = luma(238)
#let table-alt-row-bg = luma(248)

// - accent
#let accent-color = rgb("#7a5ea7")

// - spacing
#let p-line-height = 1.6em
#let block-radius = 5pt
#let blockquote-radius = 3pt

// - stroke
#let dotted-stroke = (thickness: 0.5pt, dash: ("dot", 1pt))
#let hr-stroke = 0.5pt + rgb("#ccc")
