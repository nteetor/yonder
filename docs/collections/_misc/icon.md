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
  source:
  - icon <- function(name, ..., set = NULL) {
  - '  if (length(name) != 1) {'
  - '    stop('
  - '      "invalid `icon()` argument, `name` must be a single character string",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(set)) {'
  - '    if (length(set) != 1) {'
  - '      stop('
  - '        "invalid `icon()` argument, if specified `set` must be a single ",'
  - '        "character string", call. = FALSE'
  - '      )'
  - '    }'
  - '    if (!(set %in% .icons$set)) {'
  - '      stop('
  - '        "invalid `icon()` argument, unknown icon set",'
  - '        "\"", set, "\"", call. = FALSE'
  - '      )'
  - '    }'
  - '  }'
  - '  index <- .icons$name == name & if (!is.null(set)) {'
  - '    .icons$set == set'
  - '  } else {'
  - '    TRUE'
  - '  }'
  - '  icon <- head(.icons[index, ], 1)'
  - '  if (NROW(icon) == 0) {'
  - '    stop('
  - '      "in `icon()`, no icon found with name \"", name,'
  - '      "\"", if (!is.null(set)) {'
  - '        paste0(" in set \"", set, "\"")'
  - '      } , call. = FALSE'
  - '    )'
  - '  }'
  - '  if (icon$set == "font awesome") {'
  - '    tags$i(class = collate(icon$prefix, sprintf('
  - '      "fa-%s",'
  - '      icon$name'
  - '    ), "fa-fw"), ..., include("font awesome"))'
  - '  }'
  - '  else if (icon$set == "material design") {'
  - '    tags$i(class = "material-icons", ..., icon$name, include("material icons"))'
  - '  }'
  - '  else if (icon$set == "feather") {'
  - '    tags$i('
  - '      `data-feather` = icon$name, ..., tags$script("feather.replace()"),'
  - '      include("feather")'
  - '    )'
  - '  }'
  - '}'
---
