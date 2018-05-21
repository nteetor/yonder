---
layout: page
slug: font
roxygen:
  rdname: ~
  name: font
  doctype: ~
  title: Tag element font
  description: |-
    The `font()` utility may be used to change the color, size, or weight of a
    tag element's text font. Font size's are changed relative to the base font
    size of the web page.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the text color of the tag element,
      defaults to `NULL` in which case the text color is unchanged.
  - name: size
    description: |-
      One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
      increase a tag element's font size by (e.g. `"2x"` is double the base font
      size), defaults to `NULL`, in which case the font size is unchanged.
  - name: weight
    description: |-
      One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
      `"monospace"` specifying the font weight of the element's text, defaults to
      `NULL`, in which case the font weight is unchanged.
  - name: align
    description: |-
      A [responsive] argument. One of `"left"`, `"center"`, `"right"`,
      or `"justify"`.
  sections: ~
  examples:
  - |-
    span("This and other news") %>%
      font(weight = "light")
  - |-
    icon("anchor") %>%
      font(color = "blue", size = "5x")
  - |-
    p("Ipsum Consectetur Nibh Bibendum Ullamcorper") %>%
      font(size = "2x", weight = "italic")
  - |
    if (interactive()) {
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "body", "grey", "white"
      )

      shinyApp(
        ui = container(
          center = TRUE,
          lapply(
            head(colors, -1),
            font,
            tag = div("Pellentesque tristique imperdiet tortor.") %>%
              padding(5)
          ),
          div("Pellentesque tristique imperdiet tortor.") %>%
            padding(5) %>%
            background("grey") %>%
            font(tail(colors, 1))
        ) %>%
          display(flex = TRUE) %>%
          flex(wrap = TRUE),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "font <- function(.tag, color = NULL, size = NULL, weight = NULL, \n    align
    = NULL) {\n    if (color != \"body\" && !re(color, paste(.colors, collapse = \"|\")))
    {\n        stop(\"invalid `text` argument, `color` is invalid, see ?background
    \", \n            \"details for possible colors\", call. = FALSE)\n    }\n    if
    (!re(weight, \"bold|normal|light|italic|monospace\")) {\n        stop(\"invalid
    `text` argument, `weight` must be one of \", \n            \"\\\"bold\\\", \\\"normal\\\",
    \\\"light\\\", \\\"italic\\\", or \\\"monospace\\\"\", \n            call. = FALSE)\n
    \   }\n    if (!re(size, \"([2-9]|10)x\")) {\n        stop(\"invalid `size` argument,
    `size` must be one of \", \n            \"\\\"2x\\\" through \\\"10px\\\"\", call.
    = FALSE)\n    }\n    align <- ensureBreakpoints(align, c(\"left\", \"center\",
    \"right\", \n        \"justify\"))\n    if (!is.null(color)) {\n        .tag <-
    colorUtility(.tag, \"text\", color)\n    }\n    if (!is.null(size)) {\n        size
    <- paste0(\"font-size-\", size)\n        .tag <- tagDropClass(.tag, \"font-size-([2-9]|10)x\")\n
    \       .tag <- tagAddClass(.tag, size)\n    }\n    if (!is.null(weight)) {\n
    \       if (re(weight, \"bold|normal|light\")) {\n            weight <- paste0(\"font-weight-\",
    weight)\n        }\n        else {\n            weight <- paste0(\"font-\", weight)\n
    \       }\n        .tag <- tagDropClass(.tag, \"font-(weight-(bold|normal|light)|italic|monospace)\")\n
    \       .tag <- tagAddClass(.tag, weight)\n    }\n    if (length(align)) {\n        classes
    <- createResponsiveClasses(align, \"text\")\n        .tag <- tagAddClass(.tag,
    classes)\n    }\n    .tag\n}"
---
