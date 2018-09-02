---
this: column
filename: R/container.R
layout: page
roxygen:
  title: Grid layout
  description: |-
    These functions are the foundation of any application. Grid elements are
    nested as follows: `container > row > column ~ column`. Columns may be nested
    within columns. Columns may be created with an explicit width, 1 through 12.
    To fit a column automatically to its content use `width = "auto"`. To divide
    the space in a row evenly amongst all columns leave `width` as `NULL`. For
    examples and usage tips see the sections below.
  parameters:
  - name: '...'
    description: |-
      Any number of tags elements passed as child elements or named
      arguments passed as HTML attributes to the parent element.
  - name: width
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `1:12` or `"auto"`, defaults to
      `NULL`.
  - name: gutters
    description: |-
      One of `TRUE` or `FALSE` specifying if columns inside the row
      are padded, defaults to `TRUE`. If `FALSE` column content renders flush
      against the border of the column. Most often you will want to leave this
      `gutters` as `TRUE`.
  - name: center
    description: |-
      One of `TRUE` or `FALSE` specifying if the container is
      responsively centered or if the container occupies the entire width of the
      viewport, defaults to `FALSE`.
  sections:
  - title: Equal width columns
    body: |-
      ```
      container(
        row(
          column(
            "Aliquam erat volutpat."
          ),
          column(
            "Mauris mollis tincidunt felis."
          ),
          column(
            "Cum sociis natoque penatibus et magnis dis parturient montes,",
            "nascetur ridiculus mus."
          )
        )
      )
      ```
  - title: Shiny's panel with sidebar layout
    body: |-
      ```
      container(
        row(
          column(
            width = 4
          ),
          column()
        )
      )
      ```
  - title: Mobile friendly grids
    body: |-
      Use `column()`s [responsive](/yonder/0.0.5/responsive.html) `width` argument to make mobile friendly
      applications.

      ```
      container(
        row(
          column(
            width = c(sm = 4),
            "Mauris ac felis vel velit tristique imperdiet."
          ),
          column(
            width = c(sm = 4),
            "Nam vestibulum accumsan nisl."
          ),
          column(
            width = c(sm = 4),
            "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus."
          )
        )
      )
      ```

      ```
      container(
        row(
          column(
            width = c(sm = 4)
          ),
          column(
            width = c(sm = 8)
          )
        )
      )
      ```
  - title: Fit columns to their content
    body: |-
      ```
      container(
        row(
          column(),
          column(
            width = "auto",
            "Cras placerat accumsan nulla.  Aenean in sem ac leo mollis blandit."
          ),
          column()
        )
      )
      ```
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples: []
---
