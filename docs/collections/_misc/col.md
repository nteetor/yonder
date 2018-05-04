---
layout: page
slug: col
roxygen:
  rdname: ~
  name: col
  doctype: ~
  title: Grid system and responsive layout
  description: 'Build apps using the grid layout: containers, rows, and columns (oh
    my).'
  parameters:
  - name: '...'
    description: |-
      Any number of child elements or named arguments passed as HTML
      attributes to the parent element. `row`s need to be placed inside a
      `container`. A `row` typically contains only `col`s. A `col` may contain
      other `col`s or other elements.
  - name: tag
    description: A tag element, for `col` this is typically `tags$div()`.
  - name: default
    description: |-
      A number 1 through 12 or `"auto"` specifying the default
      width of the column. Columns with width `"auto"` equally divide space or
      fill remaining space when used with other columns.
  - name: sm
    description: |-
      Like `default`, but the width is applied once the viewport is 576
      pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the width is applied once the viewport is 768
      pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the width is applied once the viewport is 992
      pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the width is applied once the viewport is 1200
      pixels wide, think large desktop.
  - name: fluid
    description: |-
      One of `TRUE` or `FALSE` specifying if the container occupies
      the entire width of the viewport, defaults to `TRUE`, in which case the
      container occupies the full width of the viewport.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col("1 of 2") %>%
              border(),
            col("2 of 2") %>%
              border()
          ),
          row(
            lapply(
              1:3,
              . %>%
                paste("of 3") %>%
                col() %>%
                border()
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col("1 or 3") %>%
              border(),
            col("2 of 3", default = 6) %>%
              border(),
            col("3 of 3") %>%
              border()
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: container.R
  source: "col <- function(..., default = NULL, sm = NULL, md = NULL, lg = NULL, \n
    \   xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md =
    md, \n        lg = lg, xl = xl))\n    if (length(args) == 0) {\n        return(tagAddClass(tags$div(...),
    \"col\"))\n    }\n    classes <- responsives(prefix = \"col\", values = args,
    possible = c(as.character(1:12), \n        \"auto\"))\n    classes <- sub(\"-(sm|md|lg|xl)-auto\",
    \"\", classes)\n    classes <- sort(unique(c(\"col\", classes)))\n    tagAddClass(tags$div(...),
    collate(classes))\n}"
---
