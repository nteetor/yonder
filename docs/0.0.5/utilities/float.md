---
this: float
filename: R/utilities.R
layout: page
roxygen:
  title: Tag element float
  description: |-
    Use `float()` to float an element to the left or right side of its parent
    element. A classic example using floats is a newspaper layout where text is
    wrapped around a picture.
  parameters:
  - name: .tag
    description: A tag element.
  - name: side
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"left"` or `"right"` specifying
      the side to float the element.
  sections:
  - title: Newspaper layout
    body: |-
      ```
      div(
        icon("table-tennis") %>%
          font(size = "5x") %>%
          padding(2) %>%
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
      ```
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples: []
---
