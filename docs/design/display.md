---
name: display
title: Tag element display
description: |-
  Use the `display()` utility to adjust how a tag element is rendered. All
  arguments are responsive allowing you to hide elements on small screens or
  convert elements from inline to block on large screens. Most of the time
  you will use the `render` argument. However if you want to control how an
  element appears (or does not appear) when the page is printed use the `print`
  argument.
parameters:
- name: .tag
  description: A tag element.
- name: render,print
  description: |-
    A [responsive](yonder/responsive.html) argument. One of `"inline"`, `"block"`,
    `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`, defaults to
    `NULL`.
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
- title: Printing pages
  body:
  - type: text
    content: This element is not shown when the page is printed.
    output: ~
  - type: code
    content: |-
      div() %>%
        height(4) %>%
        background("orange") %>%
        display(print = "none")  # <-
    output: <div class="h-4 bg-orange d-print-none"></div>
rdname: display
sections: []
layout: doc
---
