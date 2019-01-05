---
name: font
title: Tag element font
description: |-
  The `font()` utility modifies the color, size, weight, case, or alignment of
  a tag element's text. All arguments default to `NULL`, in which case they are
  ignored.  For example, `font(.., size = "lg")` increases font size without
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
    A [responsive](/responsive.html) argument. One of `"left"`, `"center"`, `"right"`,
    or `"justify"`, specifying the alignment of the tag element's text, defaults
    to `NULL`.
family: design
export: ''
examples:
- title: Changing text color
  body:
  - type: code
    content: |-
      card(
        header = h3("Important!") %>%
          font(color = "amber"),
        div(
          "This is a reminder."
        )
      ) %>%
        border(color = "amber")
    output: |-
      <div class="card border border-amber">
        <h3 class="text-amber card-header">Important!</h3>
        <div class="card-body">
          <div>This is a reminder.</div>
        </div>
      </div>
- title: Changing font size
  body:
  - type: code
    content: |-
      div(
        p("Extra small") %>%
          font(size = "xs"),
        p("Small") %>%
          font(size = "sm"),
        p("Medium") %>%
          font(size = "base"),
        p("Large") %>%
          font(size = "lg"),
        p("Extra large") %>%
          font(size = "xl")
      )
    output: |-
      <div>
        <p class="font-size-xs">Extra small</p>
        <p class="font-size-sm">Small</p>
        <p class="font-size-base">Medium</p>
        <p class="font-size-lg">Large</p>
        <p class="font-size-xl">Extra large</p>
      </div>
- title: Changing font weight
  body:
  - type: text
    content: Make an element's text bold, italic, light, or monospace.
    output: ~
  - type: code
    content: |-
      p("Curabitur lacinia pulvinar nibh.") %>%
        font(weight = "bold")

      p("Proin quam nisl, tincidunt et.") %>%
        font(weight = "light")
    output: <p class="font-weight-light">Proin quam nisl, tincidunt et.</p>
rdname: font
sections: []
layout: doc
---
