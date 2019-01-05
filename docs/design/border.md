---
name: border
title: Tag element borders
description: Use `border()` to add or modify tag element borders.
parameters:
- name: .tag
  description: A tag element.
- name: color
  description: |-
    One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
    `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`, `"white"`
    specifying the border color, defaults to `NULL`.
- name: sides
  description: |-
    One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
    `"all"` or `"none"` specifying which sides to add a border to, defaults to
    `"all"`.
- name: round
  description: |-
    One or more of `"top"`, `"right"`, `"bottom"`, `"left"`,
    `"circle"`, `"all"`, or `"none"` specifying how to round the border(s) of a
    tag element, defaults to `NULL`, in which case the argument is ignored.
family: design
export: ''
examples:
- title: Change border color
  body:
  - type: code
    content: |-
      div(
        div() %>%
          height(3) %>%
          width(3) %>%
          border("green"),
        div() %>%
          height(3) %>%
          width(3) %>%
          border(
            color = "blue",
            sides = c("left", "right")
          )
      )
    output: |-
      <div>
        <div class="h-3 w-3 border border-green"></div>
        <div class="h-3 w-3 border-left border-right border-blue"></div>
      </div>
- title: Round sides
  body:
  - type: code
    content: |-
      sides <- c("top", "right", "bottom", "left", "circle", "all")

      div(
        lapply(
          sides,
          border,
          .tag = div() %>%
            height(3) %>%
            width(3),
          color = "black"
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <div class="h-3 w-3 border-top border-black"></div>
        <div class="h-3 w-3 border-right border-black"></div>
        <div class="h-3 w-3 border-bottom border-black"></div>
        <div class="h-3 w-3 border-left border-black"></div>
        <div class="h-3 w-3 border-circle border-black"></div>
        <div class="h-3 w-3 border border-black"></div>
      </div>
rdname: border
sections: []
layout: doc
---
