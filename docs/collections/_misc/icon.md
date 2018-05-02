---
layout: page
slug: icon
roxygen:
  rdname: ~
  name: icon
  doctype: ~
  title: Icon elements
  description: |-
    Include an icon in your application. For now only Font Awesome icons are
    included.
  parameters:
  - name: name
    description: A character string specifying the name of the icon.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: set
    description: |-
      A character string specifying the icon set to choose from, defaults
      to `"NULL"`, in which case all icon sets are searched.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          fluid = FALSE,
          selectInput(
            id = "name",
            choices = unique(.icons$name)
          ) %>%
            margins(3),
          div(
            htmlOutput("icon")
          ) %>%
            margins(3) %>%
            display("flex") %>%
            direction("column") %>%
            items("center")
        ),
        server = function(input, output) {
          output$icon <- renderUI({
            icon(input$name) %>%
              font("8x")
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          lapply(
            unique(.icons$set),
            function(s) {
              div(
                lapply(
                  unique(.icons[.icons$set == s, ]$name),
                  function(nm) {
                    icon(nm, set = s) %>%
                      margins(2)
                  }
                )
              ) %>%
                display("flex") %>%
                wrap("wrap")
            }
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: icons.R
  source: "icon <- function(name, ..., set = NULL) {\n    if (length(name) != 1) {\n
    \       stop(\"invalid `icon()` argument, `name` must be a single character string\",
    \n            call. = FALSE)\n    }\n    if (!is.null(set)) {\n        if (length(set)
    != 1) {\n            stop(\"invalid `icon()` argument, if specified `set` must
    be a single \", \n                \"character string\", call. = FALSE)\n        }\n
    \       if (!(set %in% .icons$set)) {\n            stop(\"invalid `icon()` argument,
    unknown icon set\", \n                \"\\\"\", set, \"\\\"\", call. = FALSE)\n
    \       }\n    }\n    index <- .icons$name == name & if (!is.null(set)) \n        .icons$set
    == set\n    else TRUE\n    icon <- head(.icons[index, ], 1)\n    if (NROW(icon)
    == 0) {\n        stop(\"in `icon()`, no icon found with name \\\"\", name, \n
    \           \"\\\"\", if (!is.null(set)) \n                paste0(\" in set \\\"\",
    set, \"\\\"\"), call. = FALSE)\n    }\n    if (icon$set == \"font awesome\") {\n
    \       tags$i(class = collate(icon$prefix, sprintf(\"fa-%s\", \n            icon$name),
    \"fa-fw\"), ..., include(\"font awesome\"))\n    }\n    else if (icon$set == \"material
    design\") {\n        tags$i(class = \"material-icons\", ..., icon$name, include(\"material
    icons\"))\n    }\n    else if (icon$set == \"feather\") {\n        tags$i(`data-feather`
    = icon$name, ..., tags$script(\"feather.replace()\"), \n            include(\"feather\"))\n
    \   }\n}"
---
