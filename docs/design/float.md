---
name: float
title: Tag element float
description: |-
  Use `float()` to float an element to the left or right side of its parent
  element. A newspaper layout is a classic usage where an image is floated with
  text wrapped around.
parameters:
- name: .tag
  description: A tag element.
- name: side
  description: |-
    A [responsive](responsive.html) argument. One of `"left"` or `"right"` specifying
    the side to float the element.
family: design
export: ''
examples:
- title: Newspaper layout
  body:
  - type: code
    content: |-
      div(
        div() %>%
          height(3) %>%
          margin(right = 2) %>%
          background("amber") %>%
          float("left"),
        p(
          "Fusce commodo. Nullam tempus. Nunc rutrum turpis sed pede.",
          "Phasellus lacus.  Cras placerat accumsan nulla.",
          "Fusce sagittis, libero non molestie mollis, ",
          "magna orci ultrices dolor, at vulputate neque nulla lacinia eros."
        ),
        p(
          "Nulla facilisis, risus a rhoncus fermentum, tellus tellus",
          "lacinia purus, et dictum nunc justo sit amet elit."
        ),
        p(
          "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
          "Aliquam posuere.",
          "Sed id ligula quis est convallis tempor."
        )
      )
    output: "<div>\n  <div class=\"h-3 mr-2 bg-amber float-left\"></div>\n  <p>\n
      \   Fusce commodo. Nullam tempus. Nunc rutrum turpis sed pede.\n    Phasellus
      lacus.  Cras placerat accumsan nulla.\n    Fusce sagittis, libero non molestie
      mollis, \n    magna orci ultrices dolor, at vulputate neque nulla lacinia eros.\n
      \ </p>\n  <p>\n    Nulla facilisis, risus a rhoncus fermentum, tellus tellus\n
      \   lacinia purus, et dictum nunc justo sit amet elit.\n  </p>\n  <p>\n    Proin
      neque massa, cursus ut, gravida ut, lobortis eget, lacus.\n    Aliquam posuere.\n
      \   Sed id ligula quis est convallis tempor.\n  </p>\n</div>"
rdname: float
sections: []
layout: doc
---
