---
layout: page
slug: show-popover
roxygen:
  rdname: ~
  name: showPopover
  doctype: ~
  title: Display a popover
  description: |-
    Popovers are small windows of content associated with a tag element. Use
    `howPopover()` to add a popover to any tag element with an HTML id. This
    allows you to add explanations for inputs. Furthermore the [linkInput()]
    makes explanations of semi-plain text possible. Popovers are hidden with
    `closePopover()`.
  parameters:
  - name: id
    description: |-
      A character string specifying the HTML id of a popover's target tag
      element.
  - name: content
    description: |-
      A character string or tag element specifying the content of
      the popover.
  - name: title
    description: |-
      A character string specifying a title for the popover, defaults
      to `NULL`, in which case a title is not added.
  - name: placement
    description: |-
      One of `"top"`, `"left"`, `"bottom"`, or `"right"`
      specifying where the popover is positioned relative to the target tag
      element indicated by `id`.
  - name: duration
    description: |-
      A positive integer specifying the duration of the popover
      in seconds or `NULL`, in which case the popover is not automatically
      removed. When `NULL` is specified the popover can be removed with
      `closePopover()`.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          buttonInput("click", "Button"),
          buttonInput("close", icon("times")) %>%
            background("red")
        ),
        server = function(input, output) {
          observeEvent(input$click, {
            showPopover(
              id = "click",
              text = "This is a button!",
              placement = "bottom",
              duration = NULL
            )
          })

          observeEvent(input$close, {
            closePopover("click")
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: popover.R
  source: "showPopover <- function(id, content, title = NULL, placement = \"top\",
    \n    duration = 4) {\n    domain <- getDefaultReactiveDomain()\n    if (is.null(domain))
    {\n        stop(\"function `showPopover()` must be called in a reactive context\",
    \n            call. = FALSE)\n    }\n    domain$sendCustomMessage(\"dull:popover\",
    list(type = \"show\", \n        id = id, data = list(content = HTML(content),
    title = title, \n            placement = placement, duration = if (!is.null(duration))
    duration * \n                1000)))\n}"
---
