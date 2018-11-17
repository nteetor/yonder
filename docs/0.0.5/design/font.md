---
this: font
filename: R/design.R
layout: page
requires: ~
roxygen:
  title: Tag element font
  description: |-
    The `font()` utility modifies the color, size, weight, case, or alignment of
    a tag element's text. All arguments default to `NULL`, in which case they are
    ignored.  For example, `font(size = "lg")` increases font size without
    affecting color, weight, case, or alignment.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      One `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
      `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`,
      `"black"`, or `"white"` specifying the color the tag element's text,
      defaults to `NULL`.
  - name: size
    description: |-
      One of `"xs"`, `"sm"`, `"base"`, `"lg"`, `"xl"` specifying a font
      size relative to the default base page font size, defaults to `NULL`.
  - name: weight
    description: |-
      One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
      `"monospace"` specifying the font weight of the element's text, defaults to
      `NULL`.
  - name: case
    description: |-
      One of `"upper"`, `"lower"`, or `"title"` specifying a
      transformation of the tag element's text, default to `NULL`.
  - name: align
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"left"`, `"center"`, `"right"`,
      or `"justify"`, specifying the alignment of the tag element's text, defaults
      to `NULL`.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Changing text color</h3>
  - type: source
    value: |2-

      card(
        header = h3("Important!") %>%
          font(color = "amber"),
        div(
          "This is a reminder."
        )
      ) %>%
        border(color = "amber")
  - type: output
    value: |-
      <div class="card border border-amber">
        <h3 class="text-amber card-header">Important!</h3>
        <div class="card-body">
          <div>This is a reminder.</div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Changing font size</h3>
  - type: source
    value: |2-

      div(
        p("Donec at pede.") %>%
          font(size = "xs"),
        p("Donec at pede.") %>%
          font(size = "sm"),
        p("Donec at pede.") %>%
          font(size = "base"),
        p("Donec at pede.") %>%
          font(size = "lg"),
        p("Donec at pede.") %>%
          font(size = "xl")
      )
  - type: output
    value: |-
      <div>
        <p class="font-size-xs">Donec at pede.</p>
        <p class="font-size-sm">Donec at pede.</p>
        <p class="font-size-base">Donec at pede.</p>
        <p class="font-size-lg">Donec at pede.</p>
        <p class="font-size-xl">Donec at pede.</p>
      </div>
  - type: markdown
    value: |
      <h3>Changing font weight</h3>
  - type: source
    value: |2-

      p("Curabitur lacinia pulvinar nibh.") %>%
        font(weight = "bold")
  - type: output
    value: <p class="font-weight-bold">Curabitur lacinia pulvinar nibh.</p>
---
