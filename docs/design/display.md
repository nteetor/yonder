---
name: display
title: Tag element display
description: |-
  Use the `display()` utility to adjust how a tag element is rendered. All
  arguments are responsive allowing you to hide elements on small screens or
  convert elements from inline to block on large screens.
parameters:
- name: tag
  description: A tag element.
- name: type
  description: |-
    A [responsive](layout/responsive.html) argument. One of `"inline"`, `"block"`,
    `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`.
family: design
export: ''
examples:
- title: Using flexbox
  body:
  - type: text
    content: When using `flex()` be sure to set the display, too.
    output: ~
  - type: code
    content: |-
      div(
        lapply(
          1:5,
          function(i) {
            div() %>%
              padding(5) %>%
              margin(top = c(xs = 2), bottom = c(xs = 2)) %>%
              background("blue")
          }
        )
      ) %>%
        display("flex") %>%
        flex(
          direction = c(xs = "column", sm = "row"),
          justify = c(sm = "around")
        )
    output: |-
      <div class="d-flex flex-column flex-sm-row justify-content-sm-around">
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
      </div>
rdname: display
sections: []
layout: doc
---
