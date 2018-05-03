---
layout: page
slug: accordion
roxygen:
  rdname: ~
  name: accordion
  doctype: ~
  title: Accordion panels
  description: |-
    Similar to `collapse`, `accordion` is a way to condense content. An accordion
    is made up of multiple panels. As one panel is toggled open other panels
    are closed. A page may render with multiple panels open, but once toggled
    only one panel will remain open.
  parameters:
  - name: labels
    description: |-
      A character vector or flat list of character strings specifying
      the link labels of the accordion panels.
  - name: contents
    description: A list of custom tags specifying the content of the panels.
  - name: ids
    description: |-
      A character vector or flat list of character strings specifying
      the HTML ids of the accordion panels, defaults to `NULL`, in which case
      ids are automatically generated.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              accordion(
                labels = c("Option 1", "Option 2", "Option 3"),
                contents = list(
                  tags$p("What do you think of option 1?"),
                  tags$p("What do you think of option 2?"),
                  tags$p("What do you think of option 3?")
                )
              )
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: accordion.R
  source:
  - accordion <- function(labels, contents, ids = NULL, ...) {
  - '  if (length(labels) != length(contents)) {'
  - '    stop('
  - '      "invalid `accordion` arguments, `labels` and `contents` must be the ",'
  - '      "same length", call. = FALSE'
  - '    )'
  - '  }'
  - '  ids <- ids %||% `map*`(labels, function(x) ID("panel"))'
  - '  if (length(ids) != length(labels)) {'
  - '    stop('
  - '      "invalid `accordion` arguments, `labels` and `ids` must be the same ",'
  - '      "length", call. = FALSE'
  - '    )'
  - '  }'
  - '  attrs <- attribs(list(...))'
  - '  attrs$id <- attrs[["id"]] %||% ID("accordion")'
  - '  tagConcatAttributes(tags$div('
  - '    `data-children` = ".accordion-item",'
  - '    lapply(seq_along(labels), function(i) {'
  - '      tags$div(class = "accordion-item", tags$a('
  - '        `data-toggle` = "collapse",'
  - '        `data-parent` = paste0("#", attrs$id), href = paste0('
  - '          "#",'
  - '          ids[[i]]'
  - '        ), `aria-expanded` = "false", `aria-controls` = ids[[i]],'
  - '        labels[[i]]'
  - '      ), tags$div('
  - '        id = ids[[i]], class = "collapse",'
  - '        role = "tabpanel", contents[[i]]'
  - '      ))'
  - '    }), include("core")'
  - '  ), attrs)'
  - '}'
---
