---
layout: page
slug: background
roxygen:
  rdname: ~
  name: background
  doctype: ~
  title: Tag element background color
  description: Use `background()` to change the background color of a tag element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the background color, see below
      for all possible values.
  sections: ~
  examples:
  - |-
    div("Nullam eu ante vel est convallis dignissim.") %>%
      background("grey")
  - |-
    checkbarInput(
      id = NULL,
      choices = c(
        "Nunc rutrum turpis sed pede.",
        "Etiam vel neque.",
        "Lorem ipsum dolor sit amet."
      )
    ) %>%
      background("cyan")
  - |
    if (interactive()) {
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      shinyApp(
        ui = container(
          center = TRUE,
          lapply(
            colors,
            background,
            tag = div() %>%
              padding(5) %>%
              margin(2)
          )
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
  source: "background <- function(.tag, color) {\n    if (!(color %in% c(.colors,
    \"transparent\"))) {\n        stop(\"invalid `background` argument, `color` is
    invalid, see ?background \", \n            \"details for possible colors\", call.
    = FALSE)\n    }\n    if (color == \"transparent\") {\n        base <- \"bg\"\n
    \   }\n    else if (tagHasClass(.tag, \"alert\")) {\n        base <- \"alert\"\n
    \   }\n    else if (tagHasClass(.tag, \"badge\")) {\n        base <- \"badge\"\n
    \   }\n    else if (tagHasClass(.tag, \"btn\")) {\n        base <- \"btn\"\n    }\n
    \   else if (tagHasClass(.tag, \"list-group-item\")) {\n        base <- \"list-group-item\"\n
    \   }\n    else {\n        base <- \"bg\"\n    }\n    colorUtility(.tag, base,
    color)\n}"
---
