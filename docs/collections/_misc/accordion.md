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
  source: "accordion <- function(labels, contents, ids = NULL, ...) {\n    if (length(labels)
    != length(contents)) {\n        stop(\"invalid `accordion` arguments, `labels`
    and `contents` must be the \", \n            \"same length\", call. = FALSE)\n
    \   }\n    ids <- ids %||% `map*`(labels, function(x) ID(\"panel\"))\n    if (length(ids)
    != length(labels)) {\n        stop(\"invalid `accordion` arguments, `labels` and
    `ids` must be the same \", \n            \"length\", call. = FALSE)\n    }\n    attrs
    <- attribs(list(...))\n    attrs$id <- attrs[[\"id\"]] %||% ID(\"accordion\")\n
    \   tagConcatAttributes(tags$div(`data-children` = \".accordion-item\", \n        lapply(seq_along(labels),
    function(i) {\n            tags$div(class = \"accordion-item\", tags$a(`data-toggle`
    = \"collapse\", \n                `data-parent` = paste0(\"#\", attrs$id), href
    = paste0(\"#\", \n                  ids[[i]]), `aria-expanded` = \"false\", `aria-controls`
    = ids[[i]], \n                labels[[i]]), tags$div(id = ids[[i]], class = \"collapse\",
    \n                role = \"tabpanel\", contents[[i]]))\n        }), include(\"core\")),
    attrs)\n}"
---
