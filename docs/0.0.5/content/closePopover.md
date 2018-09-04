---
this: closePopover
filename: R/popover.R
layout: page
roxygen:
  title: Display a popover
  description: |-
    Popovers are small windows of content associated with a tag element. Use
    `showPopover()` to add a popover to any tag element with an HTML id. This
    allows you to add explanations for inputs. Furthermore the [linkInput()](/yonder/0.0.5/linkInput().html)
    makes adding popovers to semi-plain text possible. Popovers are hidden with
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
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
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
    output: []
---
