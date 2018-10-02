---
this: float
filename: R/design.R
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
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Newspaper layout</h3>
  - type: source
    value: |2-

      div(
        div() %>%
          padding(5) %>%
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
  - type: output
    value: "<div>\n  <div class=\"p-5 mr-2 bg-amber float-left\"></div>\n  <p>\n    Fusce
      commodo. Nullam tempus. Nunc rutrum turpis sed pede.\n    Phasellus lacus.  Cras
      placerat accumsan nulla.\n    Fusce sagittis, libero non molestie mollis, \n
      \   magna orci ultrices dolor, at vulputate neque nulla lacinia eros.\n  </p>\n
      \ <p>\n    Nulla facilisis, risus a rhoncus fermentum, tellus tellus\n    lacinia
      purus, et dictum nunc justo sit amet elit.\n  </p>\n  <p>\n    Proin neque massa,
      cursus ut, gravida ut, lobortis eget, lacus.\n    Aliquam posuere.\n    Sed
      id ligula quis est convallis tempor.\n  </p>\n</div>"
---
