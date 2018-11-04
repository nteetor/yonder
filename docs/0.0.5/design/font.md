---
this: font
filename: R/design.R
layout: page
requires: ~
roxygen:
  title: Tag element font
  description: |-
    The `font()` utility may be used to change the color, size, or weight of a
    tag element's text font. Font size's are changed relative to the base font
    size of the web page.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the text color of the tag element,
      defaults to `NULL` in which case the text color is unchanged.
  - name: size
    description: |-
      One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
      increase a tag element's font size by (e.g. `"2x"` is double the base font
      size), defaults to `NULL`, in which case the font size is unchanged.
  - name: weight
    description: |-
      One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
      `"monospace"` specifying the font weight of the element's text, defaults to
      `NULL`, in which case the font weight is unchanged.
  - name: align
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"left"`, `"center"`, `"right"`,
      or `"justify"`.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Possible colors</h3>
  - type: source
    value: |2-

      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "body", "grey", "white"
      )

      div(
        lapply(
          head(colors, -1),
          font,
          .tag = div("Pellentesque tristique imperdiet tortor.") %>%
            padding(5)
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="p-5 text-red">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-purple">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-indigo">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-blue">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-cyan">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-teal">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-green">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-yellow">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-amber">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-orange">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-body">Pellentesque tristique imperdiet tortor.</div>
        <div class="p-5 text-grey">Pellentesque tristique imperdiet tortor.</div>
      </div>
---
