---
layout: page
slug: collapse
roxygen:
  rdname: ~
  name: collapse
  doctype: ~
  title: Collapsible sections
  description: |-
    The `collapse()` function allows you to make a tag element collapsible. The
    state of the element, shown or hidden, is toggled using `hideCollapse()`,
    `showCollapse()`, and `toggleCollapse()`.
  parameters:
  - name: tag
    description: A tag element.
  - name: id
    description: |-
      A character string specifying an HTML id. Pass this id to the
      `*Collapse()` functions to hide or show the collapsible element.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      collapsible div.
  sections: ~
  examples:
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
          center = TRUE,
          buttonInput("toggle", "Toggle the card") %>%
            margin(3),
          card(
            "\"The Time Traveller (for so it will be convenient to speak
             of him) was expounding a recondite matter to us. His grey eyes
             shone and twinkled, and his usually pale face was flushed and
             animated. The fire burned brightly, and the soft radiance of
             the incandescent lights in the lilies of silver caught the
             bubbles that flashed and passed in our glasses.\""
          ) %>%
            background("grey") %>%
            collapse("mycollapse")
        ),
        server = function(input, output) {
          observeEvent(input$toggle, {
            toggleCollapse("mycollapse")
          })
        }
      )
    }
  - |
    if (interactive()) {
      shinyApp(
        ui = container(
          center = TRUE,
          buttonInput(
            id = "toggle",
            label = "Client-side toggle",
            `data-target` = "#mycollapse",
            `data-toggle` = "collapse"
          ) %>%
            margin(3),
          card(
            "If you do not need server-side control with the `*Collapse()`
             functions consider setting up a client-side collapse with
             `data-target` and `data-toggle='collapse'`, see
             https://getbootstrap.com/docs/4.1/components/collapse/
             for more about these attributes"
          ) %>%
            collapse("mycollapse")
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: collapse.R
  source: |-
    collapse <- function(tag, id, ...) {
        args <- list(...)
        attrs <- attribs(args)
        elems <- elements(args)
        if (length(attrs)) {
            names(attrs) <- paste0("data-collapse-", names(attrs))
        }
        attrs$`data-collapse-id` <- id
        tag <- shiny::tagAppendChildren(tag, list = elems)
        tag <- shiny::tagAppendChild(tag, include("core"))
        tag <- tagConcatAttributes(tag, attrs)
        tag
    }
---
